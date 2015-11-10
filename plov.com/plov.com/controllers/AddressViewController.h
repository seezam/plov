//
//  AddressViewController.h
//  plov.com
//
//  Created by v.kubyshev on 06/08/15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLTableViewController.h"

@class AddressObject;

@interface AddressViewController : PLTableViewController

+ (PLTableViewController *)instantiateFromStoryboard:(UIStoryboard *)storyboard withAddress:(AddressObject*)address;

@end
