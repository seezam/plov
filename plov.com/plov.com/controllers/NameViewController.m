//
//  AddressViewController.m
//  plov.com
//
//  Created by v.kubyshev on 06/08/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import "NameViewController.h"
#import "CustomerObject.h"

@interface NameViewController ()

@end

@implementation NameViewController

+ (PLTableViewController *)instantiateFromStoryboard:(UIStoryboard *)storyboard
{
    PLTableViewController * vc = [super instantiateFromStoryboard:storyboard];
    
    vc.items = @[
        [PLTableItem textItem:@"name" withTitle:LOC(@"LOC_ORDER_NAME_FIELD") text:SHARED_APP.customer.name required:YES],
        [PLTableItem textItem:@"phone" withTitle:LOC(@"LOC_ORDER_PHONE_FIELD") text:SHARED_APP.customer.phone required:YES],
    ];
        
    return vc;
}


@end
