//
//  OrderObject.m
//  plov.com
//
//  Created by v.kubyshev on 07/09/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import "OrderObject.h"
#import "OrderItemObject.h"

#import "MenuItemObject.h"

static const NSString * idField = @"id";
static const NSString * dateField = @"date";
static const NSString * addressField = @"address";
static const NSString * costField = @"cost";
static const NSString * listField = @"list";

@implementation OrderObject

- (instancetype)initWithData:(NSDictionary *)data
{
    if (self = [super init])
    {
        [self loadOrderData:data];
    }
    
    return self;
}

- (void)loadOrderData:(NSDictionary *)dict
{
    if (dict)
    {
        _orderId = dict[idField];
        _date = [NSDate dateWithTimeIntervalSince1970:[dict[dateField] unsignedIntegerValue]];
        _address = dict[addressField];
        _cost = [dict[costField] integerValue];
        
        NSArray * items = dict[listField];
        NSMutableArray * arr = [NSMutableArray arrayWithCapacity:items.count];

        for (NSDictionary * item in items)
        {
            OrderItemObject * orderItem = [[OrderItemObject alloc] initWithData:item];
            [arr addObject:orderItem];
        }
        
        _list = arr;
    }
}

- (OrderObject *)initWithMenuItems:(NSArray *)items orderId:(NSString *)orderId address:(NSString *)address cost:(NSInteger)cost
{
    if (self = [super init])
    {
        _orderId = orderId;
        _date = [NSDate date];
        _address = address;
        _cost = cost;
    
        NSMutableArray * arr = [NSMutableArray arrayWithCapacity:items.count];
        for (MenuItemObject * item in items)
        {
            OrderItemObject * orderItem = [[OrderItemObject alloc] initWithMenuItem:item];
            [arr addObject:orderItem];
        }
        
        _list = arr;
    }
    
    return self;
}

+ (NSArray *)ordersWithData:(NSArray *)data
{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:10];
    
    for (NSDictionary * order in data)
    {
        OrderObject * obj = [[OrderObject alloc] initWithData:order];
        [array addObject:obj];
    }
    
    return array;
}

- (NSDictionary *)orderToJson
{
    NSMutableDictionary * res = [NSMutableDictionary dictionary];
    
    res[idField] = self.orderId;
    res[dateField] = @([self.date timeIntervalSince1970]);
    res[addressField] = self.address;
    res[costField] = @(self.cost);
    
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:self.list.count];
    
    for (OrderItemObject * item in self.list)
    {
        [arr addObject:[item orderItemToJson]];
    }
    
    res[listField] = arr;
    
    return res;
}

@end
