//
//  MyAddressesViewController.m
//  plov.com
//
//  Created by v.kubyshev on 24/10/15.
//  Copyright © 2015 plov.com. All rights reserved.
//

#import "MyAddressesViewController.h"

#import "AddressViewController.h"

#import "CustomerObject.h"
#import "AddressObject.h"

@interface MyAddressesViewController ()

@end

@implementation MyAddressesViewController

+ (PLTableViewController *)instantiateFromStoryboard:(UIStoryboard *)storyboard
{
    PLTableViewController * vc = [super instantiateFromStoryboard:storyboard];
    
    vc.fillDataBlock = ^(PLTableViewController * controller) {
        NSMutableArray * addresses = [NSMutableArray array];
        int i = 0;
        for (AddressObject * address in SHARED_APP.customer.addresses)
        {
            [addresses addObject:[PLTableItem textItem:@(i++).stringValue withTitle:address.fullAddressString text:nil required:YES
                                                  type:PLTableItemType_ListItem1]];
        }
        controller.items = addresses;
    };
    
    vc.itemSelectBlock = ^(PLTableViewController * controller, PLTableItem * item) {
        dispatch_async(dispatch_get_main_queue(), ^{
            AddressObject * address = SHARED_APP.customer.addresses[item.itemId.intValue];
            
            PLTableViewController * avc = [AddressViewController instantiateFromStoryboard:storyboard withAddress:address];
            avc.buttonMode = PLTableButtonMode_SaveDelete;
            avc.screenName = @"Address Edit";
            [controller.navigationController pushViewController:avc animated:YES];
        });
    };
    
    vc.buttonMode = PLTableButtonMode_None;
    
    vc.screenName = @"My Addresses";
    return vc;
}

@end
