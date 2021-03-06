//
//  OrderViewController.m
//  plov.com
//
//  Created by v.kubyshev on 22/08/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderTableViewCell.h"
#import "OrderItemObject.h"
#import "BBCyclingLabel.h"

#import "CustomerObject.h"
#import "OrderObject.h"
#import "MenuObject.h"
#import "MenuCategoryObject.h"
#import "MenuItemObject.h"

#import "PLTableViewController.h"
#import "PLTextTableViewCell.h"
#import "AddressViewController.h"
#import "NameViewController.h"

#import "PLCRMSupport.h"

@interface OrderViewController() <OrderTableViewDelegate>

@property (nonatomic, assign) NSInteger bucketSum;
@property (nonatomic, strong) OrderObject * order;


@end

@implementation OrderViewController

+ (OrderViewController *)instantiateWithStoryboard:(UIStoryboard *)storyboard order:(OrderObject *)order
{
    OrderViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"orderViewController"];
    vc.statusMode = NO;
    vc.order = order;
    
    return vc;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound)
    {
        [SHARED_APP resetMenuToOrder:self.order];
    }
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIColor * color = UIColorFromRGBA(resColorMenuText);
    
    //set back button arrow color
    [self.navigationController.navigationBar setTintColor:color];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.statusMode)
    {
        [SHARED_APP.crm getOrderInfo:self.order.orderId success:^(NSDictionary *data) {
            if ([data[@"success"] integerValue] == 1)
            {
                [self.order updateOrderStatus:data[@"order"][@"status"]];
                [SHARED_APP.customer saveData];
                
                [self.ordersTableView reloadData];
                
                [self updateNextButtonAnimated:YES];
            }
        } error:^(NSError *error) {
            
        }];
        
        [SHARED_APP.tracking openScreen:@"Order Status"];
    }
    else
    {
        [SHARED_APP.tracking openScreen:@"Order Edit"];
        [SHARED_APP.tracking orderStep:self.order step:1];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor * color = UIColorFromRGBA(resColorMenuText);
    
    [[UIBarButtonItem appearanceWhenContainedIn:[OrderViewController class], nil]
     setTitleTextAttributes:@{NSForegroundColorAttributeName:color }
     forState:UIControlStateNormal];
    
//    UIButton * button = [[UIButton alloc] init];
//    [button setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
//    [button sizeToFit];
//    
//    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
//    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
//    self.navigationItem.leftBarButtonItem = backItem;
    
    self.ordersTableView.delegate = self;
    self.ordersTableView.dataSource = self;
    
    self.cartIcon.x = self.view.width - self.cartIcon.width - 16;
    self.bucketSumLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:18];
    self.bucketSumLabel.textColor = UIColorFromRGBA(resColorMenuText);
    self.bucketSumLabel.textAlignment = NSTextAlignmentRight;
    self.bucketSumLabel.clipsToBounds = YES;
    
    self.cartIcon.hidden = YES;
    self.bucketSumLabel.hidden = YES;
    
    self.processButton.layer.cornerRadius = 10;
    if (self.statusMode)
    {
        [self updateNextButtonAnimated:NO];
    }
    else
    {
        [self.processButton setTitle:LOC(@"LOC_CONTINUE_BUTTON") forState:UIControlStateNormal];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableTapped:)];
        [self.ordersTableView addGestureRecognizer:tap];
    }
    
    self.bucketSum = self.order.cost;
    
    [self checkCartPosAnimated:NO];
    [self.bucketSumLabel setAttributedText:[SHARED_APP rubleCost:self.bucketSum font:self.bucketSumLabel.font] animated:NO];
    
    self.titleLabel.text = LOC(@"LOC_TITLE_ORDER");
    self.titleLabel.hidden = YES;
    
    [self setupOrderDelivery];
}

