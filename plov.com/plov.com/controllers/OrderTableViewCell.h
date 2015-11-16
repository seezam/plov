//
//  OrderTableViewCell.h
//  plov.com
//
//  Created by v.kubyshev on 24/08/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBCyclingLabel;
@class OrderTableViewCell;

@protocol OrderTableViewDelegate <NSObject>

- (NSInteger)orderCell:(OrderTableViewCell *)cell countDidIncremented:(BOOL)incremented;
- (void)orderCellDidDeselect:(OrderTableViewCell *)cell;
- (void)orderCellWillSelect:(OrderTableViewCell *)cell;

@end

@interface OrderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *acessoryView;
@property (weak, nonatomic) IBOutlet UIView *suView;
@property (weak, nonatomic) IBOutlet UILabel *suLabel;
@property (weak, nonatomic) IBOutlet BBCyclingLabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;

@property (assign, nonatomic) BOOL readOnly;

@property (weak, nonatomic) id<OrderTableViewDelegate> delegate;

- (IBAction)countChanged:(id)sender;

- (void)setCount:(NSInteger)count withSum:(NSInteger)sum;
@end
