//
//  AppDelegate.m
//  plov.com
//
//  Created by Vladimir Kubyshev on 02.08.15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import "AppDelegate.h"

#import "AFNetworkReachabilityManager.h"

#import "MenuObject.h"
#import "MenuCategoryObject.h"
#import "MenuItemObject.h"

#import "MainViewController.h"
#import "SWRevealViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


+ (AppDelegate *)app
{
    return [[UIApplication sharedApplication] delegate];
}

- (MenuObject *)loadData
{
//    NSString * data = @"\
//    {\"status\" : {\"code\" : 20000}, \
//    \"categories\" : [ \
//    { \
//        \"title\": \"Plov\", \
//        \"id\" : 0, \
//        \"items\" : [] \
//    }, \
//    { \
//        \"title\": \"Salad\", \
//        \"id\" : 1, \
//        \"items\" : [] \
//    }, \
//    { \
//        \"title\": \"Samsa\", \
//        \"id\" : 2, \
//        \"items\" : [] \
//    }, \
//    { \
//        \"title\": \"Bread\", \
//        \"id\" : 3, \
//        \"items\" : [] \
//    }, \
//    { \
//        \"title\": \"Sweats\", \
//        \"id\" : 4, \
//        \"items\" : [] \
//    }, \
//    { \
//        \"title\": \"Other\", \
//        \"id\" : 5, \
//        \"items\" : [] \
//    } \
//                    ]}\
//    ";
//    
//    MenuObject * obj = [[MenuObject alloc] initWithData:[NSData dataWithBytes:data.UTF8String length:data.length]];
    
    MenuObject * obj = [[MenuObject alloc] init];
    
    MenuCategoryObject * cat1 = [[MenuCategoryObject alloc] initWithId:@"0"];
    [cat1 setTitle:@"Plov" forLng:@""];
    [obj addMenuCategory:cat1];
    
    MenuItemObject * item11 = [[MenuItemObject alloc] initWithId:@"0"];
    [item11 setTitle:@"Plov 1" forLng:@""];
    [item11 setDesc:@"plov 1\nplov1\nplov1" forLng:@""];
    [item11 setCost:200 forWeight:120];
    [cat1 addMenuItem:item11];
    
    MenuItemObject * item12 = [[MenuItemObject alloc] initWithId:@"1"];
    [item12 setTitle:@"Plov 2" forLng:@""];
    [item12 setDesc:@"plov 2\nplov2\nplov2\nplov2" forLng:@""];
    [item12 setCost:300 forWeight:220];
    [cat1 addMenuItem:item12];
    
    MenuItemObject * item13 = [[MenuItemObject alloc] initWithId:@"2"];
    [item13 setTitle:@"Plov 3" forLng:@""];
    [item13 setDesc:@"plov 3\nplov3\nplov3\nplov 3\nplov 3\nplov 3" forLng:@""];
    [item13 setCost:180 forWeight:100];
    [cat1 addMenuItem:item13];
    
    MenuCategoryObject * cat2 = [[MenuCategoryObject alloc] initWithId:@"1"];
    [cat2 setTitle:@"Salad" forLng:@""];
    [obj addMenuCategory:cat2];
    
    MenuItemObject * item21 = [[MenuItemObject alloc] initWithId:@"0"];
    [item21 setTitle:@"Salad 1" forLng:@""];
    [cat2 addMenuItem:item21];
    
    MenuItemObject * item22 = [[MenuItemObject alloc] initWithId:@"1"];
    [item22 setTitle:@"Salad 2" forLng:@""];
    [cat2 addMenuItem:item22];
    
    MenuCategoryObject * cat3 = [[MenuCategoryObject alloc] initWithId:@"2"];
    [cat3 setTitle:@"Samsa" forLng:@""];
    [obj addMenuCategory:cat3];
    
    MenuItemObject * item31 = [[MenuItemObject alloc] initWithId:@"0"];
    [item31 setTitle:@"Samsa" forLng:@""];
    [cat3 addMenuItem:item31];
    
    MenuCategoryObject * cat4 = [[MenuCategoryObject alloc] initWithId:@"3"];
    [cat4 setTitle:@"Bread" forLng:@""];
    [obj addMenuCategory:cat4];
    
    MenuItemObject * item41 = [[MenuItemObject alloc] initWithId:@"0"];
    [item41 setTitle:@"Bread" forLng:@""];
    [cat4 addMenuItem:item41];
    
    MenuCategoryObject * cat5 = [[MenuCategoryObject alloc] initWithId:@"4"];
    [cat5 setTitle:@"Sweats" forLng:@""];
    [obj addMenuCategory:cat5];
    
    MenuItemObject * item51 = [[MenuItemObject alloc] initWithId:@"0"];
    [item51 setTitle:@"KitKat" forLng:@""];
    [cat5 addMenuItem:item51];
    
    MenuCategoryObject * cat6 = [[MenuCategoryObject alloc] initWithId:@"5"];
    [cat6 setTitle:@"Other" forLng:@""];
    [obj addMenuCategory:cat6];
    
    MenuItemObject * item61 = [[MenuItemObject alloc] initWithId:@"0"];
    [item61 setTitle:@"Towels" forLng:@""];
    [cat6 addMenuItem:item61];
    
    return obj;
}

- (void)startApplication:(UIView *)fromView
{
    self.menuData = [self loadData];
    
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SWRevealViewController *viewControllerToBeShown = [storyBoard instantiateViewControllerWithIdentifier:@"beginViewController"];
    [SHARED_APP.window addSubview:viewControllerToBeShown.view];
    viewControllerToBeShown.view.alpha = 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        fromView.alpha = 0;
        viewControllerToBeShown.view.alpha = 1;
    } completion:^(BOOL finished) {
        self.window.rootViewController = viewControllerToBeShown;
    }];
}

- (void)informNetworkIssue
{
    
}

#pragma mark - delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

@end
