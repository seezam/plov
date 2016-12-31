//
//  PLTracking.m
//  plov.com
//
//  Created by Vladimir Kubyshev on 26/11/15.
//  Copyright © 2015 plov.com. All rights reserved.
//

#import "PLTracking.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import <OneSignal/OneSignal.h>

#import "TAGContainer.h"
#import "TAGContainerOpener.h"
#import "TAGManager.h"
#import "TAGDataLayer.h"

#import "MenuObject.h"
#import "OrderObject.h"
#import "OrderItemObject.h"
#import "MenuCategoryObject.h"
#import "MenuItemObject.h"

@interface PLTracking ()<TAGContainerOpenerNotifier>

@property (nonatomic, strong) TAGManager *tagManager;
@property (nonatomic, strong) TAGContainer *container;

@end

@implementation PLTracking

- (instancetype)initAtStart:(NSDictionary *)launchOptions
{
    if (self = [super init])
    {
        self.tagManager = [TAGManager instance];
        
        // Optional: Change the LogLevel to Verbose to enable logging at VERBOSE and higher levels.
        [self.tagManager.logger setLogLevel:kTAGLoggerLogLevelVerbose];
        
        [TAGContainerOpener openContainerWithId:@"GTM-W8ZTJS"   // Update with your Container ID.
                                     tagManager:self.tagManager
                                       openType:kTAGOpenTypePreferFresh
                                        timeout:nil
                                       notifier:self];
        
//        [Parse setApplicationId:@"1OwEBp7a2H7MInky6Tps3kMhh8iqXdYzv1QtTfng"
//                      clientKey:@"vOqnH9hAB7TUFQ6hp4IHAth2ZwVEr0PE1Xp1X5Cs"];
        
        [OneSignal initWithLaunchOptions:launchOptions appId:@"5bbd1f0b-6617-4c44-a204-b6035bb85c89" handleNotificationAction:^(OSNotificationOpenedResult *result) {
            
//            // This block gets called when the user reacts to a notification received
//            OSNotificationPayload* payload = result.notification.payload;
//            
//            
//            NSString* messageTitle = @"OneSignal Example";
//            NSString* fullMessage = [payload.body copy];
//            
//            if (payload.additionalData) {
//                
//                if(payload.title)
//                    messageTitle = payload.title;
//                
//                NSDictionary* additionalData = payload.additionalData;
//                
//                if (additionalData[@"actionSelected"])
//                    fullMessage = [fullMessage stringByAppendingString:[NSString stringWithFormat:@"\nPressed ButtonId:%@", additionalData[@"actionSelected"]]];
//            }
//            
//            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:messageTitle
//                                                                message:fullMessage
//                                                               delegate:self
//                                                      cancelButtonTitle:@"Close"
//                                                      otherButtonTitles:nil, nil];
//            [alertView show];
            
        }];
        
        [OneSignal IdsAvailable:^(NSString *userId, NSString *pushToken) {
            if(pushToken) {
                NSLog(@"Received push token - %@", pushToken);
                NSLog(@"User ID - %@", userId);
            }
        }];
        
        [[FBSDKApplicationDelegate sharedInstance] application:[UIApplication sharedApplication]
                                 didFinishLaunchingWithOptions:launchOptions];
    }
    
    return self;
}

// TAGContainerOpenerNotifier callback.
- (void)containerAvailable:(TAGContainer *)container
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.container = container;
    });
}

- (BOOL)FBOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [[FBSDKApplicationDelegate sharedInstance] application:[UIApplication sharedApplication]
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)FBActivateApp
{
    [FBSDKAppEvents activateApp];
}

- (void)FBLogEvent:(NSString *)event sum:(double)sum
{
    [FBSDKAppEvents logEvent:event valueToSum:sum];
}

//------

//- (void)ParseRegisterPush:(NSData*)token
//{
//    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
//    [currentInstallation setDeviceTokenFromData:token];
//    currentInstallation.channels = @[ @"global" ];
//    [currentInstallation saveInBackground];
//}
//
//- (void)ParseHandlePush:(NSDictionary *)userInfo
//{
//    [PFPush handlePush:userInfo];
//}

//-------

- (void)openScreen:(NSString *)screenName
{
    TAGDataLayer *dataLayer = [TAGManager instance].dataLayer;
    [dataLayer push:@{@"event": @"openScreen",      // Event, name of Open Screen Event.
                      @"screenName": screenName}];  // Name of the screen name field, screen name value.
}

- (void)cartOperation:(BOOL)addOperation
             category:(NSString *)category
             itemName:(NSString *)name
               itemId:(NSString *)itemId
                price:(CGFloat)price
             quantity:(CGFloat)quantity
{
    TAGDataLayer *dataLayer = [TAGManager instance].dataLayer;
    
    [dataLayer push:@{@"event": addOperation?@"addToCart":@"removeFromCart",
                      @"ecommerce": @{
                          @"currencyCode": @"RUB",
                          addOperation?@"add":@"remove": @{
                              @"products": @[
                                  @{@"name": name,
                                    @"id": itemId,
                                    @"price": @(price).stringValue,
                                    @"brand": @"Plov.com",
                                    @"category": category,
                                    @"quantity": @(quantity)}]}}}];
}

