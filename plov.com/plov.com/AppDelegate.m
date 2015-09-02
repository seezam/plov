//
//  AppDelegate.m
//  plov.com
//
//  Created by Vladimir Kubyshev on 02.08.15.
//  Copyright (c) 2015 plov.com. All rights reserved.
//

#import "AppDelegate.h"

#import "AFNetworkReachabilityManager.h"

#import "MenuObject.h"
#import "MenuCategoryObject.h"
#import "MenuItemObject.h"

#import "MainViewController.h"
#import "SWRevealViewController.h"

#import "PLCRMSupport.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


+ (AppDelegate *)app
{
    return [[UIApplication sharedApplication] delegate];
}

- (SWRevealViewController *)revealViewController
{
    if ([self.window.rootViewController isKindOfClass:[SWRevealViewController class]])
    {
        return (SWRevealViewController *)self.window.rootViewController;
    }
    return nil;
}

- (MenuObject *)loadData
{
//    NSString * data = @"\
//    {\"status\" : {\"code\" : 20000}, \
//    \"categories\" : [ \
//    { \
//        \"title\": \"Plov\", \
//        \"id\" : 0, \
//        \"items\" : [] \
//    }, \
//    { \
//        \"title\": \"Salad\", \
//        \"id\" : 1, \
//        \"items\" : [] \
//    }, \
//    { \
//        \"title\": \"Samsa\", \
//        \"id\" : 2, \
//        \"items\" : [] \
//    }, \
//    { \
//        \"title\": \"Bread\", \
//        \"id\" : 3, \
//        \"items\" : [] \
//    }, \
//    { \
//        \"title\": \"Sweats\", \
//        \"id\" : 4, \
//        \"items\" : [] \
//    }, \
//    { \
//        \"title\": \"Other\", \
//        \"id\" : 5, \
//        \"items\" : [] \
//    } \
//                    ]}\
//    ";
//    
//    MenuObject * obj = [[MenuObject alloc] initWithData:[NSData dataWithBytes:data.UTF8String length:data.length]];
    
    MenuObject * obj = [[MenuObject alloc] init];
    
    MenuCategoryObject * cat1 = [[MenuCategoryObject alloc] initWithId:@"0"];
    [cat1 setTitle:@"Плов" forLng:@""];
    [obj addMenuCategory:cat1];
    
    MenuItemObject * item11 = [[MenuItemObject alloc] initWithId:@"0"];
    [item11 setTitle:@"Плов «Чайханский»" forLng:@""];
    [item11 setDesc:@"Плов «Чайханский» Знаменитый узбекский плов из бараньей ножки с рисом «Лазер», желтой морковью, ароматным чесноком с добавлением «Зиры»." forLng:@""];
    [item11 setCost:390 forWeight:300];
    [cat1 addMenuItem:item11];
    
    MenuItemObject * item12 = [[MenuItemObject alloc] initWithId:@"1"];
    [item12 setTitle:@"Плов «Праздничный»" forLng:@""];
    [item12 setDesc:@"Рис «Лазер», мясо барашка, желтая и красная морковь, горох «Нут», узбекский изюм с добавлением восточных специй." forLng:@""];
    [item12 setCost:350 forWeight:300];
    [cat1 addMenuItem:item12];
    
    MenuItemObject * item13 = [[MenuItemObject alloc] initWithId:@"2"];
    [item13 setTitle:@"Плов «Вегетарианский»" forLng:@""];
    [item13 setDesc:@"Плов с овощами, длинозерновым рисом, горохом «Нут», молотой паприкой, барбарисом и сухофруктами." forLng:@""];
    [item13 setCost:370 forWeight:300];
    [cat1 addMenuItem:item13];
    
    MenuCategoryObject * cat2 = [[MenuCategoryObject alloc] initWithId:@"1"];
    [cat2 setTitle:@"Салат" forLng:@""];
    [obj addMenuCategory:cat2];
    
    MenuItemObject * item21 = [[MenuItemObject alloc] initWithId:@"0"];
    [item21 setTitle:@"Салат «Ачичук»" forLng:@""];
    [item21 setDesc:@"«Ачичук» богат витаминами и кислотами, повышающими иммунитет и улучшающими обмен веществ – солоноватая cмесь лукового и помидорного сока." forLng:@""];
    [item21 setCost:150 forWeight:150];
    [cat2 addMenuItem:item21];
    
    MenuCategoryObject * cat3 = [[MenuCategoryObject alloc] initWithId:@"2"];
    [cat3 setTitle:@"Самса" forLng:@""];
    [obj addMenuCategory:cat3];
    
    MenuItemObject * item31 = [[MenuItemObject alloc] initWithId:@"0"];
    [item31 setTitle:@"Самса с мясом" forLng:@""];
    [item31 setDesc:@"Приготовленная по традиционному узбекскому рецепту, с начинкой из мелко рубленной баранины с добавлением лука и восточных специй." forLng:@""];
    [item31 setCost:180 forWeight:100];
    [cat3 addMenuItem:item31];
    
    MenuItemObject * item32 = [[MenuItemObject alloc] initWithId:@"0"];
    [item32 setTitle:@"Самса с тыквой" forLng:@""];
    [item32 setDesc:@"Приготовленная по старинному узбекскому рецепту, с начинкой из тыквы с добавлением лука и восточных специй." forLng:@""];
    [item32 setCost:160 forWeight:100];
    [cat3 addMenuItem:item32];
    
    MenuCategoryObject * cat4 = [[MenuCategoryObject alloc] initWithId:@"3"];
    [cat4 setTitle:@"Хлеб" forLng:@""];
    [obj addMenuCategory:cat4];
    
    MenuItemObject * item41 = [[MenuItemObject alloc] initWithId:@"0"];
    [item41 setTitle:@"Узбекская лепешка" forLng:@""];
    [item41 setDesc:@"Запеченная в «Тандыре», пшеничное тесто на воде, украшенное кунжутом." forLng:@""];
    [item41 setCost:60 forWeight:100];
    [cat4 addMenuItem:item41];
    
    MenuCategoryObject * cat5 = [[MenuCategoryObject alloc] initWithId:@"4"];
    [cat5 setTitle:@"Сладкое" forLng:@""];
    [obj addMenuCategory:cat5];
    
    MenuItemObject * item51 = [[MenuItemObject alloc] initWithId:@"0"];
    [item51 setTitle:@"Чак-Чак Норис" forLng:@""];
    [item51 setDesc:@"Восточное лакомство, удивит самых отчаянных и искушенных сладкоежек." forLng:@""];
    [item51 setCost:200 forWeight:200];
    [cat5 addMenuItem:item51];
    
    MenuItemObject * item52 = [[MenuItemObject alloc] initWithId:@"0"];
    [item52 setTitle:@"Варенье" forLng:@""];
    [item52 setDesc:@"Традиционный ароматный десерт, которым так приятно побаловать себя за чашечкой вечернего чая – это, конечно же, вкусное варенье." forLng:@""];
    [item52 setCost:200 forWeight:470];
    [cat5 addMenuItem:item52];
    
    MenuCategoryObject * cat6 = [[MenuCategoryObject alloc] initWithId:@"5"];
    [cat6 setTitle:@"Напитки" forLng:@""];
    [obj addMenuCategory:cat6];
    
    MenuItemObject * item61 = [[MenuItemObject alloc] initWithId:@"0"];
    [item61 setTitle:@"Компот" forLng:@""];
    [item61 setDesc:@"Ароматный компот из самых спелых фруктов и ягод добавит организму энергии, улучшит настроение и порадует изумительным вкусом." forLng:@""];
    [item61 setCost:180 forWeight:1000];
    [cat6 addMenuItem:item61];
    
    return obj;
}

