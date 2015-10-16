//
//  AddressViewController.m
//  plov.com
//
//  Created by v.kubyshev on 06/08/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import "AddressViewController.h"
#import "ProcessViewController.h"

#import "CustomerObject.h"
#import "AddressObject.h"

@interface AddressViewController ()

@end

@implementation AddressViewController

+ (PLTableViewController *)instantiateFromStoryboard:(UIStoryboard *)storyboard
{
    PLTableViewController * vc = [super instantiateFromStoryboard:storyboard];
    
    AddressObject * lastAddress = SHARED_APP.customer.addresses.lastObject;
    
    vc.items = @[
        [PLTableItem textItem:@"city" withTitle:LOC(@"LOC_ORDER_CITY_FIELD") text:lastAddress.city required:YES
                         type:PLTableItemType_Text],
        [PLTableItem textItem:@"street" withTitle:LOC(@"LOC_ORDER_STREET_FIELD") text:lastAddress.street required:YES
                         type:PLTableItemType_Text],
        [PLTableItem textItem:@"building" withTitle:LOC(@"LOC_ORDER_BUILDING_FIELD") text:lastAddress.building required:YES
                         type:PLTableItemType_Number],
        [PLTableItem textItem:@"house" withTitle:LOC(@"LOC_ORDER_HOUSE_FIELD") text:lastAddress.house required:NO
                         type:PLTableItemType_Number],
        [PLTableItem textItem:@"block" withTitle:LOC(@"LOC_ORDER_BLOCK_FIELD") text:lastAddress.block required:NO
                         type:PLTableItemType_Number],
        [PLTableItem textItem:@"flat" withTitle:LOC(@"LOC_ORDER_FLAT_FIELD") text:lastAddress.flat required:YES
                         type:PLTableItemType_Number],
    ];
    
    vc.nextBlock = ^(PLTableViewController * controller){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            AddressObject * address = [[AddressObject alloc] init];
            
            for (PLTableItem * item in controller.items)
            {
                if ([item.itemId isEqualToString:@"city"])
                {
                    address.city = item.text;
                }
                else if ([item.itemId isEqualToString:@"street"])
                {
                    address.street = item.text;
                }
                else if ([item.itemId isEqualToString:@"building"])
                {
                    address.building = item.text;
                }
                else if ([item.itemId isEqualToString:@"house"])
                {
                    address.house = item.text;
                }
                else if ([item.itemId isEqualToString:@"block"])
                {
                    address.block = item.text;
                }
                else if ([item.itemId isEqualToString:@"flat"])
                {
                    address.flat = item.text;
                }
            }
            
            [SHARED_APP.customer setLastAddress:address];
            
            ProcessViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"processViewController"];
            vc.order = controller.order;
            vc.bucketSum = controller.bucketSum;
//
            [controller.navigationController pushViewController:vc animated:YES];
        });
    };
        
    return vc;
}


@end
