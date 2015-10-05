//
//  PLTextTableViewCell.m
//  plov.com
//
//  Created by v.kubyshev on 29/09/15.
//  Copyright © 2015 plov.com. All rights reserved.
//

#import "PLTextTableViewCell.h"

@implementation PLTextTableViewCell

+ (PLTextTableViewCell *)cellWithText:(NSString *)text placeholder:(NSString *)placeholder name:(NSString *)name reuseId:(NSString *)reuseId
{
    PLTextTableViewCell * cell = [[PLTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    
    cell.contentView.backgroundColor = UIColorFromRGBA(resColorBackground);
    
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(9, 5, 200, 30)];
    title.font = [UIFont fontWithName:@"ProximaNova-Light" size:16];
    title.textColor = UIColorFromRGBA(resColorMenuText);
    title.text = name?name:@"";
    [cell.contentView addSubview:title];
    
    UITextField * field = [[UITextField alloc] initWithFrame:CGRectMake(170, 5, 150, 30)];
    field.placeholder = placeholder?placeholder:@"";
    field.autocorrectionType = UITextAutocorrectionTypeNo;
    field.text = text?text:@"";
    field.backgroundColor = [UIColor clearColor];
    [field setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    [cell.contentView addSubview:field];
    
    return cell;
}

@end
