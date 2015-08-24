//
//  MainViewController.m
//  plov.com
//
//  Created by v.kubyshev on 05/08/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import "MainViewController.h"

#import "BBCyclingLabel.h"
#import "SWRevealViewController.h"

#import "PLMenuView.h"

#import "MenuObject.h"
#import "MenuCategoryObject.h"
#import "MenuItemObject.h"

#import "ItemViewController.h"
#import "OrderViewController.h"

#define ITEM_VIEW_PREFIX 123012

@interface MainViewController () <UIScrollViewDelegate, PLMenuViewDelegate>
@property (nonatomic, strong) MenuObject * plovMenu;

@property (nonatomic, assign) BOOL panelHidden;
@property (nonatomic, strong) UIGestureRecognizer * showPanelGesture;

@property (nonatomic, assign) NSInteger currentItem;

@property (nonatomic, strong) NSMutableArray * items;

@property (nonatomic, assign) NSInteger bucketSum;
@property (nonatomic, assign) BOOL arrowAnimation;

@property (nonatomic, strong) UIBarButtonItem * orderButton;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.arrowAnimation = NO;
    
    self.panelHidden = YES;
    
    [self.countMinusButton addTarget:self action:@selector(countChanged:) forControlEvents:UIControlEventTouchUpInside];
    [self.countPlusButton addTarget:self action:@selector(countChanged:) forControlEvents:UIControlEventTouchUpInside];
    self.countLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:28];
    self.countLabel.textColor = UIColorFromRGBA(resColorMenuText);
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    [self.countLabel setText:@"0" animated:NO];
    self.countLabel.clipsToBounds = YES;
    
    self.cartIcon.x = self.view.width - self.cartIcon.width - 16;
    self.bucketSumLabel.alpha = 0;
    self.bucketSumLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:18];
    self.bucketSumLabel.textColor = UIColorFromRGBA(resColorMenuText);
    self.bucketSumLabel.textAlignment = NSTextAlignmentRight;
    self.bucketSumLabel.clipsToBounds = YES;
    
    [self setupWithMenu:SHARED_APP.menuData];
    
    self.itemsScrollView.delegate = self;
    
    UIButton * btn = [[UIButton alloc] initWithFrame:self.bucketSumLabel.bounds];
    [btn addTarget:self action:@selector(processToOrder) forControlEvents:UIControlEventTouchUpInside];
    self.orderButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    self.itemsScrollView.contentOffset = CGPointMake(0, 0);
//}

- (void)processToOrder
{
    OrderViewController * orderVc = [self.storyboard instantiateViewControllerWithIdentifier:@"orderViewController"];
    
    NSMutableArray * order = [[NSMutableArray alloc] initWithCapacity:self.items.count];
    
    for (NSDictionary * item in self.items)
    {
        MenuItemObject * menuItem = item[@"item"];
        
        if (menuItem.count > 0)
        {
            [order addObject:menuItem];
        }
    }
    
    orderVc.order = order;
    
    [self.navigationController pushViewController:orderVc animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.arrowAnimation)
    {
        return;
    }
    
    self.arrowAnimation = YES;
    
    self.leftArrow.alpha = 0;
    self.rightArrow.alpha = 0;
    
    int steps = 7;
    int step = 1;
    
    __block CGFloat duration = 1.5;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self arrowAnimateWithStep:step forSteps:steps withDuration:duration];
    });
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.arrowAnimation = NO;
}

- (void)arrowAnimateWithStep:(int)step forSteps:(int)steps withDuration:(CGFloat)duration
{
    int dx = 2;
    [UIView animateWithDuration:(duration/steps) animations:^{
        self.leftArrow.alpha = 1 - (CGFloat)step/(CGFloat)steps;
        self.rightArrow.alpha = 1 - (CGFloat)step/(CGFloat)steps;
        
        CGFloat delta = (step == 1 || step == steps)?dx:dx*2;
        delta = delta * ((step%2 == 0)?-1:1);
        
        self.leftArrow.transform = CGAffineTransformMakeTranslation(delta, 0);
        self.rightArrow.transform = CGAffineTransformMakeTranslation(delta, 0);;
    } completion:^(BOOL finished) {
        if (step >= steps)
        {
            self.arrowAnimation = NO;
            return;
        }
        int newStep = step + 1;
        [self arrowAnimateWithStep:newStep forSteps:steps withDuration:duration];
    }];
}

- (void)setupWithMenu:(MenuObject *)menu
{
    self.items = [NSMutableArray arrayWithCapacity:20];
    
    self.plovMenu = menu;
    [self.menuView setupMenu:menu];
    self.menuView.plDelegate = self;
    
    for (MenuCategoryObject * category in menu.categories)
    {
        for (MenuItemObject * item in category.items)
        {
            [self.items addObject:@{@"item": item,
                                    @"controller": [ItemViewController instantiateWithMenuItem:item]}];
        }
    }
    
    self.itemsScrollView.contentSize = CGSizeMake(self.items.count * self.itemsScrollView.width, self.itemsScrollView.height);
    
    _currentItem = -1;
    self.currentItem = 0;
}

- (void)checkCartPosAnimated:(BOOL)animated
{
    UILabel * testLabel = [[UILabel alloc] initWithFrame:self.bucketSumLabel.frame];
    testLabel.attributedText = [SHARED_APP rubleCost:self.bucketSum font:self.bucketSumLabel.font];
    [testLabel sizeToFit];
    NSInteger newX = self.view.width - self.cartIcon.width - 13 - ceil(testLabel.width/10)*10 - 3;
    
//    while (newX % 18 != 0)
//    {
//        newX--;
//        if (newX <  self.view.width - self.cartIcon.width - 13 - testLabel.width - 20)
//        {
//            break;
//        }
//    }
    
    if (newX != self.cartIcon.x)
    {
        if (animated)
        {
            [UIView animateWithDuration:0.2 animations:^{
                self.cartIcon.x = newX;
            }];
        }
        else
        {
            self.cartIcon.x = newX;
        }
    }
}

