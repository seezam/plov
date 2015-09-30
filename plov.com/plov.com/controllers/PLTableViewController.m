//
//  PLTableViewController.m
//  plov.com
//
//  Created by v.kubyshev on 30/09/15.
//  Copyright © 2015 plov.com. All rights reserved.
//

#import "PLTableViewController.h"
#import "PLTextTableViewCell.h"

@implementation PLTableViewController

+ (instancetype)instantiateFromStoryboard:(UIStoryboard *)storyboard
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

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    PLTableItem * item = self.items[row];
    
    switch (item.type) {
        case PLTableItemType_Text:
        {
            PLTextTableViewCell * cell = [PLTextTableViewCell cellWithText:item.text
                                                               placeholder:item.placeholder
                                                                      name:item.title
                                                                   reuseId:item.itemId];
            return cell;
        }
            break;
        case PLTableItemType_Phone:
            return nil;
            break;
    }

    return nil;
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

@end
