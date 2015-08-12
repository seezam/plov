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

@interface MainViewController () <UIScrollViewDelegate, UIGestureRecognizerDelegate, PLMenuViewDelegate>
@property (nonatomic, strong) MenuObject * plovMenu;

@property (nonatomic, assign) BOOL panelHidden;
@property (nonatomic, strong) UIGestureRecognizer * showPanelGesture;

@property (nonatomic, assign) int currentItem;

@property (nonatomic, strong) NSMutableArray * items;

@property (nonatomic, assign) NSInteger bucketSum;
@property (nonatomic, assign) BOOL arrowAnimation;

@property (nonatomic, strong) UIPanGestureRecognizer * panGesture;
@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;
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
    self.bucketSumLabel.textAlignment = NSTextAlignmentCenter;
    self.bucketSumLabel.clipsToBounds = YES;
    
    [self setupWithMenu:SHARED_APP.menuData];
    
    self.itemsScrollView.delegate = self;
    
    self.itemNameLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:18];
    self.itemDescriptionLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:16];

    
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(showDescriptionPanel:)];
    self.panGesture.delegate = self;
    [self.itemsScrollView addGestureRecognizer:self.panGesture];

    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDescriptionPanel:)];
    self.tapGesture.delegate = self;
    [self.itemsScrollView addGestureRecognizer:self.tapGesture];
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
            [self.items addObject:item];
        }
    }
    
    self.itemsScrollView.contentSize = CGSizeMake(self.items.count * self.itemsScrollView.width, self.itemsScrollView.height);
    
    _currentItem = -1;
    self.currentItem = 0;
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

- (void)hideDescriptionPanel:(UITapGestureRecognizer *)gestureRecognizer
{
    if (self.revealViewController.frontViewPosition == FrontViewPositionRight)
    {
        [self.revealViewController revealToggle:nil];
        return;
    }
    
    self.panelHidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.descriptionPanel.frame = CGRectMake(0, self.view.height - 151, self.view.width, 151);
    }];
}

- (void)showDescriptionPanel:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (self.revealViewController.frontViewPosition == FrontViewPositionRight)
    {
        [self.revealViewController revealToggle:nil];
        return;
    }
    
    CGPoint velocity = [gestureRecognizer velocityInView:self.itemsScrollView];
    
    if (fabs(velocity.y) > fabs(velocity.x))
    {
        if (velocity.y < -100)
        {
            self.panelHidden = NO;
            [UIView animateWithDuration:0.2 animations:^{
                CGFloat height = CGRectGetMaxY(self.itemDescriptionLabel.frame) + 80;
                self.descriptionPanel.frame = CGRectMake(0, self.view.height - height, self.view.width, height);
            }];
        }
    }
}

- (void)countChanged:(id)sender
{
    if (_currentItem >= 0 && _currentItem < self.items.count)
    {
        MenuItemObject * item = self.items[_currentItem];
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
                [UIView animateWithDuration:0.2 animations:^{
                    self.bucketSumLabel.alpha = 0;
                    self.cartIcon.x = self.view.width - self.cartIcon.width - 16;
                } completion:^(BOOL finished) {
                    [self.bucketSumLabel setText:@"" animated:NO];
                }];
            }
            else
            {
                self.bucketSumLabel.transitionEffect = BBCyclingLabelTransitionEffectScrollDown;
                [self.bucketSumLabel setText:@(self.bucketSum).stringValue animated:YES];
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
            MenuItemObject * item = self.items[_currentItem];
            self.bucketSum += item.cost;
            
            if (showSumm)
            {
                [self.bucketSumLabel setText:@(self.bucketSum).stringValue animated:NO];
                [UIView animateWithDuration:0.2 animations:^{
                    self.bucketSumLabel.alpha = 1;
                    self.cartIcon.x = self.view.width - self.cartIcon.width - 8 - self.bucketSumLabel.width;
                }];
            }
            else
            {
                self.bucketSumLabel.transitionEffect = BBCyclingLabelTransitionEffectScrollUp;
                [self.bucketSumLabel setText:@(self.bucketSum).stringValue animated:YES];
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
        MenuItemObject * item = self.items[_currentItem];
        if (![item.categoryId isEqualToString:self.menuView.currentCategory.categoryId])
        {
            [self.menuView selectCategory:item.categoryId];
        }
    }

}

- (void)setCurrentItem:(int)currentItem
{
    if (_currentItem != currentItem)
    {
        if (!self.panelHidden)
        {
            [self hideDescriptionPanel:nil];
        }
        
        _currentItem = currentItem;
        
        [self fillItemInfo];
    }
}

- (void)insertViewForPos:(int)pos
{
    if (pos >= 0 && pos < self.items.count)
    {
        UIImageView * iv = [[UIImageView alloc] initWithFrame:self.itemsScrollView.bounds];
        iv.tag = pos + 10100;
        
        MenuItemObject * item = self.items[pos];
        
        iv.image = item.image;
        
        iv.x = pos * iv.width;
        
        [self.itemsScrollView addSubview:iv];
    }
}

- (void)fillItemInfo
{
    for (int i = 0; i < self.itemsScrollView.subviews.count; i++)
    {
        UIView * view = self.itemsScrollView.subviews[i];
        
        if (view.tag < _currentItem + 10099 || view.tag > _currentItem + 10101)
        {
            [view removeFromSuperview];
        }
    }
    
    if (![self.itemsScrollView viewWithTag:_currentItem + 10100])
    {
        [self insertViewForPos:_currentItem];
    }
    
    if (![self.itemsScrollView viewWithTag:(_currentItem + 10099)])
    {
        [self insertViewForPos:(_currentItem - 1)];
    }
    
    if (![self.itemsScrollView viewWithTag:(_currentItem + 10101)])
    {
        [self insertViewForPos:(_currentItem + 1)];
    }
    
    if (_currentItem >= 0 && _currentItem < self.items.count)
    {
        MenuItemObject * item = self.items[_currentItem];
    
        self.itemNameLabel.text = [item.title uppercaseString];
        self.itemDescriptionLabel.text = item.desc;
        CGFloat w = self.itemDescriptionLabel.width;
        [self.itemDescriptionLabel sizeToFit];
        self.itemDescriptionLabel.width = w;
        
        
        self.weightLabel.text = [NSString stringWithFormat:LOC(@"LOC_MAIN_WEIGHT"), @(item.weight)];
        self.priceLabel.text = [NSString stringWithFormat:LOC(@"LOC_MAIN_COST"), @(item.cost)];
        [self.countLabel setText:@(item.count).stringValue animated:NO];
    }
}

- (void)selectingCategory:(MenuCategoryObject *)category
{
    NSInteger idx = [self.items indexOfObject:category.items.firstObject];
    
    self.currentItem = idx;
    
    CGRect rect = [self.itemsScrollView viewWithTag:_currentItem + 10100].frame;
    [self.itemsScrollView scrollRectToVisible:rect animated:YES];
}

@end
