//
//  PLResourseManager.m
//  plov.com
//
//  Created by v.kubyshev on 03/08/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import "PLResourseManager.h"

NSUInteger resColorBackground = 0x8d724dff;
NSUInteger resColorNavigation = 0xff0000ff;
NSUInteger resColorMenuText = 0xf7d8a3ff;
NSUInteger resColorMenuSelector = 0xbd724dff;

//NSUInteger resColorNavigation = 0xffffff00;

NSString * resImageMenu = @"menu.png";
NSString * resImageLogo = @"logo.png";

@implementation PLResourseManager

+ (NSString *)platformSuffix
{
    if (IS_IPHONE_5 || IS_IPHONE_4_OR_LESS)
    {
        return @"_5";
    }
    
    if (IS_IPHONE_6 || IS_IPHONE_6P)
    {
        return @"_6";
    }
    
    return @"";
}

+ (NSString *)resWithName:(NSString *)resName
{
    NSString * ext = [resName pathExtension];
    
    NSString * name = resName;
    
    if (ext.length > 0)
    {
        name = [resName substringToIndex:[resName rangeOfString:ext].location - 1];
    }
    
    NSString * dbl = @"";
//    NSString * dbl = @"@@2x";
//    NSRange range = [name rangeOfString:dbl];
//    if (range.location != NSNotFound)
//    {
//        name = [name substringToIndex:range.location];
//    }
//    else
//    {
//        dbl = @"";
//    }
    
    name = [NSString stringWithFormat:@"%@%@%@.%@", name, [self platformSuffix], dbl, ext];
    
    return name;
}

+ (UIImage *)imageWithName:(NSString *)resName
{
    UIImage * image = [UIImage imageNamed:[self resWithName:resName]];
    
    if (!image)
    {
        image = [UIImage imageNamed:resName];
    }
    
    return image;
}



@end
