//
//  OrderTableViewCell.m
//  plov.com
//
//  Created by v.kubyshev on 24/08/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import "OrderTableViewCell.h"
#import "BBCyclingLabel.h"

@interface OrderTableViewCell ()

@property (assign, nonatomic) BOOL awaked;
@property (strong, nonatomic) UISwipeGestureRecognizer * swipe;

@property (assign, nonatomic) NSInteger count;
@property (assign, nonatomic) NSInteger sum;

@end

@implementation OrderTableViewCell

- (void)awakeFromNib
{
    if (!self.awaked)
    {
        [super awakeFromNib];
        
        self.swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDone:)];
        [self addGestureRecognizer:self.swipe];
        
        self.countLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        self.countLabel.textColor = UIColorFromRGBA(resColorMenuText);
        self.countLabel.textAlignment = NSTextAlignmentCenter;
        self.countLabel.clipsToBounds = YES;
        
        self.titleLabel.textColor = UIColorFromRGBA(resColorMenuText);
        
        self.suLabel.textColor = UIColorFromRGBA(resColorMenuText);
        self.suLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        
        self.suView.layer.borderWidth = 1;
        self.suView.layer.borderColor = UIColorFromRGBA(resColorMenuText).CGColor;
        self.suView.layer.cornerRadius = 5;
    }
}

- (void)dealloc
{
    [self removeGestureRecognizer:self.swipe];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [UIView animateWithDuration:0.2 animations:^{
        if (selected)
        {
            self.acessoryView.x = self.width - self.acessoryView.width;
            self.suView.alpha = 0;
        }
        else
        {
            self.acessoryView.x = self.width;
            self.suView.alpha = 1;
        }
    } completion:^(BOOL finished) {
        if (!selected)
        {
            [self.delegate orderCellDidDeselect:self];
        }
    }];
}

- (void)swipeDone:(UISwipeGestureRecognizer *)gesture
{
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        [self setSelected:YES animated:YES];
    }
    else if (gesture.direction == UISwipeGestureRecognizerDirectionRight)
    {
        [self setSelected:NO animated:YES];
    }
}

- (IBAction)countChanged:(id)sender
{
    NSInteger count;
    if (sender == self.minusButton)
    {
        self.countLabel.transitionEffect = BBCyclingLabelTransitionEffectScrollDown;
        
        count = [self.delegate orderCell:self countDidIncremented:NO];
    }
    else
    {
        self.countLabel.transitionEffect = BBCyclingLabelTransitionEffectScrollUp;
        
        count = [self.delegate orderCell:self countDidIncremented:YES];
    }
    
    
    self.count = count;
    [self.countLabel setText:@(count).stringValue animated:YES];
    [self updateCountView];
}

- (void)setCount:(NSInteger)count withSum:(NSInteger)sum
{
    self.count = count;
    self.sum = sum;
    
    [self updateCountView];
}

- (void)updateCountView
{
    NSAttributedString * str = [SHARED_APP rubleCost:self.sum font:self.suLabel.font];
    
    NSMutableAttributedString * countString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ x ", @(self.count).stringValue]
                                                                      attributes:@{NSFontAttributeName: self.suLabel.font}];
    
    [countString appendAttributedString:str];
    self.suLabel.attributedText = countString;
    
    [self.suLabel sizeToFit];
    self.suView.frame = CGRectMake(self.suView.x, self.suView.y, self.suLabel.width + 10, self.suLabel.height + 10);
    
    self.suLabel.center = CGPointMake(ceil(self.suView.width/2), ceil(self.suView.height/2));
    
    self.suView.x = self.width - self.suView.width - 13;
    self.suView.y = ceil((self.height - self.suView.height)/2);
}

@end
