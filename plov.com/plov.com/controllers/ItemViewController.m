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

@property (nonatomic, assign) CGPoint panPointBegin;
@property (nonatomic, assign) CGFloat startPanelHeight;
@property (nonatomic, assign) BOOL performing;

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
    
    itemVc.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:itemVc action:@selector(panGestureHandler:)];
    itemVc.panGesture.delegate = itemVc;
    [itemVc.view addGestureRecognizer:itemVc.panGesture];
    
    itemVc.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:itemVc action:@selector(hideDescriptionPanel:)];
    itemVc.tapGesture.delegate = itemVc;
    [itemVc.view addGestureRecognizer:itemVc.tapGesture];
    
    return itemVc;
}

- (void)hideDescriptionPanel:(UITapGestureRecognizer *)gestureRecognizer
{
    if (SHARED_APP.revealViewController.frontViewPosition == FrontViewPositionRight)
    {
        [SHARED_APP.revealViewController revealToggle:nil];
        return;
    }
    
    [self hidePanel];
}

- (void)showPanel
{
    self.panelHidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        CGFloat height = CGRectGetMaxY(self.itemDescription.frame) + 80;
        self.itemDescriptionPanel.frame = CGRectMake(0, self.view.height - height, self.view.width, height);
    }];
}

- (void)hidePanel
{
    self.panelHidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.itemDescriptionPanel.frame = CGRectMake(0, self.view.height - 151, self.view.width, 151);
    }];
}

- (void)resetImageSize
{
    CGPoint center = self.itemImage.center;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.itemImage.width = self.itemImage.image.size.width;
        self.itemImage.height = self.itemImage.image.size.height;
        self.itemImage.center = center;
    }];
}

- (void)setProgress1:(float)progress
{
    CGPoint center = self.itemImage.center;
    CGFloat width = self.view.width;
    CGFloat halfW = width/2;
    
    center.x = halfW + width*(1 - progress);
    self.itemImage.center = center;
}

- (void)setProgress2:(float)progress
{
    CGPoint center = self.itemImage.center;
    CGFloat width = self.view.width;
    CGFloat halfW = width/2;
    
    center.x = halfW - width*(1 - progress);
    self.itemImage.center = center;
}

- (void)setPerforming:(BOOL)performing
{
    UIScrollView * scroll = (UIScrollView *)self.view.superview;
    
    scroll.scrollEnabled = !performing;
}

- (void)panGestureHandler:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (SHARED_APP.revealViewController.frontViewPosition == FrontViewPositionRight)
    {
        [SHARED_APP.revealViewController revealToggle:nil];
        return;
    }
    
    CGPoint velocity = [gestureRecognizer velocityInView:self.view];
    
    if (fabs(velocity.y) > fabs(velocity.x))
    {
        switch (gestureRecognizer.state) {
            case UIGestureRecognizerStateBegan:
                self.performing = YES;
                self.panPointBegin = [gestureRecognizer locationInView:self.view];
                self.startPanelHeight = self.itemDescriptionPanel.height;
                break;
            case UIGestureRecognizerStateChanged:
            {
                CGPoint currentPoint = [gestureRecognizer locationInView:self.view];
                if (self.panPointBegin.y - currentPoint.y < 0)
                {
                    CGFloat newScale = 1 + (currentPoint.y - self.panPointBegin.y)/(self.view.height/2);
                    if (newScale > 1.5)
                    {
                        newScale = 1.5;
                    }
                    
                    CGPoint center = self.itemImage.center;
                    
                    self.itemImage.width = self.itemImage.image.size.width * newScale;
                    self.itemImage.height = self.itemImage.image.size.height * newScale;
                    self.itemImage.center = center;
                    
                    if (!self.panelHidden)
                    {
                        [self hidePanel];
                    }
                }
                else
                {
                    CGFloat delta = (self.panPointBegin.y - currentPoint.y);
                    CGFloat height = self.startPanelHeight + delta;
                    if (height > self.view.height/2)
                    {
                        height = ceil(self.view.height/2);
                    }
                    self.itemDescriptionPanel.frame = CGRectMake(0, self.view.height - height, self.view.width, height);
                }
                
            }
                break;
            case UIGestureRecognizerStateEnded:
            {
                self.performing = NO;
                [self resetImageSize];
                
                CGPoint endPoint = [gestureRecognizer locationInView:self.view];
                
                if (self.panPointBegin.y - endPoint.y > 20)
                {
                    [self showPanel];
                }
                else if (self.panPointBegin.y - endPoint.y < 0 && !self.panelHidden)
                {
                    [self hidePanel];
                }
                else if (self.panelHidden)
                {
                    [self hidePanel];
                }
            }
                break;
            case UIGestureRecognizerStateCancelled:
            case UIGestureRecognizerStateFailed:
                self.performing = NO;
                [self resetImageSize];
                [self hidePanel];
                break;

            default:
                break;
        }
    }
    else
    {
        self.performing = NO;
        [self resetImageSize];
        [self hidePanel];
        self.panPointBegin = [gestureRecognizer locationInView:self.view];
        self.startPanelHeight = self.itemDescriptionPanel.height;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.tapGesture)
    {
        return !self.panelHidden || SHARED_APP.revealViewController.frontViewPosition == FrontViewPositionRight;
    }
    else if (gestureRecognizer == self.panGesture)
    {
        return YES;
    }
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (SHARED_APP.revealViewController.frontViewPosition == FrontViewPositionRight)
    {
        return NO;
    }
    //    NSLog(@"%@\n%@", gestureRecognizer, otherGestureRecognizer);
    return YES;
}

@end
