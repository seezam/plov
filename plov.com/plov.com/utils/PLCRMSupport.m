//
//  PLCRMSupport.m
//  plov.com
//
//  Created by v.kubyshev on 02/09/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import "PLCRMSupport.h"
#import "PLSimpleRequester.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager.h"
#import "NSString+JSONString.h"

//NSString * crmKey = @"79rFnffNDYVR3kfUUPU37sGQzQmlQWLO";
//NSString * crmCode = @"kubyshev-ru";
//NSString * crmUrl = @"https://kubyshev.retailcrm.ru";

NSString * crmKey = @"ULUtDZ9mWVu1K9uKJr3UjdSxZ9ufU37d";
NSString * crmCode = @"plov-com";
NSString * crmUrl = @"https://plov1.retailcrm.ru";

NSString * crmMethodOrders = @"/api/v3/orders/";
NSString * crmMethodOrdersCreate = @"create";

@implementation PLCRMSupport

- (void)createOrder:(NSDictionary *)order
            success:(void (^)(NSDictionary *data))successBlock
              error:(void (^)(NSError *error))errorBlock
{
    NSString * method = [NSString stringWithFormat:@"%@%@", crmMethodOrders, crmMethodOrdersCreate];
    
    NSDictionary * orderData = @{@"order": order.toJSONString};
    
    [self postCRMMethod:method params:orderData success:successBlock error:errorBlock];
}

- (void)getOrderInfo:(NSString *)orderId
            success:(void (^)(NSDictionary *data))successBlock
              error:(void (^)(NSError *error))errorBlock
{
    NSString * method = [NSString stringWithFormat:@"%@%@", crmMethodOrders, orderId];
    
    NSDictionary * orderData = @{@"by": @"id", @"externalId": orderId};
    
    [self getCRMMethod:method params:orderData success:successBlock error:errorBlock];
}

- (void)postCRMMethod:(NSString*)method params:(NSDictionary *)params
              success:(void (^)(NSDictionary *data))successBlock
                error:(void (^)(NSError *error))errorBlock
{
    NSMutableDictionary * dict = [params mutableCopy];
    dict[@"site"] = crmCode;
    dict[@"apiKey"] = crmKey;
    
    params = [dict copy];
    
    NSString * url = [NSString stringWithFormat:@"%@%@", crmUrl, method];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (successBlock)
        {
            successBlock(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (errorBlock)
        {
            errorBlock(error);
        }
    }];
}

- (void)getCRMMethod:(NSString*)method params:(NSDictionary *)params
              success:(void (^)(NSDictionary *data))successBLock
                error:(void (^)(NSError *error))errorBlock
{
    NSMutableDictionary * dict = [params mutableCopy];
    dict[@"site"] = crmCode;
    dict[@"apiKey"] = crmKey;
    
    params = [dict copy];
    
    NSString * url = [NSString stringWithFormat:@"%@%@", crmUrl, method];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (successBLock)
        {
            successBLock(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (errorBlock)
        {
            errorBlock(error);
        }
    }];
}

@end
