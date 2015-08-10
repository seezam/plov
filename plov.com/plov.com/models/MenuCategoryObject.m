//
//  MenuCategoryObject.m
//  plov.com
//
//  Created by v.kubyshev on 07/08/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import "MenuCategoryObject.h"
#import "MenuItemObject.h"

@interface MenuCategoryObject ()
@property (nonatomic, strong) NSMutableDictionary * titles;
@end

@implementation MenuCategoryObject

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
        _items = [self readItems:data];
        _titles = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (instancetype)initWithId:(NSString *)categoryId
{
    if (self = [super init])
    {
        _categoryId = categoryId;
        _titles = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (NSArray *)readItems:(NSData *)data
{
    return @[];
}

- (void)checkArray
{
    if (!_items)
    {
        _items = [NSArray array];
    }
}

- (void)addMenuItem:(MenuItemObject *)item
{
    [self checkArray];
    
    item.categoryId = self.categoryId;
    _items = [_items arrayByAddingObject:item];
}

@end
