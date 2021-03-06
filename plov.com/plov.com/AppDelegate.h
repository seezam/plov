//
//  AppDelegate.h
//  plov.com
//
//  Created by Vladimir Kubyshev on 02.08.15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PLCRMSupport;
@class MenuObject;
@class CustomerObject;
@class OrderObject;
@class SWRevealViewController;
@class PLTracking;

extern NSString * kRemoteInfoBuildNumber;
extern NSString * kRemoteInfoMinimalCost;
extern NSString * kRemoteInfoFreeDeliveryCost;
extern NSString * kRemoteInfoDeliveryCost;
extern NSString * kRemoteInfoUpdateURL;
extern NSString * kRemoteInfoCallcenterNumber;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) PLTracking * tracking;
@property (strong, nonatomic) PLCRMSupport * crm;
@property (strong, nonatomic) MenuObject * menuData;
@property (strong, nonatomic) CustomerObject * customer;
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSDictionary * remoteAppInfo;

@property (assign, nonatomic) BOOL reinitialized;

+ (AppDelegate *)app;
- (SWRevealViewController *)revealViewController;

- (BOOL)updateRemoteInfo;
- (BOOL)checkForAppVersion;
- (void)updateApplication;

- (void)startApplication:(UIView *)fromView;
- (void)informNetworkIssue;

- (NSAttributedString *)rubleCost:(NSInteger)cost font:(UIFont *)font;

- (void)resetMenuToOrder:(OrderObject *)order;

@end

