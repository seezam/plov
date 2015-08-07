//
//  MenuObject.m
//  plov.com
//
//  Created by v.kubyshev on 07/08/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import "MenuObject.h"

@implementation MenuObject

- (instancetype)initWithData:(NSData *)data
{
    if (self = [super init])
    {
        _categories = [self readCategories:data];
    }
    
    return self;
}

- (NSArray *)readCategories:(NSData *)data
{
    return @[];
}

@end
