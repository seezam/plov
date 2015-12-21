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
@property (nonatomic, strong) NSMutableArray * inputs;

@property (nonatomic, assign) PLTableItemType type;
@end

#define FIELD_AVAILABLE_WIDTH ([[UIScreen mainScreen] bounds].size.width - 18)
#define FIELD_WIDTH 180
#define BLOCK_GAP 10
#define FIELD_LEFT_MARGIN 140

@implementation PLTextTableViewCell

+ (PLTextTableViewCell *)cellWithText:(NSString *)text placeholder:(NSString *)placeholder name:(NSString *)name reuseId:(NSString *)reuseId type:(PLTableItemType)type blocks:(NSArray *)blocks last:(BOOL)last
{
    PLTextTableViewCell * cell = [[PLTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    
    cell.inputs = [NSMutableArray array];
    cell.type = type;
    
    cell.backgroundColor = UIColorFromRGBA(resColorBackground);
    cell.contentView.backgroundColor = UIColorFromRGBA(resColorBackground);
    
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(18, 9, 120, 30)];
    title.font = [UIFont fontWithName:@"ProximaNova-Light" size:16];
    title.textColor = UIColorFromRGBA(resColorMenuText);
    title.text = name?name:@"";
    title.numberOfLines = 0;
    [cell.contentView addSubview:title];
    
    if (type == PLTableItemType_Complex)
    {
        NSInteger blockW = FIELD_WIDTH/blocks.count;
        NSInteger blockX = FIELD_LEFT_MARGIN;

        if (!title.text.length)
        {
            blockW = FIELD_AVAILABLE_WIDTH/blocks.count;
            blockX = title.x;
        }
        
        for (PLTableItem * item in blocks)
        {
            UITextField * field = [[UITextField alloc] initWithFrame:CGRectMake(blockX, 10, blockW - BLOCK_GAP, 30)];
            field.placeholder = @"";
            field.autocorrectionType = UITextAutocorrectionTypeNo;
            field.textAlignment = NSTextAlignmentCenter;
            field.text = item.text?item.text:@"";
            field.backgroundColor = [UIColor clearColor];
            field.textColor = [UIColor whiteColor];
            field.autoresizingMask = UIViewAutoresizingNone;
            [field setClearButtonMode:UITextFieldViewModeNever];
            field.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            field.delegate = cell;
         
            [cell.inputs addObject:field];
            
            if (item != blocks.lastObject || !last)
            {
                field.returnKeyType = UIReturnKeyNext;
            }
            else
            {
                field.returnKeyType = UIReturnKeyDone;
            }
            
            [cell.contentView addSubview:field];
            
            UIView * v = [[UIView alloc] initWithFrame:CGRectMake(field.x, field.bottom, field.width, 2)];
            v.backgroundColor = item.required?UIColorFromRGBA(resColorMenuText):[UIColor colorWithWhite:1 alpha:0.3];
            [cell.contentView addSubview:v];
            
            UILabel * hint = [[UILabel alloc] initWithFrame:CGRectMake(field.x, v.bottom+2, field.width, 12)];
            hint.backgroundColor = [UIColor clearColor];
            hint.textColor = UIColorFromRGBA(resColorMenuText);
            hint.font = [UIFont fontWithName:@"ProximaNova-Light" size:12];
            hint.text = item.title;
            hint.textAlignment = NSTextAlignmentCenter;
            
            [cell.contentView addSubview:hint];
            
            blockX += blockW;
        }
    }
    else
    {
        UITextField * field = [[UITextField alloc] initWithFrame:CGRectMake(140, 10, FIELD_WIDTH, 30)];
        field.placeholder = placeholder?placeholder:@"";
        field.autocorrectionType = UITextAutocorrectionTypeNo;
        field.text = text?text:@"";
        field.backgroundColor = [UIColor clearColor];
        field.textColor = [UIColor whiteColor];
        field.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [field setClearButtonMode:UITextFieldViewModeWhileEditing];
        field.delegate = cell;
        [cell.inputs addObject:field];
        
        if (!title.text.length)
        {
            field.x = title.x;
            field.width = FIELD_AVAILABLE_WIDTH;
        }
        
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
                field.textColor = [UIColor colorWithWhite:1 alpha:0.3];
                break;
            case PLTableItemType_ListItem:
                field.userInteractionEnabled = NO;
                field.hidden = YES;
                title.width = field.right - title.x;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case PLTableItemType_Complex:
                break;
        }
        
        if (last)
        {
            field.returnKeyType = UIReturnKeyDone;
        }
        else
        {
            field.returnKeyType = UIReturnKeyNext;
        }
        
        [cell.contentView addSubview:field];
    }
    
    CGPoint p = title.center;
    CGRect r = title.frame;
    
    [title sizeToFit];
    title.center = p;
    title.x = r.origin.x;
    title.width = r.size.width;
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(9, 46, FIELD_AVAILABLE_WIDTH, 1)];
    view.backgroundColor = UIColorFromRGBA(resColorDivider);
    view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    cell.divider = view;
    
    [cell.contentView addSubview:view];
    
    return cell;
}

- (void)setResponder
{
    [self.inputs.firstObject becomeFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    switch (self.type) {
        case PLTableItemType_Text:
        {
            if ([string isEqualToString:@" "]) return YES;

            NSCharacterSet *validChars = [NSCharacterSet letterCharacterSet];
            NSCharacterSet *invalidChars = [validChars invertedSet];
            
            NSRange range = [string rangeOfCharacterFromSet:invalidChars options:NSCaseInsensitiveSearch];
            
            return range.location == NSNotFound;
        }
        default:
            break;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.type == PLTableItemType_Complex)
    {
        for (int i = 0; i < self.inputs.count; i++)
        {
            UITextField * f = self.inputs[i];
            if (f == textField)
            {
                if (i == self.inputs.count - 1)
                {
                    [self.delegate cellDidReturn:self];
                }
                else
                {
                    UITextField * next = self.inputs[i+1];
                    [next becomeFirstResponder];
                }
                break;
            }
        }
    }
    else
    {
        [self.delegate cellDidReturn:self];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.type == PLTableItemType_Complex)
    {
        for (int i = 0; i < self.inputs.count; i++)
        {
            UITextField * f = self.inputs[i];
            if (f == textField)
            {
                [self.delegate complexCell:self idx:i didChanged:textField.text];
                break;
            }
        }
    }
    else
    {
        [self.delegate cell:self didChanged:textField.text];
    }
}

- (void)hideDivider:(BOOL)hide
{
    [self.divider setHidden:hide];
}

@end
