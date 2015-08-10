//
//  MenuItemsView.m
//  plov.com
//
//  Created by v.kubyshev on 11/08/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import "MenuItemsView.h"

@implementation MenuItemsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setContentOffset:(CGPoint)contentOffset
{
    [super setContentOffset:CGPointMake(contentOffset.x, 0)];
}

-(void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated
{
    [super setContentOffset:CGPointMake(contentOffset.x, 0) animated:animated];
}

@end
