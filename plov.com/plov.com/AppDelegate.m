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
#import "MenuViewController.h"
#import "SWRevealViewController.h"

#import "CustomerObject.h"


@interface AppDelegate ()<UIAlertViewDelegate>



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

- (void)updateMenu
{
    MenuViewController * vc = (MenuViewController *)self.revealViewController.rearViewController;
    [vc reloadData];
    
    for (MenuCategoryObject * cat in self.menuData.categories)
    {
        for (MenuItemObject * item in cat.items)
        {
            item.count = 0;
        }
    }
    
    self.reinitialized = YES;
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
    
    NSInteger itemId = 0;
    
    MenuObject * obj = [[MenuObject alloc] init];
    
    MenuCategoryObject * cat1 = [[MenuCategoryObject alloc] initWithId:@"0"];
    [cat1 setTitle:@"Плов" forLng:@""];
    [obj addMenuCategory:cat1];
    
    MenuItemObject * item11 = [[MenuItemObject alloc] initWithId:@(++itemId).stringValue];
    [item11 setTitle:@"Плов «Чайханский»" forLng:@""];
    [item11 setDesc:@"Плов «Чайханский» Знаменитый узбекский плов из бараньей ножки с рисом «Лазер», желтой морковью, ароматным чесноком с добавлением «Зиры»." forLng:@""];
    [item11 setCost:390 forWeight:300];
    [cat1 addMenuItem:item11];
    
    MenuItemObject * item12 = [[MenuItemObject alloc] initWithId:@(++itemId).stringValue];
    [item12 setTitle:@"Плов «Праздничный»" forLng:@""];
    [item12 setDesc:@"Рис «Лазер», мясо барашка, желтая и красная морковь, горох «Нут», узбекский изюм с добавлением восточных специй." forLng:@""];
    [item12 setCost:350 forWeight:300];
    [cat1 addMenuItem:item12];
    
    MenuItemObject * item13 = [[MenuItemObject alloc] initWithId:@(++itemId).stringValue];
    [item13 setTitle:@"Плов «Вегетарианский»" forLng:@""];
    [item13 setDesc:@"Плов с овощами, длинозерновым рисом, горохом «Нут», молотой паприкой, барбарисом и сухофруктами." forLng:@""];
    [item13 setCost:370 forWeight:300];
    [cat1 addMenuItem:item13];
//-----------------
    MenuCategoryObject * cat2 = [[MenuCategoryObject alloc] initWithId:@"1"];
    [cat2 setTitle:@"Горячее" forLng:@""];
    [obj addMenuCategory:cat2];
    
    MenuItemObject * item21 = [[MenuItemObject alloc] initWithId:@(++itemId).stringValue];
    [item21 setTitle:@"Le Манты" forLng:@""];
    [item21 setDesc:@"Нежные, приготовленные на пару из рубленной сочной баранины, лука и ароматных специй. Подаются с мацони — кисломолочным соусом с зеленью." forLng:@""];
    [item21 setCost:370 forWeight:210];
    [cat2 addMenuItem:item21];
    
    MenuItemObject * item22 = [[MenuItemObject alloc] initWithId:@(++itemId).stringValue];
    [item22 setTitle:@"Жан-Клод Лагман" forLng:@""];
    [item22 setDesc:@"Настоящая домашняя лапша, сделанная вручную. С мякотью баранины, сельдереем, красным и жёлтым перцем, помидорами, луком и китайской капустой." forLng:@""];
    [item22 setCost:350 forWeight:300];
    [cat2 addMenuItem:item22];
//-----------------
    MenuCategoryObject * cat3 = [[MenuCategoryObject alloc] initWithId:@"2"];
    [cat3 setTitle:@"Закуски" forLng:@""];
    [obj addMenuCategory:cat3];
    
    MenuItemObject * item31 = [[MenuItemObject alloc] initWithId:@(++itemId).stringValue];
    [item31 setTitle:@"Говяжий язык" forLng:@""];
    [item31 setDesc:@"Нежный говяжий язык, варёный и нарезанный. Подаётся вместе со сливочным соусом на основе хрена."
             forLng:@""];
    [item31 setCost:270 forWeight:100];
    [cat3 addMenuItem:item31];
    
    MenuItemObject * item32 = [[MenuItemObject alloc] initWithId:@(++itemId).stringValue];
    [item32 setTitle:@"Перепелиные яйца" forLng:@""];
    [item32 setDesc:@"Отваренные диетические яйца перепела традиционно добавляются к плову как дополнительный ингредиент." forLng:@""];
    [item32 setCost:120 forWeight:70];
    [cat3 addMenuItem:item32];
    
    MenuItemObject * item33 = [[MenuItemObject alloc] initWithId:@(++itemId).stringValue];
    [item33 setTitle:@"Казы" forLng:@""];
    [item33 setDesc:@"Особый деликатес из конины, сваренный с добавлением ароматных приправ." forLng:@""];
    [item33 setCost:300 forWeight:100];
    [cat3 addMenuItem:item33];
//-----------------
    MenuCategoryObject * cat4 = [[MenuCategoryObject alloc] initWithId:@"3"];
    [cat4 setTitle:@"Соусы" forLng:@""];
    [obj addMenuCategory:cat4];
    
    MenuItemObject * item41 = [[MenuItemObject alloc] initWithId:@(++itemId).stringValue];
    [item41 setTitle:@"Пападжика" forLng:@""];
    [item41 setDesc:@"Острый соус на основе стручкового и болгарского перцев, томатов, укропа, чеснока и специй."
             forLng:@""];
    [item41 setCost:40 forWeight:30];
    [cat4 addMenuItem:item41];
    
    MenuItemObject * item42 = [[MenuItemObject alloc] initWithId:@(++itemId).stringValue];
    [item42 setTitle:@"Мамациони " forLng:@""];
    [item42 setDesc:@"Нежный кисломолочный соус в сочетании со свежей ароматной кинзой." forLng:@""];
    [item42 setCost:40 forWeight:50];
    [cat4 addMenuItem:item42];
    
    MenuItemObject * item43 = [[MenuItemObject alloc] initWithId:@(++itemId).stringValue];
    [item43 setTitle:@"Томатони" forLng:@""];
    [item43 setDesc:@"Ароматный томатный соус с болгарским перцем, чесноком, кинзой, укропом и специями." forLng:@""];
    [item43 setCost:40 forWeight:50];
    [cat4 addMenuItem:item43];
    
    MenuItemObject * item44 = [[MenuItemObject alloc] initWithId:@(++itemId).stringValue];
    [item44 setTitle:@"Нехреновый" forLng:@""];
    [item44 setDesc:@"Пикантный сливочный соус на основе хрена." forLng:@""];
    [item44 setCost:40 forWeight:30];
    [cat4 addMenuItem:item44];
    
//-----------------
    MenuCategoryObject * cat5 = [[MenuCategoryObject alloc] initWithId:@"4"];
    [cat5 setTitle:@"Салаты" forLng:@""];
    [obj addMenuCategory:cat5];
    
    MenuItemObject * item51 = [[MenuItemObject alloc] initWithId:@(++itemId).stringValue];
    [item51 setTitle:@"Морковь КимЧинИра" forLng:@""];
    [item51 setDesc:@"Тёртая сочная морковь, душистые специи, немного уксуса и растительного масла с добавлением чеснока и кориандра." forLng:@""];
    [item51 setCost:140 forWeight:100];
    [cat5 addMenuItem:item51];
    
    MenuItemObject * item52 = [[MenuItemObject alloc] initWithId:@(++itemId).stringValue];
    [item52 setTitle:@"Соленья MIX" forLng:@""];
    [item52 setDesc:@"Соленые красные помидоры с огурчиками и квашеной мелко рубленной капустой." forLng:@""];
    [item52 setCost:250 forWeight:250];
    [cat5 addMenuItem:item52];
    
    MenuItemObject * item53 = [[MenuItemObject alloc] initWithId:@(++itemId).stringValue];
    [item53 setTitle:@"i—Чучук" forLng:@""];
    [item53 setDesc:@"Тонко порезанные спелые ароматные помидоры, белый лук, вместе с нашинкованным зеленым базиликом — традиционный салат для плова." forLng:@""];
    [item53 setCost:150 forWeight:150];
    [cat5 addMenuItem:item53];
    
    MenuItemObject * item54 = [[MenuItemObject alloc] initWithId:@(++itemId).stringValue];
    [item54 setTitle:@"Салат Fresh" forLng:@""];
    [item54 setDesc:@"Ароматный огуречный салат со свежей кинзой, укропом, рубленым зеленым луком, с добавлением растительного масла и соли." forLng:@""];
    [item54 setCost:150 forWeight:150];
    [cat5 addMenuItem:item54];
    
//-----------------
    MenuCategoryObject * cat6 = [[MenuCategoryObject alloc] initWithId:@"5"];
    [cat6 setTitle:@"Выпечка" forLng:@""];
    [obj addMenuCategory:cat6];
    
    MenuItemObject * item61 = [[MenuItemObject alloc] initWithId:@(++itemId).stringValue];
    [item61 setTitle:@"Кутаб Пифагора с сыром" forLng:@""];
    [item61 setDesc:@"Бездрожжевое тесто с начинкой из сыра сулугуни и гауда, запечённое на огне, обмазанное сливочным маслом." forLng:@""];
    [item61 setCost:200 forWeight:130];
    [cat6 addMenuItem:item61];
    
    MenuItemObject * item62 = [[MenuItemObject alloc] initWithId:@(++itemId).stringValue];
    [item62 setTitle:@"Кутаб Пифагора с мясом" forLng:@""];
    [item62 setDesc:@"Мякоть говядины и специи, с добавлением приправ в запеченном без дрожжевом тесте и обмазанное сливочным маслом." forLng:@""];
    [item62 setCost:200 forWeight:130];
    [cat6 addMenuItem:item62];
    
    MenuItemObject * item63 = [[MenuItemObject alloc] initWithId:@(++itemId).stringValue];
    [item63 setTitle:@"Кутаб Пифагора с зеленью" forLng:@""];
    [item63 setDesc:@"Начинённый шпинатом и кинзой, с добавлением зелёного молодого лука и укропа. Приготовленный из бездрожжевого теста на огне." forLng:@""];
    [item63 setCost:200 forWeight:130];
    [cat6 addMenuItem:item63];
    
    MenuItemObject * item64 = [[MenuItemObject alloc] initWithId:@(++itemId).stringValue];
    [item64 setTitle:@"Самса с ягнятиной" forLng:@""];
    [item64 setDesc:@"Приготовленная по традиционному узбекскому рецепту, с начинкой из мелко рубленной баранины с добавлением лука и душистых специй в слоеном тесте." forLng:@""];
    [item64 setCost:180 forWeight:100];
    [cat6 addMenuItem:item64];

    MenuItemObject * item65 = [[MenuItemObject alloc] initWithId:@(++itemId).stringValue];
    [item65 setTitle:@"Самса с тыквой" forLng:@""];
    [item65 setDesc:@"Запеченное слоеное тесто с начинкой из ароматной тыквы, лука, с добавлением душистых специй."
             forLng:@""];
    [item65 setCost:160 forWeight:100];
    [cat6 addMenuItem:item65];
    
    MenuItemObject * item66 = [[MenuItemObject alloc] initWithId:@(++itemId).stringValue];
    [item66 setTitle:@"The Лепешка" forLng:@""];
    [item66 setDesc:@"Запеченное в тандыре пшеничное тесто на воде, украшенное кунжутом." forLng:@""];
    [item66 setCost:60 forWeight:100];
    [cat6 addMenuItem:item66];
//-----------------
    MenuCategoryObject * cat7 = [[MenuCategoryObject alloc] initWithId:@"6"];
    [cat7 setTitle:@"Сладости" forLng:@""];
    [obj addMenuCategory:cat7];
    
    MenuItemObject * item71 = [[MenuItemObject alloc] initWithId:@(++itemId).stringValue];
    [item71 setTitle:@"Варенье" forLng:@""];
    [item71 setDesc:@"Натуральное разнообразное плодово-ягодное варенье." forLng:@""];
    [item71 setCost:200 forWeight:430];
    [cat7 addMenuItem:item71];
    
    MenuItemObject * item72 = [[MenuItemObject alloc] initWithId:@(++itemId).stringValue];
    [item72 setTitle:@"Чак-Чак Норрис" forLng:@""];
    [item72 setDesc:@"Восточное лакомство приготовленное в сочетании замешанного теста на яйцах, сахаре, масле и медовой обливки." forLng:@""];
    [item72 setCost:180 forWeight:200];
    [cat7 addMenuItem:item72];
//-----------------
    MenuCategoryObject * cat8 = [[MenuCategoryObject alloc] initWithId:@"7"];
    [cat8 setTitle:@"Напитки" forLng:@""];
    [obj addMenuCategory:cat8];
    
    MenuItemObject * item81 = [[MenuItemObject alloc] initWithId:@(++itemId).stringValue];
    [item81 setTitle:@"Компоты Х.О." forLng:@""];
    [item81 setDesc:@"Разнообразные компоты с ягодами и плодами с чудесным ароматом и вкусом." forLng:@""];
    [item81 setCost:180 forLitres:1];
    [cat8 addMenuItem:item81];
    
    obj.minimalCost = 1500;
    
    return obj;
}

