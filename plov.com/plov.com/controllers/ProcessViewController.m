//
//  ProcessViewController.m
//  plov.com
//
//  Created by v.kubyshev on 15/10/15.
//  Copyright © 2015 plov.com. All rights reserved.
//

#import "ProcessViewController.h"

#import "CustomerObject.h"
#import "AddressObject.h"
#import "PLCRMSupport.h"
#import "MenuItemObject.h"

@interface ProcessViewController ()
@property (nonatomic, assign) BOOL processed;
@end

@implementation ProcessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 1, 11)];
    
    self.navigationController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self createOrder];
}

- (void)createOrder
{
    NSMutableDictionary * orderDict = [NSMutableDictionary dictionary];
    
    orderDict[@"nickName"] = SHARED_APP.customer.name;
    orderDict[@"phone"] = SHARED_APP.customer.phone;
    orderDict[@"contragentType"] = @"individual";
    
    NSMutableArray * orders = [NSMutableArray array];
    
    for (MenuItemObject * item in self.order)
    {
        NSDictionary * itemDesc = @{
                                    @"initialPrice": @(item.cost),
                                    @"purchasePrice": @(item.cost),
                                    @"productName": item.title,
                                    @"quantity": @(item.count),
                                    };
        
        [orders addObject:itemDesc];
    }
    
    orderDict[@"items"] = orders;
    
    AddressObject * address = SHARED_APP.customer.addresses.lastObject;
    
    NSMutableDictionary * deliverTo = [@{
                                        @"city": address.city,
                                        //                                       @"region": @"muhosranskaya obl",
                                        @"street": address.street,
                                        @"building" : address.building,
                                        @"flat": address.flat
                                        } mutableCopy];
    
    if (address.house.length)
    {
        deliverTo[@"house"] = address.house;
    }
    
    if (address.block.length)
    {
        deliverTo[@"block"] = address.block;
    }
    orderDict[@"delivery"] = @{@"address": deliverTo};

    [SHARED_APP.crm createOrder:orderDict success:^(NSData *data) {
        NSDictionary * resp = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        
        if ([resp[@"id"] integerValue] > 0 &&
            [resp[@"success"] integerValue] == 1)
        {
            [SHARED_APP.customer setLastOrder:self.order orderId:resp[@"id"]
                                      address:[address fullAddressString] cost:self.bucketCost];
            [SHARED_APP.customer saveData];
            self.processed = YES;
        }
        else
        {
            [self showError];
        }
    } error:^(NSError *error) {
        NSLog(@"Process order error: %@", error);
        [self showError];
    }];
}

- (void)showError
{
    
}

- (IBAction)doneClick:(id)sender {
    
    //TODO: save order
    if (self.processed)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [self createOrder];
    }
}


@end
