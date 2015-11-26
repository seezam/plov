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
#import "NameViewController.h"

#import "MyOrdersViewController.h"
#import "MyAddressesViewController.h"

#import "CustomerObject.h"

@interface MenuViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray * items;
@end

@implementation MenuViewController

- (void)reloadData
{
    NSMutableArray * items = [NSMutableArray array];
    
    BOOL hasCustomer = (SHARED_APP.customer.name.length &&
                        SHARED_APP.customer.phone.length &&
                        SHARED_APP.customer.orders.count);
    [items addObject:@{@"type": @"logo"}];
    
    if (hasCustomer)
    {
        [items addObject:@{@"type": @"profile"}];
    }
    
    /*
    [items addObjectsFromArray:@[
                                @{
                                    @"image": @"menu-account",
                                    @"title": LOC(@"LOC_MENU_ACCOUNT")
                                    },
                                @{
                                    @"image": @"menu-code",
                                    @"title": LOC(@"LOC_MENU_CODE")
                                    }
                                ]];
    
    [items addObjectsFromArray:@[@{
                                    @"image": @"menu-gift",
                                    @"title": LOC(@"LOC_MENU_GIFT")
                                    },
                                @{
                                    @"image": @"menu-invite",
                                    @"title": LOC(@"LOC_MENU_INVITE")
                                    }
                                 ]];
    */
    
    if (hasCustomer)
    {
        [items addObjectsFromArray:@[@{
                                         @"image": @"menu-orders",
                                         @"title": LOC(@"LOC_MENU_ORDERS")
                                         },
                                     @{
                                         @"image": @"menu-adress",
                                         @"title": LOC(@"LOC_MENU_ADRESS"),
                                         }
                                     ]];
    }
    
    [items addObjectsFromArray:@[
                                 /*@{
                                     @"image": @"menu-cards",
                                     @"title": LOC(@"LOC_MENU_CARDS")
                                     },*/
                                 @{
                                     @"image": @"menu-call",
                                     @"title": LOC(@"LOC_MENU_CALL")
                                     }
                                 ]];
    
    self.items = items;

    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [SHARED_APP.tracking openScreen:@"Menu"];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//}

//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

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
    [navigation pushToViewControllerIdentifier:segue];
}

#pragma mark - TableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    NSDictionary * item = self.items[row];
    
    if ([item[@"type"] isEqualToString:@"logo"])
    {
        return 44;
    }
    else if ([item[@"type"] isEqualToString:@"profile"])
    {
        return 95;
    }
    else
    {
        return 44;
    }
}

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
        reuseIdentifier = profileCellIdentifier;
        
        ProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[ProfileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        }
        
        [cell updateCell];
        
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
    
    if ([item[@"type"] isEqualToString:@"profile"])
    {
        PLTableViewController * vc = [NameViewController instantiateFromStoryboard:self.storyboard];
        vc.buttonMode = PLTableButtonMode_Save;
        
        PLNavigationController * navigation = (PLNavigationController *)self.revealViewController.frontViewController;
        [navigation pushToViewController:vc];
    }
    else if ([item[@"image"] isEqualToString:@"menu-orders"])
    {
        PLTableViewController * vc = [MyOrdersViewController instantiateFromStoryboard:self.storyboard];
        
        PLNavigationController * navigation = (PLNavigationController *)self.revealViewController.frontViewController;
        [navigation pushToViewController:vc];
    }
    else if ([item[@"image"] isEqualToString:@"menu-adress"])
    {
        PLTableViewController * vc = [MyAddressesViewController instantiateFromStoryboard:self.storyboard];
        
        PLNavigationController * navigation = (PLNavigationController *)self.revealViewController.frontViewController;
        [navigation pushToViewController:vc];
    }
    else if ([item[@"image"] isEqualToString:@"menu-call"])
    {
//        [Intercom presentMessageComposer];
        
        NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",@"+74957897893"]];
        
        if ([[UIApplication sharedApplication] canOpenURL:phoneUrl])
        {
            [[UIApplication sharedApplication] openURL:phoneUrl];
        }
    }
    else if ([item[@"segue"] length])
    {
        [self processToViewController:item[@"segue"]];
    }
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

@end
