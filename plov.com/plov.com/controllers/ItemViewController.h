//
//  ItemViewController.h
//  plov.com
//
//  Created by v.kubyshev on 17/08/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuItemObject;

@interface ItemViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UIView *itemDescriptionPanel;
@property (weak, nonatomic) IBOutlet UILabel *itemTitle;
@property (weak, nonatomic) IBOutlet UILabel *itemDescription;

+ (instancetype)instantiateWithMenuItem:(MenuItemObject *)item;

- (void)hidePanel;

@end
