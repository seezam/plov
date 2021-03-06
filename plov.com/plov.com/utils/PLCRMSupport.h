//
//  PLCRMSupport.h
//  plov.com
//
//  Created by v.kubyshev on 02/09/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import <Foundation/Foundation.h>

//extern NSString * crmKey;

@interface PLCRMSupport : NSObject

- (void)createOrder:(NSDictionary *)orderData
            success:(void (^)(NSDictionary *data))successBlock
              error:(void (^)(NSError *error))errorBlock;

- (void)getOrderInfo:(NSString *)orderId
             success:(void (^)(NSDictionary *data))successBlock
               error:(void (^)(NSError *error))errorBlock;


- (void)getTokenSuccess:(void (^)(NSData *data))successBlock
                  error:(void (^)(NSError *error))errorBlock;

- (void)getOrganizationSuccess:(void (^)(NSArray *data))successBlock
                  error:(void (^)(NSError *error))errorBlock;

- (void)getMenuSuccess:(void (^)(NSDictionary *data))successBlock
          error:(void (^)(NSError *error))errorBlock;


@end