- (void)updateNextButtonAnimated:(BOOL)animated
{
    [self.processButton setTitle:LOC(@"LOC_ORDER_RETRY") forState:UIControlStateNormal];
    
    if (!animated)
    {
        if (self.order.status == OrderStatus_Completed ||
            self.order.status == OrderStatus_Cancelled)
        {
            self.processButton.hidden = NO;
            self.processButton.alpha = 1;
            self.ordersTableView.height = self.processButton.y - 5 - self.ordersTableView.y;
        }
        else
        {
            self.processButton.hidden = YES;
            self.ordersTableView.height = self.view.height - self.ordersTableView.y;
        }
    }
    
    if (self.order.status == OrderStatus_Completed ||
        self.order.status == OrderStatus_Cancelled)
    {
        if (self.processButton.hidden)
        {
            self.processButton.alpha = 0;
            self.processButton.hidden = NO;
            [UIView animateWithDuration:0.3 animations:^{
                self.processButton.alpha = 1;
                
                self.ordersTableView.height = self.processButton.y - 5 - self.ordersTableView.y;
            }];
        }
            
    }
    else
    {
        if (!self.processButton.hidden)
        {
            self.processButton.alpha = 1;
            [UIView animateWithDuration:0.3 animations:^{
                self.processButton.alpha = 0;
                
                self.ordersTableView.height = self.view.height - self.ordersTableView.y;
            } completion:^(BOOL finished) {
                self.processButton.hidden = YES;
            }];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.statusMode)
    {
        return self.order.list.count + 5; //delivery row + total row + address row + date row + status row
    }
    return self.order.list.count + 2; //delivery row + total row
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    if (row < self.order.list.count)
    {
        OrderTableViewCell *cell = (OrderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                                                         forIndexPath:indexPath];
        
        
        
        OrderItemObject * item = self.order.list[row];
        
        cell.titleLabel.text = item.name;
        [cell.countLabel setText:@(item.count).stringValue animated:NO];
        cell.delegate = self;
        [cell setCount:item.count withSum:item.cost];
        
        cell.readOnly = self.statusMode;
        
        return cell;
    }
    else
    {
        if (row == self.order.list.count)
        {
            PLTextTableViewCell * cell = nil;
            cell = [PLTextTableViewCell cellWithText:@(self.order.deliveryCost).stringValue
                                         placeholder:@""
                                                name:LOC(@"LOC_ORDER_DELIVERING")
                                             reuseId:@"delivery"
                                                type:PLTableItemType_ReadOnlyRuble
                                              blocks:nil
                                                last:NO];
            
            [cell hideDivider:NO];
            
            return cell;
        }
        else if (row == self.order.list.count + 1)
        {
            PLTextTableViewCell * cell = nil;
            NSInteger total = self.bucketSum + self.order.deliveryCost;
            
            cell = [PLTextTableViewCell cellWithText:@(total).stringValue
                                         placeholder:@""
                                                name:LOC(@"LOC_ORDER_TOTAL")
                                             reuseId:@"total"
                                                type:PLTableItemType_ReadOnlyRuble
                                              blocks:nil
                                                last:!self.statusMode];
            
            [cell hideDivider:!self.statusMode];
            
            return cell;
        }
        else if (row == self.order.list.count + 2)
        {
            PLTextTableViewCell * cell = nil;
            cell = [PLTextTableViewCell cellWithText:self.order.deliveryAddress
                                         placeholder:@""
                                                name:@""
                                             reuseId:@"address"
                                                type:PLTableItemType_ReadOnly
                                              blocks:nil
                                                last:NO];
            
            [cell hideDivider:NO];
            
            return cell;
        }
        else if (row == self.order.list.count + 3)
        {
            NSDateFormatter * df = [[NSDateFormatter alloc] init];
            df.dateStyle = NSDateFormatterShortStyle;
            df.timeStyle = NSDateFormatterShortStyle;
            NSString * date = [df stringFromDate:self.order.date];
            
            PLTextTableViewCell * cell = nil;
            cell = [PLTextTableViewCell cellWithText:date
                                         placeholder:@""
                                                name:LOC(@"LOC_ORDER_DATE_FIELD")
                                             reuseId:@"address"
                                                type:PLTableItemType_ReadOnly
                                              blocks:nil
                                                last:NO];
            
            [cell hideDivider:NO];
            
            return cell;
        }
        else
        {
            PLTextTableViewCell * cell = nil;
            cell = [PLTextTableViewCell cellWithText:self.order.statusString
                                         placeholder:@""
                                                name:LOC(@"LOC_ORDER_STATUS_FIELD")
                                             reuseId:@"status"
                                                type:PLTableItemType_ReadOnly
                                              blocks:nil
                                                last:YES];
            
            [cell hideDivider:YES];
            
            return cell;
        }
    }
    
    return nil;
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
    
    OrderItemObject * item = self.order.list[row];
    if (!incremented)
    {
        if (![self.order decCountForItem:item])
        {
            return 0;
        }
        
        NSString * categoryName = [[SHARED_APP.menuData categoryById:item.categoryId] titleForLng:@"ru"];
        NSString * itemName = [[SHARED_APP.menuData itemById:item.itemId] titleForLng:@"ru"];
        
        [SHARED_APP.tracking cartOperation:NO category:categoryName itemName:itemName
                                    itemId:item.itemId price:item.cost quantity:1];
        
        self.bucketSum = self.order.cost;
        
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
        if (![self.order incCountForItem:item])
        {
            return item.count;
        }
        
        NSString * categoryName = [[SHARED_APP.menuData categoryById:item.categoryId] title];
        [SHARED_APP.tracking cartOperation:YES category:categoryName itemName:item.name
                                    itemId:item.itemId price:item.cost quantity:1];
        
        BOOL showSumm = self.bucketSum == 0;
        self.bucketSum = self.order.cost;
        
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

- (void)orderCellWillSelect:(OrderTableViewCell *)cell
{
    NSIndexPath * path = [self.ordersTableView indexPathForCell:cell];
    [self.ordersTableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (void)orderCellDidDeselect:(OrderTableViewCell *)cell
{
    NSIndexPath * path = [self.ordersTableView indexPathForCell:cell];
    NSInteger row = path.row;
    
    OrderItemObject * item = self.order.list[row];
    
    if (item.count == 0)
    {
        [self.order removeItem:item];
        [self.ordersTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]]
                                    withRowAnimation:UITableViewRowAnimationTop];
    }
    
//    self.processButton.enabled = NO;
//    [UIView animateWithDuration:0.5 animations:^{
//        self.processButton.alpha = 0;
//    }];
    
    [self setupOrderDelivery];
}

- (void)setupOrderDelivery
{
    if (!self.statusMode)
    {
        if (self.bucketSum < SHARED_APP.menuData.freeDeliveryCost)
        {
            [self.order updateDeliveryCost:SHARED_APP.menuData.deliveryCost];
            [self updateDeliveryCost:YES];
        }
        else
        {
            [self.order updateDeliveryCost:0];
            [self updateDeliveryCost:NO];
        }
    }
}

- (void)updateDeliveryCost:(BOOL)up
{
    [self.ordersTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.order.list.count inSection:0],
                                                   [NSIndexPath indexPathForRow:self.order.list.count + 1 inSection:0]]
                                withRowAnimation:UITableViewRowAnimationNone];
    
    if (self.bucketSum > 0)
    {
        self.bucketSumLabel.transitionEffect = up?BBCyclingLabelTransitionEffectScrollUp:BBCyclingLabelTransitionEffectScrollDown;
        [self.bucketSumLabel setAttributedText:[SHARED_APP rubleCost:self.bucketSum font:self.bucketSumLabel.font] animated:YES];
        
        [self checkCartPosAnimated:YES];
    }
}

- (void)tableTapped:(UITapGestureRecognizer *)tap
{
    if (!self.statusMode)
    {
        CGPoint location = [tap locationInView:self.ordersTableView];
        NSIndexPath *path = [self.ordersTableView indexPathForRowAtPoint:location];
    
        [self.ordersTableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.ordersTableView selectRowAtIndexPath:nil animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (IBAction)processOrder:(id)sender
{
    OrderObject * order = self.order;
    
    if (order.cost < SHARED_APP.menuData.minimalCost)
    {
        NSString * message = [NSString stringWithFormat:LOC(@"LOC_MINIMAL_COST"),
                              @(SHARED_APP.menuData.minimalCost)];
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil
                                                         message:message
                                                        delegate:nil
                                               cancelButtonTitle:LOC(@"OK_ACTION")
                                               otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (self.statusMode)
    {
        order = [[OrderObject alloc] initWithOrderCopy:self.order];
    }
    
    if (!SHARED_APP.customer.name.length ||
        !SHARED_APP.customer.phone.length ||
        !SHARED_APP.customer.orders.count)
    {
        PLTableViewController * vc = [NameViewController instantiateFromStoryboard:self.storyboard];
        vc.order = order;
        vc.screenName = @"Name Order";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        PLTableViewController * vc = [AddressViewController instantiateFromStoryboard:self.storyboard withAddress:nil];
        vc.order = order;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
