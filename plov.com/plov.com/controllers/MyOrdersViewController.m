//
//  MyOrdersViewController.m
//  plov.com
//
//  Created by v.kubyshev on 24/10/15.
//  Copyright © 2015 plov.com. All rights reserved.
//

#import "MyOrdersViewController.h"
#import "OrderViewController.h"

#import "CustomerObject.h"
#import "AddressObject.h"
#import "OrderObject.h"

@interface MyOrdersViewController ()

@end

@implementation MyOrdersViewController

+ (PLTableViewController *)instantiateFromStoryboard:(UIStoryboard *)storyboard
{
    PLTableViewController * vc = [super instantiateFromStoryboard:storyboard];
    
    NSMutableArray * orders = [NSMutableArray array];
    for (OrderObject * order in SHARED_APP.customer.orders)
    {
        NSString * address = order.address;
        
        NSDateFormatter * df = [[NSDateFormatter alloc] init];
        df.dateStyle = NSDateFormatterShortStyle;
        df.timeStyle = NSDateFormatterShortStyle;
        NSString * date = [df stringFromDate:order.date];
        
        NSString * title = [NSString stringWithFormat:@"%@\n%@", address, date];
        
        [orders addObject:[PLTableItem textItem:order.orderId withTitle:title text:nil required:YES
                                              type:PLTableItemType_ListItem]];
    }
    vc.items = orders;
    
    vc.itemSelectBlock = ^(PLTableViewController * controller, PLTableItem * item) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            OrderObject * order = [SHARED_APP.customer orderWithId:item.itemId];
//            
//            PLTableViewController * avc = [OrderViewController instantiateFromStoryboard:storyboard withAddress:address];
//            avc.editMode = YES;
//            [controller.navigationController pushViewController:avc animated:YES];
        });
    };
    
    vc.nextBlock = ^(PLTableViewController * controller){
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    };
    
    vc.editMode = YES;
    return vc;
}

@end
