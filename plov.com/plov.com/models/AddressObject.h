//
//  AddressObject.h
//  plov.com
//
//  Created by v.kubyshev on 07/09/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressObject : NSObject

@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * region;
@property (nonatomic, strong) NSString * street;
@property (nonatomic, strong) NSString * building;
@property (nonatomic, strong) NSString * house;
@property (nonatomic, strong) NSString * flat;
@property (nonatomic, strong) NSString * floor;

+ (NSArray *)addressesWithData:(NSArray *)data;

@end
