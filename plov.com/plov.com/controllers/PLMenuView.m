//
//  PLMenuView.m
//  plov.com
//
//  Created by v.kubyshev on 10/08/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import "PLMenuView.h"

#import "MenuObject.h"
#import "MenuCategoryObject.h"

@interface PLMenuView ()

@property (nonatomic, strong) MenuObject * menu;
@property (nonatomic, strong) UIView * selector;

@property (nonatomic, assign) NSInteger lastTag;

@end

@implementation PLMenuView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setupMenu:(MenuObject *)menu
{
    self.menu = menu;
    
    [self relayout];
}

- (void)relayout
{
    while (self.subviews.count) [self.subviews.firstObject removeFromSuperview];
    
    int x = 10;
    int tag = 0;
    
    for (MenuCategoryObject * category in self.menu.categories)
    {
        UILabel * categoryTitle = [[UILabel alloc] init];
        
        categoryTitle.text = category.title;
        categoryTitle.font = [UIFont fontWithName:@"ProximaNova-Reg" size:17];
        categoryTitle.textColor = UIColorFromRGBA(resColorMenuText);
        
        [categoryTitle sizeToFit];
        categoryTitle.center = CGPointMake(0, ceil(self.frame.size.height/2));
        
        categoryTitle.x = x;
        categoryTitle.tag = 200 + tag;
        
        [self addSubview:categoryTitle];
        
        x += categoryTitle.frame.size.width;
        x += 20;
        
        CGRect btnRect = categoryTitle.frame;
        btnRect = CGRectMake(btnRect.origin.x - 10, 0, btnRect.size.width + 20, self.height);
        UIButton * btn = [[UIButton alloc] initWithFrame:btnRect];
        btn.tag = 100 + tag;
        
        [btn addTarget:self action:@selector(menuSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        tag++;
    }
    
    self.contentSize = CGSizeMake(x - 10, self.bounds.size.height);
    
    [self setupSelector];
}

- (void)menuSelected:(UIButton *)sender
{
    [self selectCategoryByTag:sender.tag - 100 withScroll:YES];
}

- (CGRect)selectorRectForTag:(NSInteger)tag
{
    UIView * v = [self viewWithTag:200 + tag];
    
    return CGRectMake(v.x, v.y + v.height, v.width, 2);
}

- (void)setupSelector
{
    if (!_selector)
    {
        self.selector = [[UIView alloc] init];
        self.selector.backgroundColor = UIColorFromRGBA(resColorMenuSelector);
        self.selector.frame = [self selectorRectForTag:0];
        
        [self addSubview:self.selector];
    }
}

- (MenuCategoryObject *)currentCategory
{
    return self.menu.categories[self.lastTag];
}

- (void)selectCategoryByTag:(NSInteger)tag withScroll:(BOOL)scroll
{
    [self setupSelector];
    
    self.lastTag = tag;
    
    if (scroll)
    {
        [self.plDelegate selectingCategory:self.menu.categories[tag]];
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect rect = [self selectorRectForTag:tag];
            
            [self scrollRectToVisible:CGRectInset(rect, -40, 0) animated:NO];
            self.selector.frame = rect;
        }];
    }
}

- (void)selectCategory:(NSString *)categoryId
{
    int i = 0;
    for (MenuCategoryObject * category in self.menu.categories)
    {
        if ([categoryId isEqualToString:category.categoryId])
        {
            [self selectCategoryByTag:i withScroll:NO];
            return;
        }
        i++;
    }
}

@end
