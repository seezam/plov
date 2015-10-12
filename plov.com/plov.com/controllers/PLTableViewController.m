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

+ (PLTableItem *)textItem:(NSString *)itemId withTitle:(NSString *)title text:(NSString *)text required:(BOOL)requited
{
    PLTableItem * name = [[PLTableItem alloc] init];
    name.type = PLTableItemType_Text;
    name.title = title?title:@"";
    name.text = text?text:@"";
    name.placeholder = requited?LOC(@"LOC_ORDER_HINT_REQUIRED"):LOC(@"LOC_ORDER_HINT_OPTIONAL");
    name.itemId = itemId;
    name.required = requited;
    
    return name;
}

@end

@interface PLTableViewController ()<PLTextTableViewCellDelegate>

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
    
    Class nextClass = NSClassFromString(self.nextViewController);
    PLTableViewController * vc = [nextClass instantiateFromStoryboard:self.storyboard];
    
    vc.bucketSum = self.bucketSum;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self checkCartPos];
    
    //set back button arrow color
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}


- (void)viewDidLoad
{
    //set back button color
    [[UIBarButtonItem appearanceWhenContainedIn:[PLTableViewController class], nil]
     setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor] }
     forState:UIControlStateNormal];
    
    self.backetSumLabel.textAlignment = NSTextAlignmentRight;
    
    self.processButton.layer.cornerRadius = 10;
    [self.processButton setTitle:LOC(@"LOC_CONTINUE_BUTTON") forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableTapped:)];
    [self.tableView addGestureRecognizer:tap];
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
    
    switch (item.type) {
        case PLTableItemType_Text:
        {
            cell = [PLTextTableViewCell cellWithText:item.text
                                                               placeholder:item.placeholder
                                                                      name:item.title
                                                                   reuseId:item.itemId];
        }
            break;
        case PLTableItemType_Phone:
        {
            [PLTextTableViewCell cellWithText:item.text
                                                               placeholder:item.placeholder
                                                                      name:item.title
                                                                   reuseId:item.itemId];
        }
            break;
    }

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

@end
