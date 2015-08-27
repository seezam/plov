//
//  PlovApplication.m
//  plov.com
//
//  Created by v.kubyshev on 27/08/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import "PlovApplication.h"

@interface PlovApplication ()
@property (nonatomic, assign) BOOL idleScheduled;
@end

@implementation PlovApplication

-(void)sendEvent:(UIEvent *)event
{
    [super sendEvent:event];
    
    if (!self.idleScheduled)
    {
        [self resetIdleTimer];
    }
    
    NSSet *allTouches = [event allTouches];
    if ([allTouches count] > 0)
    {
        UITouchPhase phase = ((UITouch *)[allTouches anyObject]).phase;
        if (phase == UITouchPhaseBegan)
        {
            [self resetIdleTimer];
        }
        
    }
}

-(void)resetIdleTimer
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(idleTimerExceeded) object:nil];
    
    //convert the wait period into minutes rather than seconds
    [self performSelector:@selector(idleTimerExceeded) withObject:nil afterDelay:kApplicationTimeoutInSec];
        
    [[NSNotificationCenter defaultCenter] postNotificationName:kApplicationDidTimeoutBreaksNotification object:nil];
}

-(void)idleTimerExceeded
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kApplicationDidTimeoutNotification object:nil];
}

@end
