//
//  StartViewController.m
//  plov.com
//
//  Created by v.kubyshev on 06/08/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import "StartViewController.h"

@interface StartViewController ()

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *viewControllerToBeShown = [storyBoard instantiateViewControllerWithIdentifier:@"beginViewController"];
        [SHARED_APP.window addSubview:viewControllerToBeShown.view];
        viewControllerToBeShown.view.alpha = 0;
        
        [UIView animateWithDuration:0.5 animations:^{
            self.view.alpha = 0;
            viewControllerToBeShown.view.alpha = 1;
        } completion:^(BOOL finished) {
            SHARED_APP.window.rootViewController = viewControllerToBeShown;
        }];
        
    });
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewControllerToBeShown = [storyBoard instantiateViewControllerWithIdentifier:@"beginViewController"];
    SHARED_APP.window.rootViewController = viewControllerToBeShown;
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

@end
