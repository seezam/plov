//
//  PLTableViewController.m
//  plov.com
//
//  Created by v.kubyshev on 30/09/15.
//  Copyright © 2015 plov.com. All rights reserved.
//

#import "PLTableViewController.h"
#import "PLTextTableViewCell.h"

#import "PhoneNumberFormatter.h"
#import "OrderObject.h"

@implementation PLTableItem

+ (PLTableItem *)textItem:(NSString *)itemId
                withTitle:(NSString *)title text:(NSString *)text required:(BOOL)requited type:(PLTableItemType)type
{
    PLTableItem * name = [[PLTableItem alloc] init];
    name.type = type;
    name.title = title?title:@"";
    name.text = text?text:@"";
    name.placeholder = requited?LOC(@"LOC_ORDER_HINT_REQUIRED"):LOC(@"LOC_ORDER_HINT_OPTIONAL");
    name.itemId = itemId;
    name.required = requited;
    
    return name;
}

+ (PLTableItem *)complexItem:(NSString *)itemId withTitle:(NSString *)title blocks:(NSArray *)blocks
{
    PLTableItem * name = [[PLTableItem alloc] init];
    name.type = PLTableItemType_Complex;
    name.title = title?title:@"";
    name.text = @"";
    name.placeholder = @"";
    name.itemId = itemId;
    name.required = YES;
    name.blocks = blocks;
    
    return name;
}

- (BOOL)internalValidation
{
    switch (self.type)
    {
        case PLTableItemType_Phone:
        {
            NSString * strip = [PhoneNumberFormatter strip:self.text];
            if (strip.length < 12)
            {
                return NO;
            }
        }
            break;
        case PLTableItemType_Email:
        {
            NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
            NSString *emailRegex = laxString;
            NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
            return [emailTest evaluateWithObject:self.text];
        }
            break;
        default:
            break;
    }
    
    return YES;
}

- (BOOL)valid
{
    if (self.type != PLTableItemType_Complex)
    {
        if (self.text.length == 0)
        {
            return !self.required;
        }
        
        return [self internalValidation];
    }
    else
    {
        for (PLTableItem * block in self.blocks)
        {
            if (![block valid])
            {
                return NO;
            }
        }
    }
    
    return YES;
}

@end

@interface PLTableViewController ()<PLTextTableViewCellDelegate>
@property (nonatomic, assign) NSInteger initialTableHeight;
@property (nonatomic, assign) BOOL needResetContent;
@end

@implementation PLTableViewController

+ (PLTableViewController *)instantiateFromStoryboard:(UIStoryboard *)storyboard
{
    return [storyboard instantiateViewControllerWithIdentifier:@"tableViewController"];
}

- (void)shakeRow:(NSInteger)row
{
    NSIndexPath * path = [NSIndexPath indexPathForRow:row inSection:0];
    UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:path];
    
    if (cell)
    {
        UIView * lockView = cell.contentView;
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        [animation setDuration:0.05];
        [animation setRepeatCount:6];
        [animation setAutoreverses:YES];
        [animation setFromValue:[NSValue valueWithCGPoint:
                                 CGPointMake(lockView.center.x - 10.0f, lockView.center.y)]];
        [animation setToValue:[NSValue valueWithCGPoint:
                               CGPointMake(lockView.center.x + 10.0f, lockView.center.y)]];
        [[lockView layer] addAnimation:animation forKey:@"position"];
    }
}

- (void)trashButtonPressed
{
    UIActionSheet * action = [[UIActionSheet alloc] init];
    
    action.title = LOC(@"DELETE_ADDRESS_ACTION");
    [action addButtonWithTitle:LOC(@"DELETE_ACTION")];
    [action addButtonWithTitle:LOC(@"CANCEL_ACTION")];
    
    action.destructiveButtonIndex = 0;
    action.cancelButtonIndex = 1;
    
    action.delegate = self;
    [action showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        self.trashButtonBlock(self);
    }
}

- (IBAction)processToOrder:(id)sender
{
    [self.view endEditing:YES];
    
    for (NSInteger row = 0; row < self.items.count; row++)
    {
        PLTableItem * item = self.items[row];
        
        if (![item valid])
        {
            [self shakeRow:row];
            
            return;
        }
    }
    
    self.nextButtonBlock(self);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self checkCartPos];
    
    //set back button arrow color
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    if (self.fillDataBlock)
    {
        self.fillDataBlock(self);
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.initialTableHeight = self.tableView.height;
    
    [SHARED_APP.tracking openScreen:self.screenName];
}


