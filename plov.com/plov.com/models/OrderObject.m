//
//  OrderObject.m
//  plov.com
//
//  Created by v.kubyshev on 07/09/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import "OrderObject.h"

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
//        _list = 
    }
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

@end
