//
//  PLTableViewController.h
//  plov.com
//
//  Created by v.kubyshev on 30/09/15.
//  Copyright © 2015 plov.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PLTableItemType_Text,
    PLTableItemType_Phone,
} PLTableItemType;

@interface PLTableItem : NSObject

@property (nonatomic, strong) NSString * itemId;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * placeholder;
@property (nonatomic, strong) NSString * text;
@property (nonatomic, assign) PLTableItemType type;

@end

@interface PLTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray * items;

+ (instancetype)instantiateFromStoryboard:(UIStoryboard *)storyboard;

@end
