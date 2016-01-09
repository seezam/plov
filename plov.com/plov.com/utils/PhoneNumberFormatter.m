#import "PhoneNumberFormatter.h"

@interface PhoneNumberFormatter ()
@property (nonatomic, strong) NSDictionary * predefinedFormats;
@end


@implementation PhoneNumberFormatter

- (id)init {
    self.predefinedFormats = @{@"ru": @"+7 (###) ###-##-##"};
    
    return self;
    
}

- (NSString *)format:(NSString *)phoneNumber withLocale:(NSString *)locale {
    
    NSString *localeFormat = [self.predefinedFormats objectForKey:locale];
    
    if(localeFormat == nil) return phoneNumber;
    
    NSString *input = [PhoneNumberFormatter strip:phoneNumber];

    NSMutableString * result = [NSMutableString string];
    
    int j = 0;
    
    for (int i = 0; i < localeFormat.length; i++)
    {
        if (j >= input.length)
        {
            break;
        }
        
        NSString * cf = [localeFormat substringWithRange:NSMakeRange(i, 1)];
        NSString * ci = [input substringWithRange:NSMakeRange(j, 1)];
        
        if (![cf isEqualToString:@"#"])
        {
            [result appendString:cf];
            
            if ([cf isEqualToString:ci])
            {
                j++;
            }
        }
        else
        {
            [result appendString:ci];
            j++;
        }
    }
    
    return result;
    
}

+ (NSString *)strip:(NSString *)phoneNumber {
    
    NSMutableString *res = [[NSMutableString alloc] init];
    
    for(int i = 0; i < [phoneNumber length]; i++) {
        
        char next = [phoneNumber characterAtIndex:i];
        
        if([self canBeInputByPhonePad:next])
            
            [res appendFormat:@"%c", next];
        
    }
    
    return res;
    
}

+ (BOOL)canBeInputByPhonePad:(char)c {
    
    if(c == '+' || c == '*' || c == '#') return YES;
    
    if(c >= '0' && c <= '9') return YES;
    
    return NO;
    
}



- (void)dealloc {
    
}



@end