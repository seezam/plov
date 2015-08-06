//
//  PLNavigationController.m
//  plov.com
//
//  Created by Vladimir Kubyshev on 02.08.15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import "PLNavigationController.h"
#import "SWRevealViewController.h"

@interface PLNavigationController ()<SWRevealViewControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIBarButtonItem * item;
@property (nonatomic, strong) UIImageView * logo;

@end

@implementation PLNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 33, 27)];
    [button addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[PLResourseManager imageWithName:resImageMenu] forState:UIControlStateNormal];
    
    self.item = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.logo = [[UIImageView alloc] initWithImage:[PLResourseManager imageWithName:resImageLogo]];
    self.logo.tag = 'LOGO';
    self.logo.frame = CGRectMake(66, 0, self.logo.frame.size.width, self.logo.frame.size.height);
//    self.logo.frame = CGRectMake(66, 0, ceil(self.logo.frame.size.width/2), ceil(self.logo.frame.size.height/2));
 
    [self.navigationBar addSubview:self.logo];
    
    self.delegate = self;
    
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
//    [self.visibleViewController.view removeGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)setupController:(UIViewController *)controller
{
//    if (controller.navigationItem.titleView.tag != 'LOGO')
//    {
//        controller.navigationItem.titleView = self.logo;
//    }
    
    controller.navigationItem.leftBarButtonItem = self.item;
//    [controller.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (UIViewController *)rootViewController
{
    NSArray *viewControllers = self.viewControllers;
    if (!viewControllers.count)
    {
        return nil;
    }
    
    return [viewControllers objectAtIndex:0];
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    NSTimeInterval duration = [self.transitionCoordinator transitionDuration];
    if ((viewController != self.rootViewController))
    {
        self.logo.alpha = 0;
    }
    else
    {
        [UIView animateWithDuration:duration animations:^{
            self.logo.alpha = (viewController == self.rootViewController)?1:0;
        }];
    }
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    return [super popToViewController:viewController animated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
//    self.logo.hidden = NO;
//    
//    [self resetCurrentController];
//    [self setupController:self.rootViewController];
//    
    return [super popToRootViewControllerAnimated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
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

- (void)pushToViewController:(NSString *)viewControllerIdentifier
{
    UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:viewControllerIdentifier];
    
    [self pushViewController:vc animated:YES];
    [self.revealViewController revealToggle:nil];
}

//
//#pragma mark - Navigation
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    UIViewController * vc = self.storyboard instantiateViewControllerWithIdentifier:(NSString *)sender
//}

@end
