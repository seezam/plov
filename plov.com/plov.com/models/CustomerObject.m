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
#import "MenuItemObject.h"

static const NSString * nameField = @"name";
static const NSString * phoneField = @"phone";
static const NSString * mailField = @"mail";

static const NSString * ordersField = @"orders";
static const NSString * addressesField = @"addresses";

@implementation CustomerObject

- (instancetype)init
{
    if (self = [super init])
    {
        [self loadData];
    }
    
    return self;
}

- (NSString *)dataPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path = [[paths objectAtIndex:0] copy];
    
    path = [path stringByAppendingPathComponent:@"customer.dat"];
    
    return path;
}

- (void)loadData
{
    NSData * data = [NSData dataWithContentsOfFile:[self dataPath]];
    
    if (data)
    {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        
        self.name = dict[nameField];
        self.phone = dict[phoneField];
        self.mail = dict[mailField];
        
        self.orders = [OrderObject ordersWithData:dict[ordersField]];
        self.addresses = [AddressObject addressesWithData:dict[addressesField]];
    }
    else
    {
        self.orders = [NSArray array];
        self.addresses = [NSArray array];
    }
}

- (void)saveData
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    if (self.name)
    {
        dict[nameField] = self.name;
    }

    if (self.phone)
    {
        dict[phoneField] = self.phone;
    }
    
    if (self.mail)
    {
        dict[mailField] = self.mail;
    }
    
    if (self.orders.count)
    {
        NSMutableArray * orders = [NSMutableArray arrayWithCapacity:self.orders.count];
        
        for (OrderObject * order in self.orders)
        {
            [orders addObject:[order orderToJson]];
        }
        dict[ordersField] = orders;
    }
    
    if (self.addresses.count)
    {
        NSMutableArray * addresses = [NSMutableArray arrayWithCapacity:self.addresses.count];
        
        for (AddressObject * address in self.addresses)
        {
            [addresses addObject:[address addressToJson]];
        }
        
        dict[addressesField] = addresses;
    }
    
    NSData * data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:NULL];
    
    [data writeToFile:[self dataPath] atomically:YES];
}

- (OrderObject *)orderWithId:(NSString *)orderId
{
    for (OrderObject * o in self.orders)
    {
        if ([o.orderId isEqualToString:orderId])
        {
            return o;
        }
    }
    
    return nil;
}

- (void)deleteAddress:(AddressObject *)address
{
    NSMutableArray * addresses = [self.addresses mutableCopy];
    
    for (AddressObject * item in addresses)
    {
        if ([[item fullAddressString] isEqualToString:[address fullAddressString]])
        {
            [addresses removeObject:item];
            break;
        }
    }
    
    self.addresses = addresses;
}

- (void)setLastAddress:(AddressObject *)address
{
    NSMutableArray * addresses = [self.addresses mutableCopy];
    
    for (AddressObject * item in addresses)
    {
        if ([[item fullAddressString] isEqualToString:[address fullAddressString]])
        {
            [addresses removeObject:item];
            break;
        }
    }
    
    [addresses addObject:address];
    
    self.addresses = addresses;
}

- (void)setLastOrder:(OrderObject *)order
{
    NSMutableArray * orders = [self.orders mutableCopy];
    
    [orders insertObject:order atIndex:0];
    
    self.orders = orders;
}

@end
