//
//  PLTableViewController.h
//  plov.com
//
//  Created by v.kubyshev on 30/09/15.
//  Copyright © 2015 plov.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PLTableItemType_Alpha,
    PLTableItemType_Number,
    PLTableItemType_AlphaNumber,
    PLTableItemType_Phone,
    PLTableItemType_Email,
    PLTableItemType_ReadOnly,
    PLTableItemType_ReadOnlyRuble,
    PLTableItemType_ListItem,
    PLTableItemType_Complex,
} PLTableItemType;

typedef enum : NSUInteger {
    PLTableButtonMode_Continue,
    PLTableButtonMode_Save,
    PLTableButtonMode_SaveDelete,
    PLTableButtonMode_None,
} PLTableButtonMode;

@class PLTableViewController;
@class PLTableItem;
@class OrderObject;

typedef void (^PLFillDataBlock)(PLTableViewController * controller);
typedef void (^PLNextButtonBlock)(PLTableViewController * controller);
typedef void (^PLTrashButtonBlock)(PLTableViewController * controller);
typedef void (^PLItemSelectBlock)(PLTableViewController * controller, PLTableItem * item);

@interface PLTableItem : NSObject

@property (nonatomic, strong) NSString * itemId;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * placeholder;
@property (nonatomic, strong) NSString * text;
@property (nonatomic, strong) NSArray * blocks;
@property (nonatomic, assign) PLTableItemType type;
@property (nonatomic, assign) BOOL required;

+ (PLTableItem *)textItem:(NSString *)itemId withTitle:(NSString *)title
                     text:(NSString *)text required:(BOOL)requited type:(PLTableItemType)type;

+ (PLTableItem *)complexItem:(NSString *)itemId withTitle:(NSString *)title blocks:(NSArray *)blocks;

- (BOOL)valid;

@end

@interface PLTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UIButton *processButton;
@property (weak, nonatomic) IBOutlet UIImageView *cartIcon;
@property (weak, nonatomic) IBOutlet UILabel *backetSumLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) PLFillDataBlock fillDataBlock;
@property (copy, nonatomic) PLNextButtonBlock nextButtonBlock;
@property (copy, nonatomic) PLTrashButtonBlock trashButtonBlock;
@property (copy, nonatomic) PLItemSelectBlock itemSelectBlock;

@property (nonatomic, strong) NSArray * items;

@property (nonatomic, strong) OrderObject * order;

@property (nonatomic, assign) PLTableButtonMode buttonMode;

@property (nonatomic, copy) NSString * screenName;

+ (PLTableViewController *)instantiateFromStoryboard:(UIStoryboard *)storyboard;

- (IBAction)processToOrder:(id)sender;
@end