- (void)viewDidLoad
{
    //set back button color
    [[UIBarButtonItem appearanceWhenContainedIn:[PLTableViewController class], nil]
     setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor] }
     forState:UIControlStateNormal];
    
    self.backetSumLabel.textAlignment = NSTextAlignmentRight;
    
    self.processButton.layer.cornerRadius = 10;
    
    self.needResetContent = YES;
    
    switch (self.buttonMode)
    {
        case PLTableButtonMode_Continue:
            [self.processButton setTitle:LOC(@"LOC_CONTINUE_BUTTON") forState:UIControlStateNormal];
            self.orderLabel.text = LOC(@"LOC_ORDER_TEXT");
            break;
        case PLTableButtonMode_Save:
        case PLTableButtonMode_SaveDelete:
            [self.processButton setTitle:LOC(@"LOC_SAVE_BUTTON") forState:UIControlStateNormal];
            self.cartIcon.hidden = YES;
            self.backetSumLabel.hidden = YES;
            self.orderLabel.hidden = YES;
            
            if (self.buttonMode == PLTableButtonMode_SaveDelete)
            {
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(trashButtonPressed)];
            }
            break;
        case PLTableButtonMode_None:
            self.tableView.height = self.view.height - self.tableView.y;
            self.processButton.hidden = YES;
            self.cartIcon.hidden = YES;
            self.backetSumLabel.hidden = YES;
            self.orderLabel.hidden = YES;
            break;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableTapped:)];
    [self.tableView addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleWillShowKeyboardNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleWillHideKeyboardNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setItems:(NSArray *)items
{
    _items = items;
    
    [self.tableView reloadData];
}

#pragma mark - TableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    PLTableItem * item = self.items[row];
    
    PLTextTableViewCell * cell = nil;
    
    cell = [PLTextTableViewCell cellWithText:item.text
                                 placeholder:item.placeholder
                                        name:item.title
                                     reuseId:item.itemId
                                        type:item.type
                                      blocks:item.blocks
                                        last:(row == self.items.count - 1)];

    cell.delegate = self;
    [cell hideDivider:(row == self.items.count - 1)];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    PLTableItem * item = self.items[row];
    
    if (item.type == PLTableItemType_ListItem && self.itemSelectBlock)
    {
        self.itemSelectBlock(self, item);
    }
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSDictionary * item = self.items[indexPath.row];
//    
//    if ([item[@"image"] isEqualToString:@"menu-call"])
//    {
//        NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",@"+74957897893"]];
//        
//        if ([[UIApplication sharedApplication] canOpenURL:phoneUrl])
//        {
//            [[UIApplication sharedApplication] openURL:phoneUrl];
//        }
//    }
//    else if ([item[@"segue"] length])
//    {
//        [self processToViewController:item[@"segue"]];
//    }
//    
//    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
//}

- (NSInteger)totalCost
{
    if (self.order.cost > 0)
    {
        return self.order.cost + self.order.deliveryCost;
    }
    else
    {
        return 0;
    }
}

- (void)checkCartPos
{
    UILabel * testLabel = [[UILabel alloc] initWithFrame:self.backetSumLabel.frame];
    testLabel.attributedText = [SHARED_APP rubleCost:[self totalCost] font:self.backetSumLabel.font];
    [testLabel sizeToFit];
    NSInteger newX = self.view.width - self.cartIcon.width - 13 - ceil(testLabel.width/10)*10 - 3;
    
    if (newX != self.cartIcon.x)
    {
        self.cartIcon.x = newX;
    }
    
    self.backetSumLabel.attributedText = testLabel.attributedText;
}

- (void)cellDidReturn:(PLTextTableViewCell *)cell
{
    NSInteger row = [self.tableView indexPathForCell:cell].row;
    
    if (row != NSNotFound)
    {
        if (row == self.items.count - 1)
        {
            [self.view endEditing:YES];
        }
        else
        {
            PLTextTableViewCell * nextCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(row + 1) inSection:0]];
            
            [nextCell setResponder];
        }
    }
}

- (void)resetContextWith:(PLTableItem *)item block:(PLTableItem *)block
{
    for (PLTableItem * i in self.items)
    {
        if (i.type != PLTableItemType_ReadOnly &&
            i != item && i.type != PLTableItemType_Complex)
        {
            i.text = @"";
        }
        
        if (i.type == PLTableItemType_Complex)
        {
            for (PLTableItem * b in i.blocks)
            {
                if (b != block)
                {
                    b.text = @"";
                }
                
            }
        }
        
    }
    
    self.needResetContent = NO;
    
    [self.tableView reloadData];
}

- (void)complexCell:(PLTextTableViewCell *)cell idx:(NSInteger)idx didChanged:(NSString *)text
{
    NSInteger row = [self.tableView indexPathForCell:cell].row;
    
    if (row != NSNotFound)
    {
        PLTableItem * item = self.items[row];
        
        PLTableItem * block = item.blocks[idx];
        
        if (![block.text isEqualToString:text])
        {
            block.text = text;
            
            if (self.needResetContent)
            {
                [self resetContextWith:item block:block];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    PLTextTableViewCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(row) inSection:0]];
                    [cell setResponder];
                });
            }
        }
    }
}

- (void)cell:(PLTextTableViewCell *)cell didChanged:(NSString *)text
{
    NSInteger row = [self.tableView indexPathForCell:cell].row;
    
    if (row != NSNotFound)
    {
        PLTableItem * item = self.items[row];
        
        if (![item.text isEqualToString:text])
        {
            item.text = text;
            
            if (self.needResetContent)
            {
                [self resetContextWith:item block:nil];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    PLTextTableViewCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(row) inSection:0]];
                    [cell setResponder];
                });
            }
        }
    }
}

- (void)tableTapped:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
    
    CGPoint p = [tap locationInView:self.tableView];
    NSIndexPath * idxPath = [self.tableView indexPathForRowAtPoint:p];
    
    if (idxPath)
    {
        [self tableView:self.tableView didSelectRowAtIndexPath:idxPath];
    }
}

- (void)handleWillShowKeyboardNotification:(NSNotification *)notification {
    [self keyboardWillShowHide:notification isShowing:YES];
}

// ----------------------------------------------------------------
- (void)handleWillHideKeyboardNotification:(NSNotification *)notification {
    [self keyboardWillShowHide:notification isShowing:NO];
}

- (void)keyboardWillShowHide:(NSNotification *)notification isShowing:(BOOL)isShowing {
    // getting keyboard animation attributes
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSTimeInterval duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // getting passed blocks
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [UIView setAnimationCurve:curve];
                         
                         if (isShowing) {
                             self.tableView.height = self.initialTableHeight - CGRectGetHeight(keyboardRect) + 60;
                         } else {
                             self.tableView.height = self.initialTableHeight;
                         }
                         [self.view layoutIfNeeded];
                         
                     }
                     completion:^(BOOL finished) {
         
                     }
     ];
}

@end
