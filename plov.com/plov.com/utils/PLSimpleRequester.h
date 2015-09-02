//
//  SimpleRequester.h
//

#import <Foundation/Foundation.h>

@interface SimpleRequester : NSObject
+ (SimpleRequester*)simpleRequesterWithURL:(NSURL*)url
                                   params:(NSDictionary*)params
                        method:(NSString*)method
                      response:(void (^)(NSURLResponse *response))response
                       success:(void (^)(NSData *data))success
                         error:(void (^)(NSError *error))error;

//- (void)start;
//- (void)cancel;
@end
