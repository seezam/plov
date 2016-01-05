//
//  OrderObject.h
//  plov.com
//
//  Created by v.kubyshev on 07/09/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OrderItemObject;

typedef enum : NSUInteger {
    OrderStatus_Created,
    OrderStatus_Preparing,
    OrderStatus_Delivering,
    OrderStatus_Completed,
    OrderStatus_Cancelled,
} OrderStatus;

@interface OrderObject : NSObject

@property (nonatomic, strong, readonly) NSString * orderId;

@property (nonatomic, strong, readonly) NSDate * date;
@property (nonatomic, strong, readonly) NSString * address;

@property (nonatomic, assign, readonly) NSInteger cost;
@property (nonatomic, strong, readonly) NSArray * list;

@property (nonatomic, assign, readonly) OrderStatus status;

@property (nonatomic, strong, readonly) NSString * statusString;

+ (NSArray *)ordersWithData:(NSArray *)data;

- (OrderObject *)initWithMenuItems:(NSArray *)items orderId:(NSString *)orderId address:(NSString *)address;
- (OrderObject *)initWithOrderCopy:(OrderObject *)order;

- (NSDictionary *)orderToJson;

- (BOOL)decCountForItem:(OrderItemObject *)item;
- (BOOL)incCountForItem:(OrderItemObject *)item;

- (void)appendItem:(OrderItemObject *)item;
- (void)removeItem:(OrderItemObject *)item;

- (void)updateOrderWithId:(NSString *)orderId address:(NSString *)address;
- (void)updateOrderStatus:(NSString *)status;

@end
