//
//  MyAddressesViewController.m
//  plov.com
//
//  Created by v.kubyshev on 24/10/15.
//  Copyright © 2015 plov.com. All rights reserved.
//

#import "MyAddressesViewController.h"

#import "CustomerObject.h"
#import "AddressObject.h"

@interface MyAddressesViewController ()

@end

@implementation MyAddressesViewController

+ (PLTableViewController *)instantiateFromStoryboard:(UIStoryboard *)storyboard
{
    PLTableViewController * vc = [super instantiateFromStoryboard:storyboard];
    
    NSMutableArray * addresses = [NSMutableArray array];
    int i = 0;
    for (AddressObject * address in SHARED_APP.customer.addresses)
    {
        [addresses addObject:[PLTableItem textItem:@(i).stringValue withTitle:address.fullAddressString text:nil required:YES
                                              type:PLTableItemType_ListItem]];
    }
    vc.items = addresses;
    
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
