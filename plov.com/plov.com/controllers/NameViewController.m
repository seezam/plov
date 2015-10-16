//
//  AddressViewController.m
//  plov.com
//
//  Created by v.kubyshev on 06/08/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import "NameViewController.h"
#import "AddressViewController.h"
#import "CustomerObject.h"


@interface NameViewController ()

@end

@implementation NameViewController

+ (PLTableViewController *)instantiateFromStoryboard:(UIStoryboard *)storyboard
{
    PLTableViewController * vc = [super instantiateFromStoryboard:storyboard];
    
    vc.items = @[
        [PLTableItem textItem:@"name" withTitle:LOC(@"LOC_ORDER_NAME_FIELD") text:SHARED_APP.customer.name required:YES
                         type:PLTableItemType_Text],
        [PLTableItem textItem:@"phone" withTitle:LOC(@"LOC_ORDER_PHONE_FIELD") text:SHARED_APP.customer.phone required:YES
                         type:PLTableItemType_Phone],
    ];
    
    vc.nextBlock = ^(PLTableViewController * controller){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            for (PLTableItem * item in controller.items)
            {
                if ([item.itemId isEqualToString:@"name"])
                {
                    SHARED_APP.customer.name = item.text;
                }
                else if ([item.itemId isEqualToString:@"phone"])
                {
                    SHARED_APP.customer.phone = item.text;
                }
            }
            
            PLTableViewController * vc = [AddressViewController instantiateFromStoryboard:storyboard];
            vc.bucketSum = controller.bucketSum;
            vc.order = controller.order;
            
            [controller.navigationController pushViewController:vc animated:YES];
        });
    };
        
    return vc;
}


@end
