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
    
    vc.fillDataBlock = ^(PLTableViewController * controller){
        if (controller.buttonMode != PLTableButtonMode_Save)
        {
            [SHARED_APP.tracking orderStep:controller.order step:3];
        }
        
        controller.items = @[
                     [PLTableItem textItem:@"name" withTitle:LOC(@"LOC_ORDER_NAME_FIELD") text:SHARED_APP.customer.name
                                  required:YES
                                      type:PLTableItemType_Name],
                     [PLTableItem textItem:@"phone" withTitle:LOC(@"LOC_ORDER_PHONE_FIELD") text:SHARED_APP.customer.phone
                                  required:YES
                                      type:PLTableItemType_Phone],
                     [PLTableItem textItem:@"mail" withTitle:LOC(@"LOC_ORDER_EMAIL_FIELD") text:SHARED_APP.customer.mail
                                  required:NO
                                      type:PLTableItemType_Email],
                     ];
    };
    
    vc.nextButtonBlock = ^(PLTableViewController * controller){
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
            else if ([item.itemId isEqualToString:@"mail"])
            {
                SHARED_APP.customer.mail = item.text;
            }
        }
        
        if (controller.buttonMode == PLTableButtonMode_Save)
        {
            [SHARED_APP.customer saveData];
            [SHARED_APP resetMenuToOrder:nil];
            [controller.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            PLTableViewController * vc = [AddressViewController instantiateFromStoryboard:storyboard withAddress:nil];
            vc.order = controller.order;
            vc.screenName = @"Order Address";
            
            [controller.navigationController pushViewController:vc animated:YES];
        }
    };
    
    vc.screenName = @"My Name";
    
    return vc;
}


@end
