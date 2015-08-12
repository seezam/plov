//
//  MenuItemObject.h
//  plov.com
//
//  Created by v.kubyshev on 07/08/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuItemObject : NSObject

@property (nonatomic, strong) NSString * categoryId;
@property (nonatomic, readonly, strong) NSString * itemId;
@property (nonatomic, readonly, strong) NSString * title;
@property (nonatomic, readonly, strong) NSString * desc;
@property (nonatomic, readonly, strong) UIImage * image;
@property (nonatomic, readonly, assign) NSInteger weight;
@property (nonatomic, readonly, assign) NSInteger cost;
@property (nonatomic, assign) NSInteger count;

- (NSString *)titleForLng:(NSString *)lng;
- (void)setTitle:(NSString *)title forLng:(NSString *)lng;

- (NSString *)descForLng:(NSString *)lng;
- (void)setDesc:(NSString *)desc forLng:(NSString *)lng;

- (void)setCost:(NSInteger)cost forWeight:(NSInteger)weight;

- (instancetype)initWithData:(NSData *)data;
- (instancetype)initWithId:(NSString *)itemId;

@end
