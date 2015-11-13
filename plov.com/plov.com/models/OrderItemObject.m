//
//  OrderItemObject.m
//  plov.com
//
//  Created by v.kubyshev on 16/10/15.
//  Copyright © 2015 plov.com. All rights reserved.
//

#import "OrderItemObject.h"
#import "MenuItemObject.h"

static const NSString * idField = @"id";
static const NSString * nameField = @"name";
static const NSString * costField = @"cost";
static const NSString * countField = @"count";


@implementation OrderItemObject

- (instancetype)initWithData:(NSDictionary *)data
{
    if (self = [super init])
    {
        [self loadOrderItemData:data];
    }
    
    return self;
}

- (void)loadOrderItemData:(NSDictionary *)dict
{
    if (dict)
    {
        _itemId = dict[idField];
        _name = dict[nameField];
        _cost = [dict[costField] integerValue];
        _count = [dict[countField] integerValue];
    }
}

- (OrderItemObject *)initWithMenuItem:(MenuItemObject *)item
{
    if (self = [super init])
    {
        _itemId = item.itemId;
        _cost = item.cost;
        _count = item.count;
        _name = item.title;
    }
    
    return self;
}

- (NSDictionary *)orderItemToJson
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    dict[idField] = self.itemId;
    dict[nameField] = self.name;
    dict[costField] = @(self.cost);
    dict[countField] = @(self.count);
    
    return dict;
}

- (BOOL)incCount
{
    _count++;
    
    if (_count > 99)
    {
        _count = 99;
        
        return NO;
    }
    
    return YES;
}

- (BOOL)decCount
{
    _count--;
    
    if (_count < 0)
    {
        _count = 0;
        
        return NO;
    }
    
    return YES;
}

@end
