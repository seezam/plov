//
//  MenuViewController.m
//  plov.com
//
//  Created by v.kubyshev on 06/08/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuTableViewCell.h"
#import "ProfileTableViewCell.h"
#import "SWRevealViewController.h"
#import "PLNavigationController.h"

@import Intercom;

@interface MenuViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray * items;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.items = @[
                   @{
                       @"type": @"logo"
                   },
                   @{
                       @"image": @"menu-account",
                       @"title": LOC(@"LOC_MENU_ACCOUNT")
                    },
                   @{
                       @"image": @"menu-code",
                       @"title": LOC(@"LOC_MENU_CODE")
                    },
                   @{
                       @"image": @"menu-status",
                       @"title": LOC(@"LOC_MENU_STATUS")
                    },
                   @{
                       @"image": @"menu-gift",
                       @"title": LOC(@"LOC_MENU_GIFT")
                    },
                   @{
                       @"image": @"menu-invite",
                       @"title": LOC(@"LOC_MENU_INVITE")
                    },
                   @{
                       @"image": @"menu-orders",
                       @"title": LOC(@"LOC_MENU_ORDERS")
                    },
                   @{
                       @"image": @"menu-adress",
                       @"title": LOC(@"LOC_MENU_ADRESS"),
                       @"segue": @"addressViewController"
                    },
                   @{
                       @"image": @"menu-cards",
                       @"title": LOC(@"LOC_MENU_CARDS")
                    },
                   @{
                       @"image": @"menu-call",
                       @"title": LOC(@"LOC_MENU_CALL")
                    },
                   ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Navigation
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:segue.identifier];
//    
//    [self.revealViewController setRightViewController:vc];
//}

- (void)processToViewController:(NSString *)segue
{
    PLNavigationController * navigation = (PLNavigationController *)self.revealViewController.frontViewController;
    [navigation pushToViewController:segue];
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
    static NSString *itemCellIdentifier = @"mainMenuItem";
    static NSString *logoCellIdentifier = @"logoMenuItem";
    static NSString *profileCellIdentifier = @"profileMenuItem";
    
    NSInteger row = indexPath.row;
    
    NSDictionary * item = self.items[row];
    
    NSString * reuseIdentifier = @"";
    
    if ([item[@"type"] isEqualToString:@"logo"])
    {
        reuseIdentifier = logoCellIdentifier;
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        }
        
        return cell;
    }
    else if ([item[@"type"] isEqualToString:@"profile"])
    {
        reuseIdentifier = logoCellIdentifier;
        
        ProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[ProfileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        }
        
        return cell;
    }
    else
    {
        reuseIdentifier = itemCellIdentifier;
        
        MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        }
        
        cell.menuImage.image = [UIImage imageNamed:item[@"image"]];
        cell.menuTitle.text = item[@"title"];
        
        if (row != self.items.count - 1)
        {
            cell.bottomDivider.hidden = YES;
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * item = self.items[indexPath.row];
    
    if ([item[@"image"] isEqualToString:@"menu-call"])
    {
        [Intercom presentMessageComposer];
        
//        NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",@"+74957897893"]];
//        
//        if ([[UIApplication sharedApplication] canOpenURL:phoneUrl])
//        {
//            [[UIApplication sharedApplication] openURL:phoneUrl];
//        }
    }
    else if ([item[@"segue"] length])
    {
        [self processToViewController:item[@"segue"]];
    }
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

@end
