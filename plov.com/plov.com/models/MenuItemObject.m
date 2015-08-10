//
//  MenuItemObject.m
//  plov.com
//
//  Created by v.kubyshev on 07/08/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import "MenuItemObject.h"

@interface MenuItemObject ()
@property (nonatomic, strong) NSMutableDictionary * titles;
@end

@implementation MenuItemObject

- (NSString *)title
{
    return [self titleForLng:@""];
}

- (NSString *)titleForLng:(NSString *)lng
{
    return self.titles[lng];
}

- (void)setTitle:(NSString *)title forLng:(NSString *)lng
{
    self.titles[lng] = title;
}

- (instancetype)initWithData:(NSData *)data
{
    if (self = [super init])
    {
        _titles = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (instancetype)initWithId:(NSString *)itemId
{
    if (self = [super init])
    {
        _itemId = itemId;
        _titles = [NSMutableDictionary dictionary];
    }
    
    return self;
}

@end
