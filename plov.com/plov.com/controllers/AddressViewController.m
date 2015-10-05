//
//  AddressViewController.m
//  plov.com
//
//  Created by v.kubyshev on 06/08/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import "AddressViewController.h"

@interface AddressViewController ()

@end

@implementation AddressViewController

+ (PLTableViewController *)instantiateFromStoryboard:(UIStoryboard *)storyboard
{
    PLTableViewController * vc = [super instantiateFromStoryboard:storyboard];
    
    PLTableItem * name = [[PLTableItem alloc] init];
    name.type = PLTableItemType_Text;
    name.title = LOC(@"LOC_NAME_FIELD");
    name.text = @"";
    name.placeholder = LOC(@"LOC_NAME_HINT");
    name.itemId = @"name";
    
    PLTableItem * phone = [[PLTableItem alloc] init];
    phone.type = PLTableItemType_Phone;
    phone.title = LOC(@"LOC_PHONE_FIELD");
    phone.text = @"";
    phone.placeholder = LOC(@"LOC_PHONE_HINT");
    phone.itemId = @"phone";
    
    vc.items = @[name, phone];
    
    return vc;
}


@end
