//
//  NSString+JSONString.h
//

#import <Foundation/Foundation.h>

@interface NSString (JSONString)
- (NSDictionary *)dictionaryFromJSON;

- (BOOL)isNumber;
- (BOOL)isBool;
- (id)jsonValue;

- (NSString*)trimmed;
@end

@interface NSDictionary (JSONString)
- (NSString *)toJSONString;
@end