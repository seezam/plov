//
//  ProcessViewController.h
//  plov.com
//
//  Created by v.kubyshev on 15/10/15.
//  Copyright © 2015 plov.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProcessViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
- (IBAction)doneClick:(id)sender;
@end
