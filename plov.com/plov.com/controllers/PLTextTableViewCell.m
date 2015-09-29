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
    
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 375, 30)];
    title.text = name?name:@"";
    [cell.contentView addSubview:title];
    
    UITextField * field = [[UITextField alloc] initWithFrame:CGRectMake(120, 0, 375, 30)];
    field.placeholder = placeholder?placeholder:@"";
    field.autocorrectionType = UITextAutocorrectionTypeNo;
    field.text = text?text:@"";
    [field setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    cell.accessoryView = field;
    
    return cell;
}

@end
