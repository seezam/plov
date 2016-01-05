//
//  MenuObject.m
//  plov.com
//
//  Created by v.kubyshev on 07/08/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import "MenuObject.h"
#import "MenuCategoryObject.h"
#import "MenuItemObject.h"

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
    NSDictionary * menu = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    
    if (menu)
    {
//        NSArray * categories = menu[@"categories"];
    }
    return @[];
}

- (void)checkArray
{
    if (!_categories)
    {
        _categories = [NSArray array];
    }
}

- (void)addMenuCategory:(MenuCategoryObject *)category
{
    [self checkArray];
    
    _categories = [_categories arrayByAddingObject:category];
}

- (MenuCategoryObject *)categoryById:(NSString *)categoryId
{
    for (MenuCategoryObject * obj in self.categories)
    {
        if ([obj.categoryId isEqualToString:categoryId])
        {
            return obj;
        }
    }
    
    return nil;
}

- (MenuItemObject *)itemById:(NSString *)itemId
{    
    for (MenuCategoryObject * obj in self.categories)
    {
        for (MenuItemObject * item in obj.items)
        {
            if ([item.itemId isEqualToString:itemId])
            {
                return item;
            }
        }
    }
    
    return nil;
}

@end
