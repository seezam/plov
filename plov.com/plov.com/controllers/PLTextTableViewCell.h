//
//  PLTextTableViewCell.h
//  plov.com
//
//  Created by v.kubyshev on 29/09/15.
//  Copyright © 2015 plov.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLTextTableViewCell : UITableViewCell

+ (PLTextTableViewCell *)cellWithText:(NSString *)text placeholder:(NSString *)placeholder name:(NSString *)name reuseId:(NSString *)reuseId;

@end