- (void)cartPurchased:(OrderObject *)order
{
    TAGDataLayer *dataLayer = [TAGManager instance].dataLayer;
    
    NSMutableArray * products = [NSMutableArray array];
    
    for (OrderItemObject * item in order.list)
    {
        NSString * categoryName = [[SHARED_APP.menuData categoryById:item.categoryId] titleForLng:@"ru"];
        NSString * itemName = [[SHARED_APP.menuData itemById:item.itemId] titleForLng:@"ru"];
        
        [products addObject:@{@"name": itemName,   // Name or ID is required.
                              @"id": item.itemId,
                              @"price": @(item.cost).stringValue,
                              @"brand": @"Plov.com",
                              @"category": categoryName,
                              @"quantity": @(item.count),
                              }];
    }
    
    NSDictionary * pushData = @{@"event": @"purchase",
                                @"ecommerce": @{
                                    @"purchase": @{
                                        @"actionField": @{
                                            @"id": order.orderId,
                                            @"affiliation": @"Plov.com iOS App",
                                            @"shipping": @(order.deliveryCost).stringValue,
                                            @"revenue": @(order.cost).stringValue},
                                        @"products": products}}};
    
    [dataLayer push:@{@"ecommerce":[NSNull null]}];
    
    [dataLayer push:pushData];
    
    [dataLayer push:@{@"event": @"thankyou_purchase_message"}];
}

- (void)orderStep:(OrderObject *)order step:(NSInteger)step
{
    TAGDataLayer *dataLayer = [TAGManager instance].dataLayer;
    
    NSMutableArray * products = [NSMutableArray array];
    
    for (OrderItemObject * item in order.list)
    {
        NSString * categoryName = [[SHARED_APP.menuData categoryById:item.categoryId] titleForLng:@"ru"];
        NSString * itemName = [[SHARED_APP.menuData itemById:item.itemId] titleForLng:@"ru"];
        
        [products addObject:@{@"name": itemName,   // Name or ID is required.
                              @"id": item.itemId,
                              @"price": @(item.cost).stringValue,
                              @"brand": @"Plov.com",
                              @"category": categoryName,
                              @"quantity": @(item.count),
                              }];
    }
    
    [dataLayer push:@{@"event": @"checkout",
                      @"ecommerce": @{
                          @"checkout": @{
                              @"actionField": @{
                                  @"step": @(step)},
                              @"products": products}}}];
}

- (void)itemOnScreen:(MenuItemObject *)item
{
    TAGDataLayer *dataLayer = [TAGManager instance].dataLayer;
    
    NSString * categoryName = [[SHARED_APP.menuData categoryById:item.categoryId] titleForLng:@"ru"];
    NSString * itemName = [[SHARED_APP.menuData itemById:item.itemId] titleForLng:@"ru"];
    
    [dataLayer push:@{@"ecommerce": @{
                              @"impressions": @[
                                      @{@"name": itemName,     // Name or ID is required.
                                        @"id": item.itemId,
                                        @"price": @(item.cost).stringValue,
                                        @"brand": @"Plov.com",
                                        @"category": categoryName,
                                        },
                                      ]}}];
}

- (void)itemOnFullScreen:(MenuItemObject *)item
{
    TAGDataLayer *dataLayer = [TAGManager instance].dataLayer;
    
    NSString * categoryName = [[SHARED_APP.menuData categoryById:item.categoryId] titleForLng:@"ru"];
    NSString * itemName = [[SHARED_APP.menuData itemById:item.itemId] titleForLng:@"ru"];
    
    [dataLayer push:@{@"event": @"productClick",
                      @"ecommerce": @{
                          @"click": @{
//                              @"actionField": @{},
                              @"products": @[
                                  @{@"name": itemName,   // Name or ID is required.
                                    @"id": item.itemId,
                                    @"price": @(item.cost).stringValue,
                                    @"brand": @"Plov.com",
                                    @"category": categoryName
                                    }]}}}];
}

- (void)itemOnInfo:(MenuItemObject *)item
{
    TAGDataLayer *dataLayer = [TAGManager instance].dataLayer;
    
    NSString * categoryName = [[SHARED_APP.menuData categoryById:item.categoryId] titleForLng:@"ru"];
    NSString * itemName = [[SHARED_APP.menuData itemById:item.itemId] titleForLng:@"ru"];
    
    [dataLayer push:@{@"ecommerce": @{
                          @"detail": @{
                              @"products": @[
                                  @{@"name": itemName,   // Name or ID is required.
                                    @"id": item.itemId,
                                    @"price": @(item.cost).stringValue,
                                    @"brand": @"Plov.com",
                                    @"category": categoryName
                                    }]}}}];
}

@end
