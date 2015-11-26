//
//  MenuObject.h
//  plov.com
//
//  Created by v.kubyshev on 07/08/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MenuCategoryObject;

@interface MenuObject : NSObject

@property (nonatomic, assign) NSUInteger minimalCost;
@property (nonatomic, readonly, strong) NSArray * categories;

- (instancetype)initWithData:(NSData *)data;

- (void)addMenuCategory:(MenuCategoryObject *)category;
- (MenuCategoryObject *)categoryById:(NSString *)categoryId;

@end
