//
//  OrderViewController.h
//  plov.com
//
//  Created by v.kubyshev on 22/08/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBCyclingLabel;
@class OrderObject;

@interface OrderViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

+ (OrderViewController *)instantiateWithStoryboard:(UIStoryboard *)storyboard order:(OrderObject *)order;

//@property (strong, nonatomic) NSMutableArray * order;

@property (weak, nonatomic) IBOutlet UITableView *ordersTableView;
@property (weak, nonatomic) IBOutlet UIButton *processButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@property (weak, nonatomic) IBOutlet UIImageView *cartIcon;
@property (weak, nonatomic) IBOutlet BBCyclingLabel *bucketSumLabel;

@property (assign, nonatomic) BOOL statusMode;

- (IBAction)processOrder:(id)sender;
@end
