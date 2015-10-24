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

#import "PLCRMSupport.h"
#import "CustomerObject.h"

@import Intercom;

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

- (void)updateMenu
{
    MenuViewController * vc = (MenuViewController *)self.revealViewController.rearViewController;
    [vc reloadData];
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
    
    MenuItemObject * item11 = [[MenuItemObject alloc] initWithId:@"1"];
    [item11 setTitle:@"Плов «Чайханский»" forLng:@""];
    [item11 setDesc:@"Плов «Чайханский» Знаменитый узбекский плов из бараньей ножки с рисом «Лазер», желтой морковью, ароматным чесноком с добавлением «Зиры»." forLng:@""];
    [item11 setCost:390 forWeight:300];
    [cat1 addMenuItem:item11];
    
    MenuItemObject * item12 = [[MenuItemObject alloc] initWithId:@"2"];
    [item12 setTitle:@"Плов «Праздничный»" forLng:@""];
    [item12 setDesc:@"Рис «Лазер», мясо барашка, желтая и красная морковь, горох «Нут», узбекский изюм с добавлением восточных специй." forLng:@""];
    [item12 setCost:350 forWeight:300];
    [cat1 addMenuItem:item12];
    
    MenuItemObject * item13 = [[MenuItemObject alloc] initWithId:@"3"];
    [item13 setTitle:@"Плов «Вегетарианский»" forLng:@""];
    [item13 setDesc:@"Плов с овощами, длинозерновым рисом, горохом «Нут», молотой паприкой, барбарисом и сухофруктами." forLng:@""];
    [item13 setCost:370 forWeight:300];
    [cat1 addMenuItem:item13];
//-----------------
    MenuCategoryObject * cat2 = [[MenuCategoryObject alloc] initWithId:@"1"];
    [cat2 setTitle:@"Горячее" forLng:@""];
    [obj addMenuCategory:cat2];
    
    MenuItemObject * item21 = [[MenuItemObject alloc] initWithId:@"4"];
    [item21 setTitle:@"Le Манты" forLng:@""];
    [item21 setDesc:@"Нежные, приготовленные на пару из рубленной сочной баранины, лука и ароматных специй. Подаются с мацони — кисломолочным соусом с зеленью." forLng:@""];
    [item21 setCost:350 forWeight:0];
    [cat2 addMenuItem:item21];
    
    MenuItemObject * item22 = [[MenuItemObject alloc] initWithId:@"5"];
    [item22 setTitle:@"Жан-Клод Лагман" forLng:@""];
    [item22 setDesc:@"Настоящая домашняя лапша, сделанная вручную. С мякотью баранины и морковью, сельдереем, красным и желтым перцем, помидорами и луком, кенийской фасолью и китайской капустой." forLng:@""];
    [item22 setCost:350 forWeight:0];
    [cat2 addMenuItem:item22];
    
    MenuItemObject * item23 = [[MenuItemObject alloc] initWithId:@"6"];
    [item23 setTitle:@"Казантип-Кебаб" forLng:@""];
    [item23 setDesc:@"Нежная баранья корейка, томленная в казане с молодым запеченным картофелем и ароматными специями." forLng:@""];
    [item23 setCost:550 forWeight:0];
    [cat2 addMenuItem:item23];
//-----------------
    MenuCategoryObject * cat3 = [[MenuCategoryObject alloc] initWithId:@"2"];
    [cat3 setTitle:@"Закуски" forLng:@""];
    [obj addMenuCategory:cat3];
    
    MenuItemObject * item31 = [[MenuItemObject alloc] initWithId:@"7"];
    [item31 setTitle:@"Говяжий язык" forLng:@""];
    [item31 setDesc:@"Нежнейший говяжий язык, вареный и нарезанный. Подается вместе с соусом на основе хрена." forLng:@""];
    [item31 setCost:250 forWeight:0];
    [cat3 addMenuItem:item31];
    
    MenuItemObject * item32 = [[MenuItemObject alloc] initWithId:@"8"];
    [item32 setTitle:@"Перепелиные яйца" forLng:@""];
    [item32 setDesc:@"Отваренные диетические яйца перепела традиционно добавляются к плову как дополнительный ингредиент." forLng:@""];
    [item32 setCost:130 forWeight:0];
    [cat3 addMenuItem:item32];
    
    MenuItemObject * item33 = [[MenuItemObject alloc] initWithId:@"9"];
    [item33 setTitle:@"Казы" forLng:@""];
    [item33 setDesc:@"Особый деликатес, сваренный с добавлением ароматных приправах и мяса конины." forLng:@""];
    [item33 setCost:280 forWeight:0];
    [cat3 addMenuItem:item33];
//-----------------
    MenuCategoryObject * cat4 = [[MenuCategoryObject alloc] initWithId:@"3"];
    [cat4 setTitle:@"Салаты" forLng:@""];
    [obj addMenuCategory:cat4];
    
    MenuItemObject * item41 = [[MenuItemObject alloc] initWithId:@"10"];
    [item41 setTitle:@"Морковь по корейски" forLng:@""];
    [item41 setDesc:@"Тертая свежая сочная морковь и душистые специи, растительное масло и немного уксуса с добавлением чеснока и кориандра." forLng:@""];
    [item41 setCost:120 forWeight:0];
    [cat4 addMenuItem:item41];
    
    MenuItemObject * item42 = [[MenuItemObject alloc] initWithId:@"11"];
    [item42 setTitle:@"Соленья MIX" forLng:@""];
    [item42 setDesc:@"Малосольные огурчики и помидоры с мелкорубленой соленой капустой." forLng:@""];
    [item42 setCost:250 forWeight:0];
    [cat4 addMenuItem:item42];
    
    MenuItemObject * item43 = [[MenuItemObject alloc] initWithId:@"12"];
    [item43 setTitle:@"Свекла с орехами" forLng:@""];
    [item43 setDesc:@"Вареная и натертая свекла с добавлением грецкого ореха и сметанным соусом." forLng:@""];
    [item43 setCost:150 forWeight:0];
    [cat4 addMenuItem:item43];
    
    MenuItemObject * item44 = [[MenuItemObject alloc] initWithId:@"13"];
    [item44 setTitle:@"i—Чучук" forLng:@""];
    [item44 setDesc:@"Тонко порезанные спелые ароматные помидоры, белый лук, вместе с нашинкованным зеленым базиликом — традиционный салат для плова." forLng:@""];
    [item44 setCost:150 forWeight:0];
    [cat4 addMenuItem:item44];
    
    MenuItemObject * item45 = [[MenuItemObject alloc] initWithId:@"14"];
    [item45 setTitle:@"Помидоры & Огурцы" forLng:@""];
    [item45 setDesc:@"Классический свежий салат из помидоров, огурцов и порезанной душистой зелени, с добавлением специй и оливкового масла." forLng:@""];
    [item45 setCost:170 forWeight:0];
    [cat4 addMenuItem:item45];
//-----------------
    MenuCategoryObject * cat5 = [[MenuCategoryObject alloc] initWithId:@"4"];
    [cat5 setTitle:@"Выпечка" forLng:@""];
    [obj addMenuCategory:cat5];
    
    MenuItemObject * item51 = [[MenuItemObject alloc] initWithId:@"15"];
    [item51 setTitle:@"Кутаб Пифагора с сыром" forLng:@""];
    [item51 setDesc:@"Без дрожжевое тесто с начинкой из сыра сулугуни и гауда, запеченное на огне, обмазанное сливочным маслом." forLng:@""];
    [item51 setCost:150 forWeight:0];
    [cat5 addMenuItem:item51];
    
    MenuItemObject * item52 = [[MenuItemObject alloc] initWithId:@"16"];
    [item52 setTitle:@"Кутаб Пифагора с мясом" forLng:@""];
    [item52 setDesc:@"Мякоть говядины и специи, с добавлением приправ в запеченном без дрожжевом тесте и обмазанное сливочным маслом." forLng:@""];
    [item52 setCost:150 forWeight:0];
    [cat5 addMenuItem:item52];
    
    MenuItemObject * item53 = [[MenuItemObject alloc] initWithId:@"17"];
    [item53 setTitle:@"Кутаб Пифагора с зеленью" forLng:@""];
    [item53 setDesc:@"Начиненное шпинатом и кинзой, с добавлением побегов молодого лука и укропа. Приготовленный из бездрожжевого теста на огне." forLng:@""];
    [item53 setCost:150 forWeight:0];
    [cat5 addMenuItem:item53];
    
    MenuItemObject * item54 = [[MenuItemObject alloc] initWithId:@"18"];
    [item54 setTitle:@"Самса с ягнятиной" forLng:@""];
    [item54 setDesc:@"Приготовленная по традиционному узбекскому рецепту, с начинкой из мелко рубленной баранины с добавлением лука и душистых специй в слоеном тесте." forLng:@""];
    [item54 setCost:180 forWeight:0];
    [cat5 addMenuItem:item54];

    MenuItemObject * item55 = [[MenuItemObject alloc] initWithId:@"19"];
    [item55 setTitle:@"Самса с тыквой" forLng:@""];
    [item55 setDesc:@"Запеченное слоеное тесто с начинкой из ароматной тыквы, лука, с добавлением душистых специй." forLng:@""];
    [item55 setCost:160 forWeight:0];
    [cat5 addMenuItem:item55];
    
    MenuItemObject * item56 = [[MenuItemObject alloc] initWithId:@"20"];
    [item56 setTitle:@"The Лепешка" forLng:@""];
    [item56 setDesc:@"Запеченное в тандыре пшеничное тесто на воде, украшенное кунжутом." forLng:@""];
    [item56 setCost:60 forWeight:0];
    [cat5 addMenuItem:item56];
//-----------------
    MenuCategoryObject * cat6 = [[MenuCategoryObject alloc] initWithId:@"5"];
    [cat6 setTitle:@"Сладости" forLng:@""];
    [obj addMenuCategory:cat6];
    
    MenuItemObject * item61 = [[MenuItemObject alloc] initWithId:@"21"];
    [item61 setTitle:@"Восточный MIX" forLng:@""];
    [item61 setDesc:@"Сладкое ассорти из нескольких видов халвы и сливочно-орехового щербета." forLng:@""];
    [item61 setCost:100 forWeight:0];
    [cat6 addMenuItem:item61];
    
    MenuItemObject * item62 = [[MenuItemObject alloc] initWithId:@"22"];
    [item62 setTitle:@"Варенье" forLng:@""];
    [item62 setDesc:@"Натуральное разнообразное плодово-ягодное варенье." forLng:@""];
    [item62 setCost:200 forWeight:0];
    [cat6 addMenuItem:item62];
    
    MenuItemObject * item63 = [[MenuItemObject alloc] initWithId:@"23"];
    [item63 setTitle:@"Чак-Чак Норрис" forLng:@""];
    [item63 setDesc:@"Восточное лакомство приготовленное в сочетании замешанного теста на яйцах, сахаре, масле и медовой обливки." forLng:@""];
    [item63 setCost:60 forWeight:0];
    [cat6 addMenuItem:item63];
    
    MenuItemObject * item64 = [[MenuItemObject alloc] initWithId:@"24"];
    [item64 setTitle:@"Цукаты в глазури" forLng:@""];
    [item64 setDesc:@"Необычные конфеты с цукатами в различной цветной глазури." forLng:@""];
    [item64 setCost:250 forWeight:0];
    [cat6 addMenuItem:item64];
    
    MenuItemObject * item65 = [[MenuItemObject alloc] initWithId:@"25"];
    [item65 setTitle:@"ИнФиники" forLng:@""];
    [item65 setDesc:@"Королевские большие финики, очень вкусные, высушенные естественным способом." forLng:@""];
    [item65 setCost:250 forWeight:0];
    [cat6 addMenuItem:item65];
    
    MenuItemObject * item66 = [[MenuItemObject alloc] initWithId:@"26"];
    [item66 setTitle:@"Сухофрукты MIX" forLng:@""];
    [item66 setDesc:@"Разнообразные полезные сухофрукты с изюмом, медовой и шоколадной курагой." forLng:@""];
    [item66 setCost:300 forWeight:0];
    [cat6 addMenuItem:item66];
    
    MenuItemObject * item67 = [[MenuItemObject alloc] initWithId:@"27"];
    [item67 setTitle:@"Орехи MIX" forLng:@""];
    [item67 setDesc:@"Смесь орехов пекан, фундука и грецкого ореха, кешью и миндаля." forLng:@""];
    [item67 setCost:300 forWeight:0];
    [cat6 addMenuItem:item67];
//-----------------
    MenuCategoryObject * cat7 = [[MenuCategoryObject alloc] initWithId:@"6"];
    [cat7 setTitle:@"Напитки" forLng:@""];
    [obj addMenuCategory:cat7];
    
    MenuItemObject * item71 = [[MenuItemObject alloc] initWithId:@"28"];
    [item71 setTitle:@"Компоты Х.О." forLng:@""];
    [item71 setDesc:@"Разнообразные компоты с ягодами и плодами с чудесным ароматом и вкусом." forLng:@""];
    [item71 setCost:180 forWeight:0];
    [cat7 addMenuItem:item71];
    
    return obj;
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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [Intercom setApiKey:@"ios_sdk-2c950ea4e4e800c40c04cfbfaca8655046b7ee58" forAppId:@"dsdu3hzw"];
    
    [Intercom registerUnidentifiedUser];
    
    [Intercom setPreviewPosition:ICMPreviewPositionTopLeft];
    [Intercom setPreviewPaddingWithX:9 y:100];
    
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
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [Intercom setDeviceToken:deviceToken];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

@end
