//
//  StartViewController.m
//  plov.com
//
//  Created by v.kubyshev on 06/08/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import "StartViewController.h"

#import "AFNetworkReachabilityManager.h"

@interface StartViewController ()

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self checkForNetwork];
}

static int checkingTryes = 0;
#define MAXIMUM_CHECKING_TRYES 10

#define DO_NOT_CHECK_INTERNET 1

- (void)checkForNetwork
{
#ifdef DO_NOT_CHECK_INTERNET
    [SHARED_APP startApplication:self.view];
    return;
#endif
    
    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus)
    {
        case AFNetworkReachabilityStatusNotReachable:
        {
            [SHARED_APP informNetworkIssue];
        }
            break;
        case AFNetworkReachabilityStatusUnknown:
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                checkingTryes++;
                
                if (checkingTryes < MAXIMUM_CHECKING_TRYES)
                {
                    [self checkForNetwork];
                }
                else
                {
                    [SHARED_APP informNetworkIssue];
                }
            });
        }
            break;
        default:
        {
            [SHARED_APP startApplication:self.view];
        }
            break;
    }
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
