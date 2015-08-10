//
//  PLResourseManager.h
//  plov.com
//
//  Created by v.kubyshev on 03/08/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSUInteger resColorMenuText;
extern NSUInteger resColorMenuSelector;
extern NSUInteger resColorNavigation;


extern NSString * resImageMenu;
extern NSString * resImageLogo;

#define UIColorFromRGBA(rgbaValue) [UIColor \
    colorWithRed:((float)((rgbaValue & 0xFF000000) >> 24))/255.0 \
    green:((float)((rgbaValue & 0xFF0000) >> 16))/255.0 \
    blue:((float)((rgbaValue & 0xFF00) >> 8))/255.0 \
    alpha:((float)((rgbaValue & 0xFF)))/255.0]

@interface PLResourseManager : NSObject

+ (UIImage *)imageWithName:(NSString *)resName;

@end
