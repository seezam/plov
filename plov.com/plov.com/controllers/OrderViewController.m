//
//  OrderViewController.m
//  plov.com
//
//  Created by v.kubyshev on 22/08/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderTableViewCell.h"
#import "MenuItemObject.h"
#import "BBCyclingLabel.h"

#import "CustomerObject.h"

@interface OrderViewController() <OrderTableViewDelegate>

@property (nonatomic, assign) NSInteger bucketSum;

@end

@implementation OrderViewController

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton * button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    [button sizeToFit];
    
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.ordersTableView.delegate = self;
    self.ordersTableView.dataSource = self;
    
    self.cartIcon.x = self.view.width - self.cartIcon.width - 16;
    self.bucketSumLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:18];
    self.bucketSumLabel.textColor = UIColorFromRGBA(resColorMenuText);
    self.bucketSumLabel.textAlignment = NSTextAlignmentRight;
    self.bucketSumLabel.clipsToBounds = YES;
    
    self.processButton.layer.cornerRadius = 10;
    
    for (MenuItemObject * item in self.order)
    {
        self.bucketSum += item.count * item.cost;
    }
    
    [self checkCartPosAnimated:NO];
    [self.bucketSumLabel setAttributedText:[SHARED_APP rubleCost:self.bucketSum font:self.bucketSumLabel.font] animated:NO];
    
    self.titleLabel.text = LOC(@"LOC_TITLE_ORDER");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.order.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderTableViewCell *cell = (OrderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSInteger row = indexPath.row;
    
    MenuItemObject * item = self.order[row];
    
    cell.titleLabel.text = item.title;
    [cell.countLabel setText:@(item.count).stringValue animated:NO];
    cell.delegate = self;
    [cell setCount:item.count withSum:item.cost];
    
    return cell;
}

- (void)checkCartPosAnimated:(BOOL)animated
{
    UILabel * testLabel = [[UILabel alloc] initWithFrame:self.bucketSumLabel.frame];
    testLabel.attributedText = [SHARED_APP rubleCost:self.bucketSum font:self.bucketSumLabel.font];
    [testLabel sizeToFit];
    NSInteger newX = self.view.width - self.cartIcon.width - 13 - ceil(testLabel.width/10)*10 - 3;
    
    if (newX != self.cartIcon.x)
    {
        if (animated)
        {
            [UIView animateWithDuration:0.2 animations:^{
                self.cartIcon.x = newX;
            }];
        }
        else
        {
            self.cartIcon.x = newX;
        }
    }
}


- (NSInteger)orderCell:(OrderTableViewCell *)cell countDidIncremented:(BOOL)incremented
{
    NSIndexPath * path = [self.ordersTableView indexPathForCell:cell];
    NSInteger row = path.row;
    
    MenuItemObject * item = self.order[row];
    if (!incremented)
    {
        item.count--;
        
        if (item.count < 0)
        {
            item.count = 0;
            return 0;
        }
        
        self.bucketSum -= item.cost;
        
        if (self.bucketSum == 0)
        {
            self.navigationItem.rightBarButtonItem = nil;
            
            [UIView animateWithDuration:0.2 animations:^{
                self.bucketSumLabel.alpha = 0;
                self.cartIcon.x = self.view.width - self.cartIcon.width - 13;
            } completion:^(BOOL finished) {
                [self.bucketSumLabel setText:@"" animated:NO];
            }];
        }
        else
        {
            [self checkCartPosAnimated:YES];
            
            self.bucketSumLabel.transitionEffect = BBCyclingLabelTransitionEffectScrollDown;
            [self.bucketSumLabel setAttributedText:[SHARED_APP rubleCost:self.bucketSum font:self.bucketSumLabel.font] animated:YES];
        }
    }
    else
    {
        item.count++;
        
        if (item.count > 99)
        {
            item.count = 99;
            return item.count;
        }
        
        BOOL showSumm = self.bucketSum == 0;
        self.bucketSum += item.cost;
        
        if (showSumm)
        {
//            self.navigationItem.rightBarButtonItem = self.orderButton;
            
            [self.bucketSumLabel setAttributedText:[SHARED_APP rubleCost:self.bucketSum font:self.bucketSumLabel.font] animated:NO];
            [UIView animateWithDuration:0.2 animations:^{
                self.bucketSumLabel.alpha = 1;
                
                [self checkCartPosAnimated:NO];
            }];
        }
        else
        {
            [self checkCartPosAnimated:YES];
            
            self.bucketSumLabel.transitionEffect = BBCyclingLabelTransitionEffectScrollUp;
            [self.bucketSumLabel setAttributedText:[SHARED_APP rubleCost:self.bucketSum font:self.bucketSumLabel.font] animated:YES];
        }
    }
    
    return item.count;
}

- (void)orderCellDidDeselect:(OrderTableViewCell *)cell
{
    NSIndexPath * path = [self.ordersTableView indexPathForCell:cell];
    NSInteger row = path.row;
    
    MenuItemObject * item = self.order[row];
    
    if (item.count == 0)
    {
        [self.order removeObject:item];
        [self.ordersTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.ordersTableView selectRowAtIndexPath:nil animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (IBAction)processOrder:(id)sender
{
    NSMutableDictionary * orderDict = [NSMutableDictionary dictionary];
    
//    orderDict[@"lastName"] = @"Pupkin";
    orderDict[@"firstName"] = SHARED_APP.customer.name;
    orderDict[@"phone"] = SHARED_APP.customer.phone;
    orderDict[@"contragentType"] = @"individual";

    NSMutableArray * orders = [NSMutableArray array];
    
    for (MenuItemObject * item in self.order)
    {
        NSDictionary * itemDesc = @{
                                @"initialPrice": @(item.cost),
                                @"purchasePrice": @(item.cost),
                                @"productName": item.title,
                                @"quantity": @(item.count),
                                };
        
        [orders addObject:itemDesc];
    }
    
    orderDict[@"items"] = orders;
    
    orderDict[@"delivery"] = @{@"address":
                                   @{
                                       @"city": @"muhosransk",
                                       @"region": @"muhosranskaya obl",
                                       @"street": @"muhosranskaya st.",
                                       @"building" : @"12",
                                       @"house": @"2",
                                       @"flat": @"64"
                                    }
                            };
    
    [SHARED_APP.crm createOrder:orderDict success:^(NSData *data) {
        
    } error:^(NSError *error) {
        
    }];
}

@end
