//
//  ProfileTableViewCell.m
//  plov.com
//
//  Created by v.kubyshev on 07/09/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import "ProfileTableViewCell.h"

@implementation ProfileTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.nameLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:15];
    self.phoneLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:17];
    self.mailLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:13];
    
    self.nameLabel.textColor =
    self.phoneLabel.textColor =
    self.mailLabel.textColor = UIColorFromRGBA(resColorMenuText);
}

@end
