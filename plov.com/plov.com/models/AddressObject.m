//
//  AddressObject.m
//  plov.com
//
//  Created by v.kubyshev on 07/09/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import "AddressObject.h"

static const NSString * idField = @"id";
static const NSString * dateField = @"date";
static const NSString * addressField = @"address";
static const NSString * costField = @"cost";
static const NSString * listField = @"list";

@implementation AddressObject

- (instancetype)initWithData:(NSDictionary *)data
{
    if (self = [super init])
    {
        [self loadAddressData:data];
    }
    
    return self;
}

- (void)loadAddressData:(NSDictionary *)dict
{
    if (dict)
    {
        _city;
        _region;
        _street;
        _building;
        _house;
        _flat;
        _floor;
//        _orderId = dict[idField];
//        _date = [NSDate dateWithTimeIntervalSince1970:[dict[dateField] unsignedIntegerValue]];
//        _address = dict[addressField];
//        _cost = [dict[costField] integerValue];
        //        _list =
    }
}

- (NSDictionary *)addressToJson
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    return dict;
}

+ (NSArray *)addressesWithData:(NSArray *)data
{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:10];
    
    for (NSDictionary * address in data)
    {
        AddressObject * obj = [[AddressObject alloc] initWithData:address];
        [array addObject:obj];
    }
    
    return array;
}

@end
