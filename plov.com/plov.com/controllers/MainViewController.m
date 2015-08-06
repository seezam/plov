//
//  MainViewController.m
//  plov.com
//
//  Created by v.kubyshev on 05/08/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

@end
