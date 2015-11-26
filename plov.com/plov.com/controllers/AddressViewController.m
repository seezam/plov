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

+ (PLTableViewController *)instantiateFromStoryboard:(UIStoryboard *)storyboard withAddress:(AddressObject*)address
{
    PLTableViewController * vc = [self instantiateFromStoryboard:storyboard];
    
    AddressObject * lastAddress = address?address:SHARED_APP.customer.addresses.lastObject;
    
    vc.fillDataBlock = ^(PLTableViewController * controller) {
        if (!address)
        {
            [SHARED_APP.tracking orderStep:controller.order step:2];
        }
        
        controller.items = @[
                     [PLTableItem textItem:@"city" withTitle:LOC(@"LOC_ORDER_CITY_FIELD") text:LOC(@"LOC_ORDER_CITY_DEF")
                                  required:YES
                                      type:PLTableItemType_ReadOnly],
                     [PLTableItem textItem:@"street" withTitle:LOC(@"LOC_ORDER_STREET_FIELD") text:lastAddress.street
                                  required:YES
                                      type:PLTableItemType_Text],
                     
                     [PLTableItem complexItem:@"building"
                                    withTitle:@""
                                       blocks:@[
                                                
                                                [PLTableItem textItem:@"building" withTitle:LOC(@"LOC_ORDER_BUILDING_FIELD")
                                                                 text:lastAddress.building
                                                             required:YES type:PLTableItemType_Number],
                                                [PLTableItem textItem:@"house" withTitle:LOC(@"LOC_ORDER_HOUSE_FIELD")
                                                                 text:lastAddress.house
                                                             required:NO type:PLTableItemType_Number],
                                                [PLTableItem textItem:@"block" withTitle:LOC(@"LOC_ORDER_BLOCK_FIELD")
                                                                 text:lastAddress.block
                                                             required:NO type:PLTableItemType_Number],
                                                [PLTableItem textItem:@"flat" withTitle:LOC(@"LOC_ORDER_FLAT_FIELD")
                                                                 text:lastAddress.flat
                                                             required:YES type:PLTableItemType_Number],
                                                [PLTableItem textItem:@"floor" withTitle:LOC(@"LOC_ORDER_FLOOR_FIELD")
                                                                 text:lastAddress.floor
                                                             required:NO type:PLTableItemType_Number]

                                                ]]
                     
                     ];

    };
    
    vc.nextButtonBlock = ^(PLTableViewController * controller){
        AddressObject * createdAddress = [[AddressObject alloc] init];
        
        for (PLTableItem * item in controller.items)
        {
            if ([item.itemId isEqualToString:@"city"])
            {
                createdAddress.city = item.text;
            }
            else if ([item.itemId isEqualToString:@"street"])
            {
                createdAddress.street = item.text;
            }
            else if ([item.itemId isEqualToString:@"building"])
            {
                for (PLTableItem * buildItem in item.blocks)
                {
                    if ([buildItem.itemId isEqualToString:@"building"])
                    {
                        createdAddress.building = buildItem.text;
                    }
                    else if ([buildItem.itemId isEqualToString:@"house"])
                    {
                        createdAddress.house = buildItem.text;
                    }
                    else if ([buildItem.itemId isEqualToString:@"block"])
                    {
                        createdAddress.block = buildItem.text;
                    }
                    else if ([buildItem.itemId isEqualToString:@"flat"])
                    {
                        createdAddress.flat = buildItem.text;
                    }
                    else if ([buildItem.itemId isEqualToString:@"floor"])
                    {
                        createdAddress.floor = buildItem.text;
                    }
                }
                
            }
        }
        
        if (address)
        {
            [controller.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [SHARED_APP.customer setLastAddress:createdAddress];
        
            ProcessViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"processViewController"];
            vc.order = controller.order;
            [controller.navigationController pushViewController:vc animated:YES];
        }
    };
    
    vc.trashButtonBlock = ^(PLTableViewController * controller){        
        [SHARED_APP.customer deleteAddress:address];
        [SHARED_APP.customer saveData];
        
        [controller.navigationController popViewControllerAnimated:YES];
    };
    
    vc.screenName = @"Order Address";
    return vc;
}


@end