- (void)countChanged:(id)sender
{
    if (_currentItem >= 0 && _currentItem < self.items.count)
    {
        MenuItemObject * item = self.items[_currentItem][@"item"];
        if (sender == self.countMinusButton)
        {
            self.countLabel.transitionEffect = BBCyclingLabelTransitionEffectScrollDown;
            item.count--;
        
            if (item.count < 0)
            {
                item.count = 0;
                return;
            }
        
            self.bucketSum -= item.cost;
        
            if (self.bucketSum == 0)
            {
                self.navigationItem.rightBarButtonItem = nil;
                
                [UIView animateWithDuration:0.2 animations:^{
                    self.bucketSumLabel.alpha = 0;
                    self.cartIcon.x = self.view.width - self.cartIcon.width - 13;
                } completion:^(BOOL finished) {
                    [self.bucketSumLabel setText:@"" animated:NO];
                }];
            }
            else
            {
                [self checkCartPosAnimated:YES];
                
                self.bucketSumLabel.transitionEffect = BBCyclingLabelTransitionEffectScrollDown;
                [self.bucketSumLabel setAttributedText:[SHARED_APP rubleCost:self.bucketSum font:self.bucketSumLabel.font] animated:YES];
            }
        }
        else
        {
            self.countLabel.transitionEffect = BBCyclingLabelTransitionEffectScrollUp;
            item.count++;
            
            if (item.count > 99)
            {
                item.count = 99;
                return;
            }
            
            BOOL showSumm = self.bucketSum == 0;
            self.bucketSum += item.cost;
            
            if (showSumm)
            {
                self.navigationItem.rightBarButtonItem = self.orderButton;
                
                [self.bucketSumLabel setAttributedText:[SHARED_APP rubleCost:self.bucketSum font:self.bucketSumLabel.font] animated:NO];
                [UIView animateWithDuration:0.2 animations:^{
                    self.bucketSumLabel.alpha = 1;
                    
                    [self checkCartPosAnimated:NO];
                }];
            }
            else
            {
                [self checkCartPosAnimated:YES];
                
                self.bucketSumLabel.transitionEffect = BBCyclingLabelTransitionEffectScrollUp;
                [self.bucketSumLabel setAttributedText:[SHARED_APP rubleCost:self.bucketSum font:self.bucketSumLabel.font] animated:YES];
            }
        }
    
        [self.countLabel setText:@(item.count).stringValue animated:YES];
    }
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.itemsScrollView.width;
    float fractionalPage = self.itemsScrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
 
    self.currentItem = page;
    
    if (_currentItem >= 0 && _currentItem < self.items.count)
    {
        MenuItemObject * item = self.items[_currentItem][@"item"];
        if (![item.categoryId isEqualToString:self.menuView.currentCategory.categoryId])
        {
            [self.menuView selectCategory:item.categoryId];
        }
    }

}

- (void)setCurrentItem:(NSInteger)currentItem
{
    if (_currentItem != currentItem)
    {
        if (_currentItem >=0 && _currentItem < self.items.count)
        {
            ItemViewController * itemVc = self.items[_currentItem][@"controller"];
        
            [itemVc hideDescriptionPanel];
        }
        
        _currentItem = currentItem;
        
        [self fillItemInfo];
    }
}

- (void)insertViewForPos:(int)pos
{
    if (pos >= 0 && pos < self.items.count)
    {
//        MenuItemObject * item = self.items[pos][@"item"];
        ItemViewController * vc = self.items[pos][@"controller"];
        
        vc.view.x = pos * vc.view.width;
        
        [self.itemsScrollView addSubview:vc.view];
    }
}

- (void)fillItemInfo
{
    for (int i = 0; i < self.itemsScrollView.subviews.count; i++)
    {
        UIView * view = self.itemsScrollView.subviews[i];
        
        if (view.tag < _currentItem + (ITEM_VIEW_PREFIX - 1) || view.tag > _currentItem + (ITEM_VIEW_PREFIX + 1))
        {
            [view removeFromSuperview];
        }
    }
    
    if (![self.itemsScrollView viewWithTag:_currentItem + ITEM_VIEW_PREFIX])
    {
        [self insertViewForPos:_currentItem];
    }
    
    if (![self.itemsScrollView viewWithTag:(_currentItem + ITEM_VIEW_PREFIX - 1)])
    {
        [self insertViewForPos:(_currentItem - 1)];
    }
    
    if (![self.itemsScrollView viewWithTag:(_currentItem + ITEM_VIEW_PREFIX + 1)])
    {
        [self insertViewForPos:(_currentItem + 1)];
    }
    
    if (_currentItem >= 0 && _currentItem < self.items.count)
    {
        MenuItemObject * item = self.items[_currentItem][@"item"];
    
        self.weightLabel.text = [NSString stringWithFormat:LOC(@"LOC_MAIN_WEIGHT"), @(item.weight)];
        self.priceLabel.attributedText = [SHARED_APP rubleCost:item.cost font:self.priceLabel.font];
        [self.countLabel setText:@(item.count).stringValue animated:NO];
    }
}

- (void)selectingCategory:(MenuCategoryObject *)category
{
    for (NSInteger idx = 0; idx < self.items.count; idx++)
    {
        if (self.items[idx][@"item"] == category.items.firstObject)
        {
            self.currentItem = idx;
            
            CGRect rect = [self.items[_currentItem][@"controller"] view].frame;
            [self.itemsScrollView scrollRectToVisible:rect animated:YES];
            
            return;
        }
    }
}

@end
