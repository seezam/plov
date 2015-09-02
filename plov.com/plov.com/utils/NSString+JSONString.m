//
//  NSString+JSONString.m
//

#import "NSString+JSONString.h"

@implementation NSString (JSONString)
- (NSDictionary *)dictionaryFromJSON
{
    NSData * data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

- (NSDictionary*)JSONValue
{
    return [self dictionaryFromJSON];
}

- (BOOL)isNumber
{
    if (self.length == 0)
    {
        return NO;
    }
    
    NSNumber * toNum = @([self longLongValue]);
    
    return [toNum.stringValue isEqualToString:self];
}

- (BOOL)isBool
{
    if (self.length == 0)
    {
        return NO;
    }

    return [self isEqualToString:@"false"]||[self isEqualToString:@"true"];
}

- (id)jsonValue
{
    if (self.isNumber)
    {
        return @(self.longLongValue);
    }
    else if (self.isBool)
    {
        return @(self.boolValue);
    }
    else
    {
        return self.trimmed;
    }
}

- (NSString*)trimmed
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end

@implementation NSDictionary (JSONString)
- (NSString *)toJSONString
{
    NSData * json = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    
	return [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
}



@end
