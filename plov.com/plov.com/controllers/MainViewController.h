//
//  MainViewController.h
//  plov.com
//
//  Created by v.kubyshev on 05/08/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuObject;
@class PLMenuView;

@interface MainViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *leftArrow;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;

@property (weak, nonatomic) IBOutlet PLMenuView *menuView;
@property (weak, nonatomic) IBOutlet UIScrollView *itemsScrollView;


- (void)setupWithMenu:(MenuObject *)menu;

@end
