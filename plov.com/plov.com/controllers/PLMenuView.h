//
//  PLMenuView.h
//  plov.com
//
//  Created by v.kubyshev on 10/08/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuObject;

@interface PLMenuView : UIScrollView

- (void)setupMenu:(MenuObject *)menu;

- (void)selectCategory:(NSString *)categoryId;
- (void)selectCategoryByTag:(NSInteger)tag;

@end
