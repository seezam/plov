//
//  ProcessViewController.h
//  plov.com
//
//  Created by v.kubyshev on 15/10/15.
//  Copyright © 2015 plov.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderObject;

@interface ProcessViewController : UIViewController

@property (nonatomic, strong) OrderObject * order;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *callCenterButton;
@property (weak, nonatomic) IBOutlet UILabel *orLabel;
- (IBAction)doneClick:(id)sender;
@end
