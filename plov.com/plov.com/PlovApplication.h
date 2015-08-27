//
//  PlovApplication.h
//  plov.com
//
//  Created by v.kubyshev on 27/08/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kApplicationTimeoutInSec 10
#define kApplicationDidTimeoutNotification @"PlovAppTimeOut"
#define kApplicationDidTimeoutBreaksNotification @"PlovAppTimeOutBreaks"

@interface PlovApplication : UIApplication

@end
