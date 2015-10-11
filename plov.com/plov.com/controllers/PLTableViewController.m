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

- (void)viewDidLoad
{
    //set back button color
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
        setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor] }
        forState:UIControlStateNormal];
    //set back button arrow color
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
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

- (void)cell:(PLTextTableViewCell *)cell didChanged:(NSString *)text
{
    NSInteger row = [self.tableView indexPathForCell:cell].row;
    
    if (row != NSNotFound)
    {
        PLTableItem * item = self.items[row];
        
        item.text = text;
    }
}

@end
