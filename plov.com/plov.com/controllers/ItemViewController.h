//
//  ItemViewController.h
//  plov.com
//
//  Created by v.kubyshev on 17/08/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuItemObject;
@class ItemViewController;

@protocol ItemViewDelegate <NSObject>

- (void)itemView:(ItemViewController *)item enableFullscreen:(BOOL)enable;
- (void)itemView:(ItemViewController *)item showInfo:(BOOL)enable;
- (BOOL)fullscreenMode;

@end

@interface ItemViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UIView *itemDescriptionPanel;
@property (weak, nonatomic) IBOutlet UILabel *itemTitle;
@property (weak, nonatomic) IBOutlet UILabel *itemDescription;

@property (weak, nonatomic) id<ItemViewDelegate> delegate;

+ (instancetype)instantiateWithMenuItem:(MenuItemObject *)item;

- (void)hidePanel;

- (void)setProgress1:(float)progress;
- (void)setProgress2:(float)progress;

@end
