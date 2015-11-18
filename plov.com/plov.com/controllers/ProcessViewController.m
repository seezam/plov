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
#import "OrderObject.h"
#import "PLCRMSupport.h"
#import "OrderItemObject.h"

@interface ProcessViewController ()
@property (nonatomic, assign) BOOL processed;
@end

@implementation ProcessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.infoLabel.layer.masksToBounds = YES;
    self.infoLabel.layer.cornerRadius = 10;
    self.doneButton.layer.cornerRadius = 10;
    
    self.orLabel.alpha = 0;
    self.orLabel.text = LOC(@"LOC_ORDER_OR_LABEL");
    
    self.callCenterButton.alpha = 0;
    self.callCenterButton.layer.cornerRadius = 10;
    [self.callCenterButton setTitle:LOC(@"LOC_ORDER_CALL") forState:UIControlStateNormal];
    
    [self.callCenterButton addTarget:self action:@selector(callCenterAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self createOrder];
    
    TAGDataLayer *dataLayer = [TAGManager instance].dataLayer;
    [dataLayer push:@{@"event": @"openScreen",          // Event, name of Open Screen Event.
                      @"screenName": @"Post Order"}];  // Name of the screen name field, screen name value.
}

- (void)createOrder
{
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    self.infoLabel.text = LOC(@"LOC_ORDER_PROCESSING");
    self.doneButton.enabled = NO;
    
    NSMutableDictionary * orderDict = [NSMutableDictionary dictionary];
    
    orderDict[@"firstName"] = SHARED_APP.customer.name;
    orderDict[@"phone"] = SHARED_APP.customer.phone;
    orderDict[@"contragentType"] = @"individual";
    orderDict[@"orderType"] = @"ios-app";
    
    NSMutableArray * orders = [NSMutableArray array];
    
    for (OrderItemObject * item in self.order.list)
    {
        NSDictionary * itemDesc = @{
                                    @"initialPrice": @(item.cost),
                                    @"purchasePrice": @(item.cost),
                                    @"productName": item.name,
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
    
    if (address.floor.length)
    {
        deliverTo[@"floor"] = address.floor;
    }
    
    orderDict[@"delivery"] = @{@"address": deliverTo};

    [SHARED_APP.crm createOrder:orderDict success:^(NSDictionary * resp) {
        if ([resp[@"id"] integerValue] > 0 &&
            [resp[@"success"] integerValue] == 1)
        {
            NSString * strId = [NSString stringWithFormat:@"%@", resp[@"id"]];
            
            AddressObject * address = SHARED_APP.customer.addresses.lastObject;
            [self.order updateOrderWithId:strId address:address.fullAddressString];
            
            [SHARED_APP.customer setLastOrder:self.order];
            [SHARED_APP.customer saveData];
            [SHARED_APP updateMenu];
            self.processed = YES;
            
            self.infoLabel.text = LOC(@"LOC_ORDER_CREATED");
            [self.doneButton setTitle:@"OK" forState:UIControlStateNormal];
            self.doneButton.enabled = YES;
            
            [FBSDKAppEvents logEvent:@"Puchased" valueToSum:self.order.cost];
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
    [self.navigationItem setHidesBackButton:NO animated:YES];
    
    self.infoLabel.text = LOC(@"LOC_ORDER_FAILED");
    [self.doneButton setTitle:LOC(@"LOC_ORDER_RETRY") forState:UIControlStateNormal];
    self.doneButton.enabled = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.orLabel.alpha = 1;
        self.callCenterButton.alpha = 1;
        self.callCenterButton.enabled = YES;
    }];
}

- (IBAction)doneClick:(id)sender {
    
    //TODO: save order
    if (self.processed)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            self.orLabel.alpha = 0;
            self.callCenterButton.alpha = 0;
            self.callCenterButton.enabled = NO;
        }];
        
        [self createOrder];
    }
}

- (void)callCenterAction
{
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",@"+74957897893"]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl])
    {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    }
}

@end
