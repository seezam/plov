//
//  PLTextTableViewCell.m
//  plov.com
//
//  Created by v.kubyshev on 29/09/15.
//  Copyright © 2015 plov.com. All rights reserved.
//

#import "PLTextTableViewCell.h"

@interface PLTextTableViewCell ()<UITextFieldDelegate>
@property (nonatomic, weak) UIView * divider;
@property (nonatomic, weak) UITextField * input;
@end

@implementation PLTextTableViewCell

+ (PLTextTableViewCell *)cellWithText:(NSString *)text placeholder:(NSString *)placeholder name:(NSString *)name reuseId:(NSString *)reuseId type:(PLTableItemType)type last:(BOOL)last
{
    PLTextTableViewCell * cell = [[PLTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    
    cell.backgroundColor = UIColorFromRGBA(resColorBackground);
    cell.contentView.backgroundColor = UIColorFromRGBA(resColorBackground);
    
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(18, 9, 120, 30)];
    title.font = [UIFont fontWithName:@"ProximaNova-Light" size:16];
    title.textColor = UIColorFromRGBA(resColorMenuText);
    title.text = name?name:@"";
    title.numberOfLines = 0;
    [cell.contentView addSubview:title];
    
    UITextField * field = [[UITextField alloc] initWithFrame:CGRectMake(140, 10, 150, 30)];
    field.placeholder = placeholder?placeholder:@"";
    field.autocorrectionType = UITextAutocorrectionTypeNo;
    field.text = text?text:@"";
    field.backgroundColor = [UIColor clearColor];
    field.textColor = [UIColor colorWithWhite:1 alpha:0.3];
    field.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [field setClearButtonMode:UITextFieldViewModeWhileEditing];
    field.delegate = cell;
    cell.input = field;
    
    switch (type) {
        case PLTableItemType_Text:
            field.keyboardType = UIKeyboardTypeDefault;
            break;
        case PLTableItemType_Number:
            field.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            break;
        case PLTableItemType_Phone:
            field.keyboardType = UIKeyboardTypePhonePad;
            break;
        case PLTableItemType_Email:
            field.keyboardType = UIKeyboardTypeEmailAddress;
            break;
        case PLTableItemType_ReadOnly:
            field.userInteractionEnabled = NO;
            break;
        case PLTableItemType_ListItem:
            field.userInteractionEnabled = NO;
            field.hidden = YES;
            title.width = CGRectGetMaxX(field.frame) - title.x;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
    }
    
    CGPoint p = title.center;
    CGRect r = title.frame;
    
    [title sizeToFit];
    title.center = p;
    title.x = r.origin.x;
    title.width = r.size.width;
    
    if (last)
    {
        field.returnKeyType = UIReturnKeyDone;
    }
    else
    {
        field.returnKeyType = UIReturnKeyNext;
    }
    
    [cell.contentView addSubview:field];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(9, 47, 320-18, 1)];
    view.backgroundColor = UIColorFromRGBA(resColorDivider);
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    cell.divider = view;
    
    [cell.contentView addSubview:view];
    
    return cell;
}

- (void)setResponder
{
    [self.input becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.delegate cellDidReturn:self];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.delegate cell:self didChanged:textField.text];
}

- (void)hideDivider:(BOOL)hide
{
    [self.divider setHidden:hide];
}

@end
