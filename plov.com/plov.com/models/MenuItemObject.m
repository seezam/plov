//
//  MenuItemObject.m
//  plov.com
//
//  Created by v.kubyshev on 07/08/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import "MenuItemObject.h"

@implementation MenuItemObject

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
        
    }
    
    return self;
}

@end
