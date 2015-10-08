//
//  UIImage+Resize.m
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

- (UIImage *)resizeImageTo:(CGSize)size
{
    if (self.size.width == size.width &&
        self.size.height == size.height)
    {
        return self;
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (BOOL)isFlipped
{
    return NO;
}

@end
