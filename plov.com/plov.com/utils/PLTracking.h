//
//  PLTracking.h
//  plov.com
//
//  Created by Vladimir Kubyshev on 26/11/15.
//  Copyright © 2015 plov.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OrderObject;

@interface PLTracking : NSObject

- (instancetype)initAtStart:(NSDictionary *)launchOptions;

- (BOOL)FBOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
- (void)FBActivateApp;
- (void)FBLogEvent:(NSString *)event sum:(double)sum;

- (void)ParseRegisterPush:(NSData*)token;
- (void)ParseHandlePush:(NSDictionary *)userInfo;

- (void)openScreen:(NSString *)screenName;
- (void)cartPurchased:(OrderObject *)order;
- (void)orderStep:(OrderObject *)order step:(NSInteger)step;
- (void)cartOperation:(BOOL)addOperation
             category:(NSString *)category
             itemName:(NSString *)name
               itemId:(NSString *)itemId
                price:(CGFloat)price
             quantity:(CGFloat)quantity;

@end