- (void)updateApplication
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil
                                                     message:LOC(@"LOC_MINIMAL_VER") delegate:self cancelButtonTitle:LOC(@"UPDATE_ACTION") otherButtonTitles:nil];
    
    alert.tag = 100;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100)
    {
        NSURL *appStoreURL = [NSURL URLWithString:@"http://appstore.com/plovcom"];
        [[UIApplication sharedApplication] openURL:appStoreURL];
    }
}

- (BOOL)checkForAppVersion
{
    NSData * str = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://plov.com/apps.php"] options:0 error:nil];
    
    NSDictionary * json = [NSJSONSerialization JSONObjectWithData:str options:0 error:nil];
    
    if (json.count)
    {
        NSInteger minBuild = [json[@"min-ios-build-number"] integerValue];
        
        NSInteger appBuild = [[[NSBundle mainBundle] infoDictionary][(NSString *)kCFBundleVersionKey] integerValue];
        
        return (appBuild >= minBuild);
    }
    
    return YES;
}

- (void)startApplication:(UIView *)fromView
{
    self.crm = [[PLCRMSupport alloc] init];
    self.customer = [[CustomerObject alloc] init];
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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    /*
    [Intercom setApiKey:@"ios_sdk-2c950ea4e4e800c40c04cfbfaca8655046b7ee58" forAppId:@"dsdu3hzw"];
    
    [Intercom registerUnidentifiedUser];
    
    [Intercom setPreviewPosition:ICMPreviewPositionTopLeft];
    [Intercom setPreviewPaddingWithX:9 y:100];
    */
    
    self.tracking = [[PLTracking alloc] initAtStart:launchOptions];
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]){ // iOS 8 (User notifications)
        [application registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:
          (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)
                                           categories:nil]];
        [application registerForRemoteNotifications];
    } else { // iOS 7 (Remote notifications)
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationType)(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    return [self.tracking FBOpenURL:url sourceApplication:sourceApplication annotation:annotation];
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
    
    [self.tracking FBActivateApp];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    [Intercom setDeviceToken:deviceToken];
    NSLog(@"My token is: %@", deviceToken);
    
    [self.tracking ParseRegisterPush:deviceToken];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self.tracking ParseHandlePush:userInfo];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

@end
