//
//  MenuItemObject.m
//  plov.com
//
//  Created by v.kubyshev on 07/08/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import "MenuItemObject.h"
#import "UIImage+Resize.h"

@interface MenuItemObject ()
@property (nonatomic, strong) NSMutableDictionary * titles;
@property (nonatomic, strong) NSMutableDictionary * descs;
@end

@implementation MenuItemObject

- (NSString *)title
{
    return [self titleForLng:[PLResourseManager currentLng]];
}

- (NSString *)titleForLng:(NSString *)lng
{
    return self.titles[lng];
}

- (void)setTitle:(NSString *)title forLng:(NSString *)lng
{
    self.titles[lng] = title;
}

- (NSString *)desc
{
    return [self descForLng:[PLResourseManager currentLng]];
}

- (NSString *)descForLng:(NSString *)lng
{
    return self.descs[lng];
}

- (void)setDesc:(NSString *)desc forLng:(NSString *)lng
{
    self.descs[lng] = desc;
}

- (void)setCost:(NSInteger)cost forWeight:(NSInteger)weight
{
    _cost = cost;
    _weight = weight;
    _litres = NO;
}

- (void)setCost:(NSInteger)cost forMlitres:(NSInteger)litres
{
    _cost = cost;
    _weight = litres;
    _litres = YES;
}

- (void)setImageId:(NSInteger)imageId
{
    _imageId = imageId;
}

- (UIImage *)image
{
    NSString * imgName = [NSString stringWithFormat:@"item%03ld",
                          (_imageId == -1)?
                          (long)self.itemId.integerValue:
                          (long)self.imageId];
    return [[UIImage imageNamed:imgName] resizeImageTo:CGSizeMake(320, 568)];
}

- (instancetype)initWithData:(NSData *)data
{
    if (self = [super init])
    {
        _titles = [NSMutableDictionary dictionary];
        _descs = [NSMutableDictionary dictionary];
        
        _imageId = -1;
    }
    
    return self;
}

- (instancetype)initWithId:(NSString *)itemId
{
    if (self = [super init])
    {
        _itemId = itemId;
        _titles = [NSMutableDictionary dictionary];
        _descs = [NSMutableDictionary dictionary];
        
        _imageId = -1;
    }
    
    return self;
}

@end
