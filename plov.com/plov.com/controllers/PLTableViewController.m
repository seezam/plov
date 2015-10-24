//
//  PLTableViewController.m
//  plov.com
//
//  Created by v.kubyshev on 30/09/15.
//  Copyright © 2015 plov.com. All rights reserved.
//

#import "PLTableViewController.h"
#import "PLTextTableViewCell.h"

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

@end

@interface PLTableViewController ()<PLTextTableViewCellDelegate>
@property (nonatomic, assign) NSInteger initialTableHeight;
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

- (IBAction)processToOrder:(id)sender
{
    [self.view endEditing:YES];
    
    for (NSInteger row = 0; row < self.items.count; row++)
    {
        PLTableItem * item = self.items[row];
        
        if (item.required && item.text.length == 0)
        {
            [self shakeRow:row];
            
            return;
        }
    }
    
    self.nextBlock(self);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self checkCartPos];
    
    //set back button arrow color
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.initialTableHeight = self.tableView.height;
}


- (void)viewDidLoad
{
    //set back button color
    [[UIBarButtonItem appearanceWhenContainedIn:[PLTableViewController class], nil]
     setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor] }
     forState:UIControlStateNormal];
    
    self.backetSumLabel.textAlignment = NSTextAlignmentRight;
    
    self.processButton.layer.cornerRadius = 10;
    
    if (self.editMode)
    {
        [self.processButton setTitle:LOC(@"LOC_SAVE_BUTTON") forState:UIControlStateNormal];
        self.cartIcon.hidden = YES;
        self.backetSumLabel.hidden = YES;
        self.orderLabel.hidden = YES;
    }
    else
    {
        [self.processButton setTitle:LOC(@"LOC_CONTINUE_BUTTON") forState:UIControlStateNormal];
        self.orderLabel.text = LOC(@"LOC_ORDER_TEXT");
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
                                        last:(row == self.items.count - 1)];

    cell.delegate = self;
    [cell hideDivider:(row == self.items.count - 1)];
    
    return cell;
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

- (void)checkCartPos
{
    UILabel * testLabel = [[UILabel alloc] initWithFrame:self.backetSumLabel.frame];
    testLabel.attributedText = [SHARED_APP rubleCost:self.bucketSum font:self.backetSumLabel.font];
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

- (void)cell:(PLTextTableViewCell *)cell didChanged:(NSString *)text
{
    NSInteger row = [self.tableView indexPathForCell:cell].row;
    
    if (row != NSNotFound)
    {
        PLTableItem * item = self.items[row];
        
        item.text = text;
    }
}

- (void)tableTapped:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
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
