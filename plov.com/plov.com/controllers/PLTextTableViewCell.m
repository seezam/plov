//
//  PLTextTableViewCell.m
//  plov.com
//
//  Created by v.kubyshev on 29/09/15.
//  Copyright © 2015 plov.com. All rights reserved.
//

#import "PhoneNumberFormatter.h"
#import "PLTextTableViewCell.h"

@interface PLTextTableViewCell ()<UITextFieldDelegate>
@property (nonatomic, weak) UIView * divider;
@property (nonatomic, strong) NSMutableArray * inputs;

@property (nonatomic, assign) PLTableItemType type;

@property (nonatomic, strong) PhoneNumberFormatter * phoneFormatter;
@end

#define FIELD_LEFT_MARGIN 140
#define FIELD_AVAILABLE_WIDTH ([[UIScreen mainScreen] bounds].size.width - 18)
#define FIELD_WIDTH ([[UIScreen mainScreen] bounds].size.width - 18) - FIELD_LEFT_MARGIN
#define BLOCK_GAP 10


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
         
            switch (item.type) {
                case PLTableItemType_Alpha:
                    field.keyboardType = UIKeyboardTypeNamePhonePad;
                    break;
                case PLTableItemType_AlphaNumber:
                    field.keyboardType = UIKeyboardTypeDefault;
                    break;
                case PLTableItemType_Number:
                    field.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                    break;
                case PLTableItemType_ReadOnly:
                    field.userInteractionEnabled = NO;
                    field.textColor = [UIColor colorWithWhite:1 alpha:0.3];
                    break;
                default:
                    break;
            }
            
            [cell.inputs addObject:@{@"type": @(item.type), @"field": field}];
            
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
        [cell.inputs addObject:@{@"type": @(type), @"field": field }];
        
        if (!title.text.length)
        {
            field.x = title.x;
            field.width = FIELD_AVAILABLE_WIDTH;
        }
        
        switch (type) {
            case PLTableItemType_Alpha:
                field.keyboardType = UIKeyboardTypeNamePhonePad;
                break;
            case PLTableItemType_AlphaNumber:
                field.keyboardType = UIKeyboardTypeDefault;
                break;
            case PLTableItemType_Number:
                field.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                break;
            case PLTableItemType_Phone:
                field.keyboardType = UIKeyboardTypePhonePad;
                
                cell.phoneFormatter = [[PhoneNumberFormatter alloc] init];
                [field addTarget:cell action:@selector(phoneFormatTextField:)
                    forControlEvents:UIControlEventEditingChanged];
                
                field.text = [cell.phoneFormatter format:field.text withLocale:@"ru"];
                break;
            case PLTableItemType_Email:
                field.keyboardType = UIKeyboardTypeEmailAddress;
                break;
            case PLTableItemType_ReadOnly:
                field.userInteractionEnabled = NO;
                field.textColor = [UIColor colorWithWhite:1 alpha:0.3];
                break;
            case PLTableItemType_ReadOnlyRuble:
                field.attributedText = [SHARED_APP rubleCost:text.integerValue font:field.font];
                field.userInteractionEnabled = NO;
                field.textColor = [UIColor colorWithWhite:1 alpha:0.3];
                field.textAlignment = NSTextAlignmentRight;
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

-(void)dealloc
{
    if (self.type == PLTableItemType_Phone && self.inputs.count == 1)
    {
        UITextField * field = self.inputs.firstObject[@"field"];
        [field removeTarget:self action:@selector(phoneFormatTextField:) forControlEvents:UIControlEventAllEvents];
    }
}

- (void)setResponder
{
    NSDictionary * input = self.inputs.firstObject;
    [input[@"field"] becomeFirstResponder];
}

- (BOOL)validChars:(NSString *)string type:(PLTableItemType)type field:(UITextField *)field
{
    NSCharacterSet * validChars = nil;
    NSCharacterSet * invalidChars = nil;
    
    switch (type) {
        case PLTableItemType_Alpha:
        {
            if ([string isEqualToString:@" "]) return YES;
            
            validChars = [NSCharacterSet letterCharacterSet];
        }
            break;
        case PLTableItemType_Number:
        case PLTableItemType_Phone:
        {
            validChars = [NSCharacterSet decimalDigitCharacterSet];
        }
            break;
        case PLTableItemType_AlphaNumber:
        {
            if ([string isEqualToString:@" "]||
                [string isEqualToString:@"-"]||
                [string isEqualToString:@"/"]||
                [string isEqualToString:@"."]) return YES;
            
            validChars = [NSCharacterSet alphanumericCharacterSet];
        }
            break;
//        case PLTableItemType_Email:
//            if ([string isEqualToString:@"@"]||
//                [string isEqualToString:@"-"]||
//                [string isEqualToString:@"_"]||
//                [string isEqualToString:@"."]) return YES;
//            
//            validChars = [NSCharacterSet alphanumericCharacterSet];
//            break;
        case PLTableItemType_Complex:
        {
            for (NSDictionary * dict in self.inputs)
            {
                PLTableItemType t = [dict[@"type"] integerValue];
                UITextField * f = dict[@"field"];
                if (f == field)
                {
                    return [self validChars:string type:t field:nil];
                }
            }
            
            return YES;
        }
        default:
            return YES;
            break;
    }
    
    invalidChars = [validChars invertedSet];
    
    NSRange range = [string rangeOfCharacterFromSet:invalidChars options:NSCaseInsensitiveSearch];
    
    return range.location == NSNotFound;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [self validChars:string type:self.type field:textField];
}

- (void)phoneFormatTextField:(UITextField *)field
{
    UITextRange *selRange = field.selectedTextRange;
    UITextPosition *selStartPos = selRange.start;
    
    NSInteger pos = [field offsetFromPosition:field.beginningOfDocument toPosition:selStartPos];
    
    BOOL keepPos = YES;
    if (pos == field.text.length)
    {
        keepPos = NO;
    }
    
    field.text = [self.phoneFormatter format:field.text withLocale:@"ru"];

    if (keepPos)
    {
        UITextPosition * newPos = [field positionFromPosition:field.beginningOfDocument offset:pos];
        [field setSelectedTextRange:[field textRangeFromPosition:newPos toPosition:newPos]];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.type == PLTableItemType_Complex)
    {
        for (int i = 0; i < self.inputs.count; i++)
        {
            UITextField * f = self.inputs[i][@"field"];
            if (f == textField)
            {
                if (i == self.inputs.count - 1)
                {
                    [self.delegate cellDidReturn:self];
                }
                else
                {
                    UITextField * next = self.inputs[i+1][@"field"];
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
            UITextField * f = self.inputs[i][@"field"];
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
