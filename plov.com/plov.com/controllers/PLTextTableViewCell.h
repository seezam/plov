//
//  PLTextTableViewCell.h
//  plov.com
//
//  Created by v.kubyshev on 29/09/15.
//  Copyright © 2015 plov.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLTableViewController.h"


@class PLTextTableViewCell;

@protocol PLTextTableViewCellDelegate <NSObject>

- (void)cellDidReturn:(PLTextTableViewCell *)cell;
- (void)cell:(PLTextTableViewCell *)cell didChanged:(NSString *)text;
- (void)complexCell:(PLTextTableViewCell *)cell idx:(NSInteger)idx didChanged:(NSString *)text;

@end

@interface PLTextTableViewCell : UITableViewCell

+ (PLTextTableViewCell *)cellWithText:(NSString *)text placeholder:(NSString *)placeholder name:(NSString *)name reuseId:(NSString *)reuseId type:(PLTableItemType)type blocks:(NSArray *)blocks last:(BOOL)last;

- (void)hideDivider:(BOOL)hide;

- (void)setResponder;

@property (nonatomic, weak) id<PLTextTableViewCellDelegate> delegate;

@end
