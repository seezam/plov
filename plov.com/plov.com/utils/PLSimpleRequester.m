//
//  SimpleRequester.m
//

#import "PLSimpleRequester.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager.h"

@interface SimpleRequester()
@property (retain, nonatomic) NSURLConnection * connection;
@property (retain, nonatomic) NSMutableData * data;
@property (copy) void (^response)(NSURLResponse *response);
@property (copy) void (^success)(NSData *data);
@property (copy) void (^error)(NSError *error);
@end

@implementation SimpleRequester

+ (SimpleRequester*)simpleRequesterWithURL:(NSURL*)url
                                    params:(NSDictionary*)params
                                    method:(NSString*)method
                                  response:(void (^)(NSURLResponse *response))response
                                   success:(void (^)(NSData *data))successBLock
                                     error:(void (^)(NSError *error))errorBlock
{
    return nil;
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager POST:url.absoluteString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if (successBLock)
//        {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                successBLock(responseObject);
//            });
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if (errorBlock)
//        {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                errorBlock(error);
//            });
//        }
//    }];

//    NSMutableURLRequest * req = [NSMutableURLRequest requestWithURL:url];
//    
//    if (!method)
//    {
//        method = @"GET";
//    }
//    
//    [req setHTTPMethod:method];
//    
//    if (headers.count)
//    {
//        NSMutableDictionary *newHeaders = [NSMutableDictionary dictionaryWithDictionary:req.allHTTPHeaderFields];
//        [newHeaders addEntriesFromDictionary:headers];
//        [req setAllHTTPHeaderFields:newHeaders];
//    }
//
//    
//    AFHTTPRequestOperation * reqOperation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
//    reqOperation set
//    
//    SimpleRequester * requester = [[SimpleRequester alloc] init];
//    
//    
//    
//    requester.response = response;
//    requester.success = success;
//    requester.error = error;
//    
//    requester.data = [NSMutableData data];
//    
//    requester.connection = [[NSURLConnection alloc] initWithRequest:req delegate:requester];
//    
//    [requester retain];
//    
//    return requester;
}

//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
//    [self.data appendData:data];
//}
//
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//    if (self.success)
//    {
//        self.success(self.data);
//    }
//    
//    [self release];
//}
//
//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
//{
//    if (self.error)
//    {
//        self.error(error);
//    }
//    
//    [self release];
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//{
//    if (self.response)
//    {
//        self.response(response);
//    }
//}
//
//-(void)dealloc
//{
//    [self.connection cancel];
//    _connection = nil;
//    
//    self.data = nil;
//    self.response = nil;
//    self.success = nil;
//    self.error = nil;
//    
//    [super dealloc];
//}
//
//- (void)start
//{
//    [self.connection start];
//}
//
//- (void)cancel
//{
//    [self.connection cancel];
//    _connection = nil;
//    
//    [self release];
//}

@end
