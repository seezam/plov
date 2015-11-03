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
@class BBCyclingLabel;

@interface MainViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *leftArrow;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;

@property (weak, nonatomic) IBOutlet UIView *menuBackground;
@property (weak, nonatomic) IBOutlet PLMenuView *menuView;
@property (weak, nonatomic) IBOutlet UIScrollView *itemsScrollView;

@property (weak, nonatomic) IBOutlet UIButton *countMinusButton;
@property (weak, nonatomic) IBOutlet UIButton *countPlusButton;
@property (weak, nonatomic) IBOutlet BBCyclingLabel *countLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cartIcon;
@property (weak, nonatomic) IBOutlet BBCyclingLabel *bucketSumLabel;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *footerView;

@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

- (void)setupWithMenu:(MenuObject *)menu;

@end
