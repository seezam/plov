//
//  MenuCategoryObject.m
//  plov.com
//
//  Created by v.kubyshev on 07/08/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import "MenuCategoryObject.h"

@implementation MenuCategoryObject

- (NSString *)title
{
    return [self titleForLng:@""];
}

- (NSString *)titleForLng:(NSString *)lng
{
    return @"";
}

- (instancetype)initWithData:(NSData *)data
{
    if (self = [super init])
    {
        _items = [self readItems:data];
    }
    
    return self;
}

- (NSArray *)readItems:(NSData *)data
{
    return @[];
}

@end
