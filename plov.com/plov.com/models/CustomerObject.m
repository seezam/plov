//
//  CustomerObject.m
//  plov.com
//
//  Created by v.kubyshev on 07/09/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import "CustomerObject.h"
#import "OrderObject.h"
#import "AddressObject.h"

NSString * nameField = @"name";
NSString * phoneField = @"phone";
NSString * mailField = @"mail";

NSString * ordersField = @"orders";
NSString * addressesField = @"addresses";

@implementation CustomerObject

- (instancetype)init
{
    if (self = [super init])
    {
        [self loadCustomerData];
    }
    
    return self;
}

- (void)loadCustomerData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path = [[paths objectAtIndex:0] copy];
    
    path = [path stringByAppendingPathComponent:@"customer.dat"];
    
    NSData * data = [NSData dataWithContentsOfFile:path];
    
    if (data)
    {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        
        self.name = dict[nameField];
        self.phone = dict[phoneField];
        self.mail = dict[mailField];
        
        self.orders = [OrderObject ordersWithData:dict[ordersField]];
        self.addresses = [AddressObject addressesWithData:dict[addressesField]];
    }
}

@end
