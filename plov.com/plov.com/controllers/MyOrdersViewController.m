//
//  MyOrdersViewController.m
//  plov.com
//
//  Created by v.kubyshev on 24/10/15.
//  Copyright © 2015 plov.com. All rights reserved.
//

#import "MyOrdersViewController.h"

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
    int i = 0;
    for (OrderObject * order in SHARED_APP.customer.orders)
    {
        NSString * address = order.address;
        
        NSDateFormatter * df = [[NSDateFormatter alloc] init];
        df.dateStyle = NSDateFormatterShortStyle;
        df.timeStyle = NSDateFormatterShortStyle;
        NSString * date = [df stringFromDate:order.date];
        
        NSString * title = [NSString stringWithFormat:@"%@\n%@", address, date];
        
        [orders addObject:[PLTableItem textItem:@(i).stringValue withTitle:title text:nil required:YES
                                              type:PLTableItemType_ListItem]];
    }
    vc.items = orders;
    
    vc.nextBlock = ^(PLTableViewController * controller){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //            for (PLTableItem * item in controller.items)
            //            {
            //                if ([item.itemId isEqualToString:@"name"])
            //                {
            //                    SHARED_APP.customer.name = item.text;
            //                }
            //                else if ([item.itemId isEqualToString:@"phone"])
            //                {
            //                    SHARED_APP.customer.phone = item.text;
            //                }
            //                else if ([item.itemId isEqualToString:@"mail"])
            //                {
            //                    SHARED_APP.customer.mail = item.text;
            //                }
            //            }
            //
            //            if (controller.editMode)
            //            {
            //                [SHARED_APP.customer saveData];
            //                [SHARED_APP updateMenu];
            //                [controller.navigationController popToRootViewControllerAnimated:YES];
            //            }
            //            else
            //            {
            //                PLTableViewController * vc = [AddressViewController instantiateFromStoryboard:storyboard];
            //                vc.bucketSum = controller.bucketSum;
            //                vc.order = controller.order;
            //                
            //                [controller.navigationController pushViewController:vc animated:YES];
            //            }
        });
    };
    
    vc.editMode = YES;
    return vc;
}

@end
