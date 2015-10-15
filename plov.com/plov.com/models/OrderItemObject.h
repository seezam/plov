//
//  OrderItemObject.h
//  plov.com
//
//  Created by v.kubyshev on 16/10/15.
//  Copyright © 2015 plov.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MenuItemObject;

@interface OrderItemObject : NSObject

@property (nonatomic, strong, readonly) NSString * itemId;

@property (nonatomic, strong, readonly) NSString * name;

@property (nonatomic, assign, readonly) NSInteger cost;
@property (nonatomic, assign, readonly) NSInteger count;

- (instancetype)initWithData:(NSDictionary *)data;
- (OrderItemObject *)initWithMenuItem:(MenuItemObject *)item;

- (NSDictionary *)orderItemToJson;

@end
