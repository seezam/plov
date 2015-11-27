//
//  AddressObject.m
//  plov.com
//
//  Created by v.kubyshev on 07/09/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import "AddressObject.h"

static const NSString * idField = @"id";
static const NSString * cityField = @"city";
static const NSString * streetField = @"street";
static const NSString * buildingField = @"building";
static const NSString * houseField = @"house";
static const NSString * flatField = @"flat";
static const NSString * blockField = @"block";
static const NSString * floorField = @"floor";

@implementation AddressObject

- (instancetype)initWithData:(NSDictionary *)data
{
    if (self = [super init])
    {
        [self loadAddressData:data];
    }
    
    return self;
}

- (NSString *)fullAddressString
{
    NSMutableString * result = [NSMutableString string];
    
    [result appendString:self.city];
    [result appendString:@", "];
    [result appendString:self.street];
    [result appendString:@", "];
    [result appendString:self.building];
    
    if (self.house.length)
    {
        [result appendString:@"/"];
        [result appendString:self.house];
    }
    
    if (self.flat.length)
    {
        [result appendString:@", "];
        [result appendString:self.flat];
    }
    
    if (self.block.length)
    {
        [result appendString:@" ("];
        [result appendString:self.block];
        [result appendString:@")"];
    }
    
    if (self.floor.length)
    {
        [result appendString:@" ["];
        [result appendString:self.floor];
        [result appendString:@"]"];
    }
    
    return result;
}

//- (BOOL)isEqual:(id)object
//{
//    if ([super isEqual:object])
//    {
//        return YES;
//    }
//    
//    if ([object isKindOfClass:[AddressObject class]])
//    {
//        AddressObject * address = (AddressObject *)object;
//        
//        if ([address.city isEqualToString:address.city] &&
//            [address.street isEqualToString:address.street] &&
//            [address.building isEqualToString:address.building] &&
//            [address.house isEqualToString:address.house] &&
//            [address.block isEqualToString:address.block] &&
//            [address.flat isEqualToString:address.flat] &&
//            address.floor isEqualToString:<#(nonnull NSString *)#>)
//        {
//            return YES;
//        }
//    }
//    
//    return NO;
//}

- (void)loadAddressData:(NSDictionary *)dict
{
    if (dict)
    {
        _city = dict[cityField];
        _street = dict[streetField];
        _building = dict[buildingField];
        _house = dict[houseField];
        _flat = dict[flatField];
        _block = dict[blockField];
        _floor = dict[floorField];
    }
}

- (NSDictionary *)addressToJson
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    dict[cityField] = self.city?self.city:@"";
    dict[streetField] = self.street?self.street:@"";
    dict[buildingField] = self.building?self.building:@"";
    dict[houseField] = self.house?self.house:@"";
    dict[flatField] = self.flat?self.flat:@"";
    dict[blockField] = self.block?self.block:@"";
    dict[floorField] = self.floor?self.floor:@"";
    
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
