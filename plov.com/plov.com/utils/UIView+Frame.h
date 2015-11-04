
#import <Foundation/Foundation.h>

@interface UIView (FrameUtils)

- (CGFloat)width;
- (CGFloat)height;
- (CGFloat)x;
- (CGFloat)y;
- (CGFloat)right;
- (CGFloat)bottom;

- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;

- (void)setRight:(CGFloat)right;
- (void)setBottom:(CGFloat)bottom;

@end