- (void)startApplication:(UIView *)fromView
{
    self.crm = [[PLCRMSupport alloc] init];
    
    self.menuData = [self loadData];
    
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SWRevealViewController *viewControllerToBeShown = [storyBoard instantiateViewControllerWithIdentifier:@"beginViewController"];
    [SHARED_APP.window addSubview:viewControllerToBeShown.view];
    viewControllerToBeShown.view.alpha = 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        fromView.alpha = 0;
        viewControllerToBeShown.view.alpha = 1;
    } completion:^(BOOL finished) {
        self.window.rootViewController = viewControllerToBeShown;
    }];
}

- (void)informNetworkIssue
{
    
}

- (NSAttributedString *)rubleCost:(NSInteger)cost font:(UIFont *)font
{
    UIFont * rubFont = [UIFont fontWithName:@"ALS Rubl" size:font.pointSize];
    
    NSAttributedString * rubString = [[NSAttributedString alloc] initWithString:@"i"
                                                                      attributes:@{NSFontAttributeName: rubFont}];
    
    NSString * priceString = [@(cost).stringValue stringByAppendingString:@" "];
    
    NSAttributedString * costString = [[NSAttributedString alloc] initWithString:priceString
                                                                      attributes:@{NSFontAttributeName: font}];
    
    NSMutableAttributedString * result = [[NSMutableAttributedString alloc] initWithAttributedString:costString];
    [result appendAttributedString:rubString];
    
    return result;
}

#pragma mark - delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

@end
