//
//  PLResourseManager.m
//  plov.com
//
//  Created by v.kubyshev on 03/08/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import "PLResourseManager.h"

//NSUInteger resColorNavigation = 0x8d724dff;
NSUInteger resColorNavigation = 0xff0000ff;
//NSUInteger resColorNavigation = 0xffffff00;

NSString * resImageMenu = @"menu.png";

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
        name = [resName substringFromIndex:[resName rangeOfString:ext].location];
    }
    
    name = [NSString stringWithFormat:@"%@%@.%@", name, [self platformSuffix], ext];
    
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
