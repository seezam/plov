//
//  ProfileTableViewCell.h
//  plov.com
//
//  Created by v.kubyshev on 07/09/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *mailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *editImage;
@end
