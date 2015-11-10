//
//  OrderObject.h
//  plov.com
//
//  Created by v.kubyshev on 07/09/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    OrderStatus_Created,
    OrderStatus_Sent,
    OrderStatus_Completed,
} OrderStatus;

@interface OrderObject : NSObject

@property (nonatomic, strong, readonly) NSString * orderId;

@property (nonatomic, strong, readonly) NSDate * date;
@property (nonatomic, strong, readonly) NSString * address;

@property (nonatomic, assign, readonly) NSInteger cost;
@property (nonatomic, strong, readonly) NSArray * list;

@property (nonatomic, assign, readonly) OrderStatus status;

+ (NSArray *)ordersWithData:(NSArray *)data;

- (OrderObject *)initWithMenuItems:(NSArray *)items orderId:(NSString *)orderId address:(NSString *)address cost:(NSInteger)cost;

- (NSDictionary *)orderToJson;

@end
