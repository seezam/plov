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
@class SWRevealViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) PLCRMSupport * crm;
@property (strong, nonatomic) MenuObject * menuData;
@property (strong, nonatomic) CustomerObject * customer;
@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate *)app;
- (SWRevealViewController *)revealViewController;

- (void)startApplication:(UIView *)fromView;
- (void)informNetworkIssue;

- (NSAttributedString *)rubleCost:(NSInteger)cost font:(UIFont *)font;

- (void)updateMenu;

@end

