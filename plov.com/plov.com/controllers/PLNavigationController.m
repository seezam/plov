//
//  PLNavigationController.m
//  plov.com
//
//  Created by Vladimir Kubyshev on 02.08.15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import "PLNavigationController.h"
#import "SWRevealViewController.h"

@interface PLNavigationController ()<SWRevealViewControllerDelegate>

@property (nonatomic, strong) UIBarButtonItem * item;

@end

@implementation PLNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 33, 27)];
    [button addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[PLResourseManager imageWithName:resImageMenu] forState:UIControlStateNormal];
    
    self.item = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        revealViewController.delegate = self;
        
        [self setupController:self.visibleViewController];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resetCurrentController
{
    self.visibleViewController.navigationItem.leftBarButtonItem = nil;
//    [self.visibleViewController.navigationItem.leftBarButtonItem setTarget:nil];
//    [self.visibleViewController.navigationItem.leftBarButtonItem setAction:NULL];
    [self.visibleViewController.view removeGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)setupController:(UIViewController *)controller
{
    controller.navigationItem.leftBarButtonItem = self.item;
//    [controller.navigationItem.leftBarButtonItem setTarget:self.revealViewController];
//    [controller.navigationItem.leftBarButtonItem setAction:@selector(revealToggle:)];
    [controller.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (UIViewController *)rootViewController
{
    NSArray *viewControllers = self.navigationController.viewControllers;
    return [viewControllers objectAtIndex:viewControllers.count - 2];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self resetCurrentController];
    [self setupController:viewController];
    
    return [super popToViewController:viewController animated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    [self resetCurrentController];
    [self setupController:self.rootViewController];
    
    return [super popToRootViewControllerAnimated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//    viewController.navigationItem.le
    
    [super pushViewController:viewController animated:animated];
}

#pragma mark - SWRevealDelegate

- (void)revealController:(SWRevealViewController *)revealController animateToPosition:(FrontViewPosition)position
{
    if (position == FrontViewPositionLeft)
    {
        CGAffineTransform transform = CGAffineTransformMakeRotation(0);
        self.item.customView.transform = transform;
    }
    else if (position == FrontViewPositionRight)
    {
        CGAffineTransform transform = CGAffineTransformMakeRotation(-M_PI_2);
        self.item.customView.transform = transform;
    }
}

- (void)revealController:(SWRevealViewController *)revealController panGestureMovedToLocation:(CGFloat)location progress:(CGFloat)progress
{
    CGFloat radians = atan2f(self.item.customView.transform.b, self.item.customView.transform.a);
    
    if (radians == 0)
    {
        [UIView animateWithDuration:0.2 animations:^{
            CGAffineTransform transform = CGAffineTransformMakeRotation(-M_PI_2);
            self.item.customView.transform = transform;
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
