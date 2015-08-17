//
//  ItemViewController.m
//  plov.com
//
//  Created by v.kubyshev on 17/08/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import "ItemViewController.h"
#import "MenuItemObject.h"
#import "SWRevealViewController.h"

@interface ItemViewController()<UIGestureRecognizerDelegate>
@property (nonatomic, assign) BOOL panelHidden;

@property (nonatomic, strong) UIPanGestureRecognizer * panGesture;
@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;
@end

@implementation ItemViewController

+ (instancetype)instantiateWithMenuItem:(MenuItemObject *)item
{
    ItemViewController * itemVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ItemViewController"];
    [itemVc loadView];
    
    itemVc.itemImage.image = item.image;
    
    itemVc.itemTitle.text = [item.title uppercaseString];
    itemVc.itemDescription.text = item.desc;
    CGFloat w = itemVc.itemDescription.width;
    [itemVc.itemDescription sizeToFit];
    itemVc.itemDescription.width = w;
    
    itemVc.itemTitle.font = [UIFont fontWithName:@"ProximaNova-Bold" size:18];
    itemVc.itemDescription.font = [UIFont fontWithName:@"ProximaNova-Light" size:16];
    
    
    itemVc.panelHidden = YES;
    
    itemVc.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:itemVc action:@selector(showDescriptionPanel:)];
    itemVc.panGesture.delegate = itemVc;
    [itemVc.view addGestureRecognizer:itemVc.panGesture];
    
    itemVc.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:itemVc action:@selector(hideDescriptionPanel:)];
    itemVc.tapGesture.delegate = itemVc;
    [itemVc.view addGestureRecognizer:itemVc.tapGesture];
    
    return itemVc;
}

- (void)hideDescriptionPanel
{
    [self hideDescriptionPanel:nil];
}

- (void)hideDescriptionPanel:(UITapGestureRecognizer *)gestureRecognizer
{
    if (SHARED_APP.revealViewController.frontViewPosition == FrontViewPositionRight)
    {
        [SHARED_APP.revealViewController revealToggle:nil];
        return;
    }
    
    self.panelHidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.itemDescriptionPanel.frame = CGRectMake(0, self.view.height - 151, self.view.width, 151);
    }];
}

- (void)showDescriptionPanel:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (SHARED_APP.revealViewController.frontViewPosition == FrontViewPositionRight)
    {
        [SHARED_APP.revealViewController revealToggle:nil];
        return;
    }
    
    CGPoint velocity = [gestureRecognizer velocityInView:self.view];
    
    if (fabs(velocity.y) > fabs(velocity.x))
    {
        if (velocity.y < -100)
        {
            self.panelHidden = NO;
            [UIView animateWithDuration:0.2 animations:^{
                CGFloat height = CGRectGetMaxY(self.itemDescription.frame) + 80;
                self.itemDescriptionPanel.frame = CGRectMake(0, self.view.height - height, self.view.width, height);
            }];
        }
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.tapGesture)
    {
        return !self.panelHidden || self.revealViewController.frontViewPosition == FrontViewPositionRight;
    }
    else if (gestureRecognizer == self.panGesture)
    {
        return self.panelHidden || self.revealViewController.frontViewPosition == FrontViewPositionRight;
    }
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (self.revealViewController.frontViewPosition == FrontViewPositionRight)
    {
        return NO;
    }
    //    NSLog(@"%@\n%@", gestureRecognizer, otherGestureRecognizer);
    return YES;
}

@end
