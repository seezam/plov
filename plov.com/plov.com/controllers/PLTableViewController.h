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
    PLTableItemType_Number,
    PLTableItemType_Phone,
    PLTableItemType_Email,
    PLTableItemType_ReadOnly,
} PLTableItemType;

@class PLTableViewController;

typedef void (^PLNextBlock)(PLTableViewController * controller);

@interface PLTableItem : NSObject

@property (nonatomic, strong) NSString * itemId;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * placeholder;
@property (nonatomic, strong) NSString * text;
@property (nonatomic, assign) PLTableItemType type;
@property (nonatomic, assign) BOOL required;

+ (PLTableItem *)textItem:(NSString *)itemId withTitle:(NSString *)title
                     text:(NSString *)text required:(BOOL)requited type:(PLTableItemType)type;

@end

@interface PLTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UIButton *processButton;
@property (weak, nonatomic) IBOutlet UIImageView *cartIcon;
@property (weak, nonatomic) IBOutlet UILabel *backetSumLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) PLNextBlock nextBlock;

@property (nonatomic, strong) NSArray * items;

@property (nonatomic, assign) NSInteger bucketSum;
@property (nonatomic, strong) NSArray * order;

@property (nonatomic, assign) BOOL editMode;

+ (PLTableViewController *)instantiateFromStoryboard:(UIStoryboard *)storyboard;

- (IBAction)processToOrder:(id)sender;
@end
