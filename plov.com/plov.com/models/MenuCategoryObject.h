//
//  MenuCategoryObject.h
//  plov.com
//
//  Created by v.kubyshev on 07/08/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuCategoryObject : NSObject

@property (nonatomic, readonly, strong) NSString * categoryId;
@property (nonatomic, readonly, strong) NSString * title;
@property (nonatomic, readonly, strong) NSArray * items;

- (NSString *)titleForLng:(NSString *)lng;

- (instancetype)initWithData:(NSData *)data;

@end
