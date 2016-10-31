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

//NSString * crmKey = @"ULUtDZ9mWVu1K9uKJr3UjdSxZ9ufU37d";
//NSString * crmCode = @"plov-com";
//NSString * crmUrl = @"https://plov1.retailcrm.ru";
//
//NSString * crmMethodOrders = @"/api/v3/orders/";
//NSString * crmMethodOrdersCreate = @"create";

const NSString * kRequestSerializer = @"requestSerializer";
const NSString * kResponseSerializer = @"responseSerializer";

const NSString * crmUser = @"plovnomer1";
const NSString * crmPass = @"nbygfasl564";
const NSString * crmUrl = @"https://iiko.biz:9900/api/0/";

const NSString * crmMethodAccessToken = @"auth/access_token";
const NSString * crmMethodOrganization = @"organization/list";
const NSString * crmMethodMenu = @"nomenclature/";
const NSString * crmMethodOrderCreate = @"orders/add";
const NSString * crmMethodOrderInfo = @"orders/info";

static NSString * accessToken = @"";
static NSString * organizationId = @"";

@implementation PLCRMSupport

- (void)createOrder:(NSDictionary *)order
            success:(void (^)(NSDictionary *data))successBlock
              error:(void (^)(NSError *error))errorBlock
{
//    NSString * method = [NSString stringWithFormat:@"%@%@", crmMethodOrders, crmMethodOrdersCreate];
//    
//    NSDictionary * orderData = @{@"order": order.toJSONString};
//    
//    [self postCRMMethod:method params:orderData success:successBlock error:errorBlock];
}

- (void)getOrderInfo:(NSString *)orderId
            success:(void (^)(NSDictionary *data))successBlock
              error:(void (^)(NSError *error))errorBlock
{
//    NSString * method = [NSString stringWithFormat:@"%@%@", crmMethodOrders, orderId];
//    
//    NSDictionary * orderData = @{@"by": @"id", @"externalId": orderId};
//    
//    [self getCRMMethod:method params:orderData success:successBlock error:errorBlock];
}

- (void)getTokenSuccess:(void (^)(NSData *))successBlock error:(void (^)(NSError *))errorBlock {
    [self getCRMMethod:crmMethodAccessToken
                params:@{
                         @"user_id": crmUser,
                         @"user_secret": crmPass,
                         kResponseSerializer: [AFHTTPResponseSerializer serializer],
                        }
               success:successBlock error:errorBlock];
}

- (void)getOrganizationSuccess:(void (^)(NSArray *data))successBlock
                  error:(void (^)(NSError *error))errorBlock {
    
    [self getTokenSuccess:^(NSData *data) {
        NSString * token = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        token = [token stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
        
        accessToken = token;
        
        [self getCRMMethod:crmMethodOrganization
                    params:@{
                             @"access_token":accessToken,
                             }
                   success:^(NSArray * data) {
                       if (data.count) {
                           organizationId = data.firstObject[@"id"];
                           
                           if (organizationId.length == 0) {
                               NSError * err = [NSError errorWithDomain:NSURLErrorDomain code:1000 userInfo:NULL];
                               
                               errorBlock(err);
                           } else {
                               successBlock(data);
                           }
                       }
                   } error:errorBlock];
    } error:errorBlock];
}

- (void)getMenuSuccess:(void (^)(NSDictionary *data))successBlock
          error:(void (^)(NSError *error))errorBlock {
    [self getOrganizationSuccess:^(NSArray *data) {
        NSString * method = [crmMethodMenu stringByAppendingString:organizationId];
        
        [self getCRMMethod:method
                    params:@{
                             @"access_token": accessToken,
                             //@"revision": @(0),
                             }
                   success:^(NSDictionary * data) {
                       if (data.count) {
                           
                       }
                   } error:errorBlock];
    } error:errorBlock];
}


- (void)postCRMMethod:(const NSString*)method params:(NSDictionary *)params
              success:(void (^)(id))successBlock
                error:(void (^)(NSError *error))errorBlock
{
    NSMutableDictionary * dict = [params mutableCopy];
//    dict[@"site"] = crmCode;
//    dict[@"apiKey"] = crmKey;
//    
    params = [dict copy];
    
    NSString * url = [NSString stringWithFormat:@"%@%@", crmUrl, method];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    if (params[kResponseSerializer]) {
        manager.responseSerializer = params[kResponseSerializer];
    } else {
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
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

- (void)getCRMMethod:(const NSString*)method params:(NSDictionary *)params
              success:(void (^)(id))successBLock
                error:(void (^)(NSError *error))errorBlock
{
    NSMutableDictionary * dict = [params mutableCopy];
//    dict[@"site"] = crmCode;
//    dict[@"apiKey"] = crmKey;
    
    params = [dict copy];
    
    NSString * url = [NSString stringWithFormat:@"%@%@", crmUrl, method];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    if (params[kResponseSerializer]) {
        manager.responseSerializer = params[kResponseSerializer];
    } else {
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
//    manager.responseSerializer.acceptableContentTypes = @"text";
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
