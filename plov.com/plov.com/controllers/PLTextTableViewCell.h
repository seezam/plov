//
//  PLTextTableViewCell.h
//  plov.com
//
//  Created by v.kubyshev on 29/09/15.
//  Copyright © 2015 plov.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PLTextTableViewCell;

@protocol PLTextTableViewCellDelegate <NSObject>

- (void)cell:(PLTextTableViewCell *)cell didChanged:(NSString *)text;

@end

@interface PLTextTableViewCell : UITableViewCell

+ (PLTextTableViewCell *)cellWithText:(NSString *)text placeholder:(NSString *)placeholder name:(NSString *)name reuseId:(NSString *)reuseId;

- (void)hideDivider:(BOOL)hide;

@property (nonatomic, weak) id<PLTextTableViewCellDelegate> delegate;

@end
