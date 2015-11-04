
#import "UIView+Frame.h"

@implementation UIView (FrameUtils)

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (CGFloat)right
{
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)bottom
{
    return CGRectGetMaxY(self.frame);
}

- (void)setWidth:(CGFloat)width
{
    self.frame = CGRectMake(self.x, self.y, width, self.height);
}

- (void)setHeight:(CGFloat)height {
    self.frame = CGRectMake(self.x, self.y, self.width, height);
}

- (void)setX:(CGFloat)x {
    self.frame = CGRectMake(x, self.y, self.width, self.height);
}

- (void)setY:(CGFloat)y {
    self.frame = CGRectMake(self.x, y, self.width, self.height);
}

- (void)setRight:(CGFloat)right
{
    self.frame = CGRectMake(self.x, self.y, right - self.x, self.height);
}

- (void)setBottom:(CGFloat)bottom
{
    self.frame = CGRectMake(self.x, self.y, self.width, bottom - self.y);
}

@end