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
static const NSString * statusField = @"status";

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
        _status = [dict[statusField] integerValue];
        
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

- (OrderObject *)initWithMenuItems:(NSArray *)items orderId:(NSString *)orderId address:(NSString *)address
{
    if (self = [super init])
    {
        _orderId = orderId;
        _date = [NSDate date];
        _address = address;
        _status = OrderStatus_Created;
    
        NSInteger cost = 0;
        
        NSMutableArray * arr = [NSMutableArray arrayWithCapacity:items.count];
        for (MenuItemObject * item in items)
        {
            OrderItemObject * orderItem = [[OrderItemObject alloc] initWithMenuItem:item];
            
            cost += orderItem.cost*orderItem.count;
            
            [arr addObject:orderItem];
        }
        
        _cost = cost;
        
        _list = arr;
    }
    
    return self;
}

- (OrderObject *)initWithOrderCopy:(OrderObject *)order
{
    if (self = [super init])
    {
        _orderId = @"";
        _date = [NSDate date];
        _address = @"";
        _cost = order.cost;
        _list = [order.list copy];
        _status = OrderStatus_Created;
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
    res[statusField] = @(self.status);
    
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:self.list.count];
    
    for (OrderItemObject * item in self.list)
    {
        [arr addObject:[item orderItemToJson]];
    }
    
    res[listField] = arr;
    
    return res;
}

- (BOOL)incCountForItem:(OrderItemObject *)item
{
    for (OrderItemObject * i in self.list)
    {
        if (i == item)
        {
            if ([item incCount])
            {
                _cost += item.cost;
                
                return YES;
            }
        }
    }
    
    return NO;
}

- (BOOL)decCountForItem:(OrderItemObject *)item
{
    for (OrderItemObject * i in self.list)
    {
        if (i == item)
        {
            if ([item decCount])
            {
                _cost -= item.cost;
                
                return YES;
            }
        }
    }
    
    return NO;
}

- (void)removeItem:(OrderItemObject *)item
{
    NSMutableArray * newArray  = [self.list mutableCopy];
    
    for (OrderItemObject * i in newArray)
    {
        if ([i.name isEqualToString:item.name])
        {
            [newArray removeObject:i];
            _list = newArray;
            break;
        }
    }
}

- (void)updateOrderWithId:(NSString *)orderId address:(NSString *)address
{
    _address = address;
    _orderId = orderId;
}

- (void)updateOrderStatus:(NSString *)status
{
    if ([status isEqualToString:@"new"])
    {
        _status = OrderStatus_Created;
    }
    else if ([status isEqualToString:@"complete"])
    {
        _status = OrderStatus_Completed;
    }
    else if ([status isEqualToString:@"availability-confirmed"]||
             [status isEqualToString:@"send-to-assembling"]||
             [status isEqualToString:@"assembling"]||
             [status isEqualToString:@"assembling-complete"]||
             [status isEqualToString:@"offer-analog"]||
             [status isEqualToString:@"prepayed"]||
             [status isEqualToString:@"client-confirmed"])
    {
        _status = OrderStatus_Preparing;
    }
    else if ([status isEqualToString:@"send-to-delivery"]||
             [status isEqualToString:@"delivering"]||
             [status isEqualToString:@"redirect"])
    {
        _status = OrderStatus_Delivering;
    }
    else if ([status isEqualToString:@"no-product"]||
             [status isEqualToString:@"already-buyed"]||
             [status isEqualToString:@"no-call"]||
             [status isEqualToString:@"delyvery-did-not-suit"]||
             [status isEqualToString:@"prices-did-not-suit"]||
             [status isEqualToString:@"cancel-other"])
    {
        _status = OrderStatus_Cancelled;
    }
}

- (NSString *)statusString
{
    switch (_status) {
        case OrderStatus_Created:
            return LOC(@"ORDER_STATUS_CREATED");
            break;
        case OrderStatus_Preparing:
            return LOC(@"ORDER_STATUS_PREPARING");
            break;
        case OrderStatus_Delivering:
            return LOC(@"ORDER_STATUS_DELIVERING");
            break;
        case OrderStatus_Cancelled:
            return LOC(@"ORDER_STATUS_CANCELLED");
            break;
        case OrderStatus_Completed:
            return LOC(@"ORDER_STATUS_COMPLETED");
            break;
    }
}

@end
