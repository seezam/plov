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
    
    vc.items = @[
        [PLTableItem textItem:@"city" withTitle:LOC(@"LOC_ORDER_CITY_FIELD") text:@"" required:YES],
        [PLTableItem textItem:@"street" withTitle:LOC(@"LOC_ORDER_STREET_FIELD") text:@"" required:YES],
        [PLTableItem textItem:@"building" withTitle:LOC(@"LOC_ORDER_BUILDING_FIELD") text:@"" required:YES],
        [PLTableItem textItem:@"house" withTitle:LOC(@"LOC_ORDER_HOUSE_FIELD") text:@"" required:NO],
        [PLTableItem textItem:@"block" withTitle:LOC(@"LOC_ORDER_BLOCK_FIELD") text:@"" required:NO],
        [PLTableItem textItem:@"flat" withTitle:LOC(@"LOC_ORDER_FLAT_FIELD") text:@"" required:YES],
    ];
        
    return vc;
}


@end
