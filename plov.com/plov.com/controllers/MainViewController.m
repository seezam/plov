//
//  MainViewController.m
//  plov.com
//
//  Created by v.kubyshev on 05/08/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import "MainViewController.h"

#import "PLMenuView.h"

#import "MenuObject.h"
#import "MenuCategoryObject.h"
#import "MenuItemObject.h"

@interface MainViewController ()
@property (nonatomic, strong) MenuObject * plovMenu;

@property (nonatomic, assign) BOOL panelHidden;
@property (nonatomic, strong) UIGestureRecognizer * showPanelGesture;

@property (nonatomic, assign) int itemsCount;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.panelHidden = YES;
    [self toggleDescriptionPanel];
    
    self.itemsCount = 1;
    [self.countMinusButton addTarget:self action:@selector(countChanged:) forControlEvents:UIControlEventTouchUpInside];
    [self.countPlusButton addTarget:self action:@selector(countChanged:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setupWithMenu:SHARED_APP.menuData];
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
    int steps = 7;
    int step = 1;
    
    __block CGFloat duration = 1.5;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self arrowAnimateWithStep:step forSteps:steps withDuration:duration];
    });
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
            return;
        }
        int newStep = step + 1;
        [self arrowAnimateWithStep:newStep forSteps:steps withDuration:duration];
    }];
}

- (void)setupWithMenu:(MenuObject *)menu
{
    self.plovMenu = menu;
    
    [self.menuView setupMenu:menu];
}

- (void)hideDescriptionPanel:(UITapGestureRecognizer *)gestureRecognizer
{
    self.panelHidden = YES;
    [self toggleDescriptionPanel];
    [UIView animateWithDuration:0.2 animations:^{
        self.descriptionPanel.frame = CGRectMake(0, self.view.height - 151, self.view.width, 151);
    }];
}

- (void)showDescriptionPanel:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint velocity = [gestureRecognizer velocityInView:self.itemsScrollView];
    
    if (velocity.y < -100)
    {
        self.panelHidden = NO;
        [self toggleDescriptionPanel];
        [UIView animateWithDuration:0.2 animations:^{
            CGFloat height = self.view.height/2;
            self.descriptionPanel.frame = CGRectMake(0, height, self.view.width, height);
        }];
    }
}

- (void)toggleDescriptionPanel
{
    if (_showPanelGesture)
    {
        [self.itemsScrollView removeGestureRecognizer:self.showPanelGesture];
        self.showPanelGesture = nil;
    }
    
    if (self.panelHidden)
    {
        UIPanGestureRecognizer * recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(showDescriptionPanel:)];
        self.showPanelGesture = recognizer;
        
        [self.itemsScrollView addGestureRecognizer:recognizer];
    }
    else
    {
        UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDescriptionPanel:)];
        self.showPanelGesture = recognizer;
        [self.itemsScrollView addGestureRecognizer:recognizer];
    }
}

- (void)countChanged:(id)sender
{
    if (sender == self.countMinusButton)
    {
        self.itemsCount--;
        
        if (self.itemsCount < 1)
        {
            self.itemsCount = 1;
        }
    }
    else
    {
        self.itemsCount++;
        
        if (self.itemsCount > 99)
        {
            self.itemsCount = 99;
        }
    }
    
    self.countLabel.text = @(self.itemsCount).stringValue;
}

@end
