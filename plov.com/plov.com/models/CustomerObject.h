//
//  CustomerObject.h
//  plov.com
//
//  Created by v.kubyshev on 07/09/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OrderObject;
@class AddressObject;

@interface CustomerObject : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * mail;

@property (nonatomic, strong) NSArray * orders;
@property (nonatomic, strong) NSArray * addresses;

- (void)saveData;

- (OrderObject *)orderWithId:(NSString *)orderId;

- (void)deleteAddress:(AddressObject *)address;

- (void)setLastAddress:(AddressObject *)address;
- (void)setLastOrder:(OrderObject *)order;

@end
