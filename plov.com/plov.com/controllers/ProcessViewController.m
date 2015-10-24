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
    
    self.infoLabel.layer.masksToBounds = YES;
    self.infoLabel.layer.cornerRadius = 10;
    self.doneButton.layer.cornerRadius = 10;
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
    self.infoLabel.text = LOC(@"LOC_ORDER_PROCESSING");
    self.doneButton.enabled = NO;
    
    NSMutableDictionary * orderDict = [NSMutableDictionary dictionary];
    
    orderDict[@"firstName"] = SHARED_APP.customer.name;
    orderDict[@"phone"] = SHARED_APP.customer.phone;
    orderDict[@"contragentType"] = @"individual";
    orderDict[@"orderType"] = @"ios";
    
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

    [SHARED_APP.crm createOrder:orderDict success:^(NSDictionary * resp) {
        if ([resp[@"id"] integerValue] > 0 &&
            [resp[@"success"] integerValue] == 1)
        {
            NSString * strId = [NSString stringWithFormat:@"%@", resp[@"id"]];
            
            [SHARED_APP.customer setLastOrder:self.order orderId:strId
                                      address:[address fullAddressString] cost:self.bucketSum];
            [SHARED_APP.customer saveData];
            [SHARED_APP updateMenu];
            self.processed = YES;
            
            self.infoLabel.text = LOC(@"LOC_ORDER_CREATED");
            [self.doneButton setTitle:@"OK" forState:UIControlStateNormal];
            self.doneButton.enabled = YES;
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
    self.infoLabel.text = LOC(@"LOC_ORDER_FAILED");
    [self.doneButton setTitle:LOC(@"LOC_ORDER_RETRY") forState:UIControlStateNormal];
    self.doneButton.enabled = YES;
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
