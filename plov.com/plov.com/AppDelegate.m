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

#import "OrderObject.h"
#import "OrderItemObject.h"

NSString * kRemoteInfoBuildNumber = @"min-ios-build-number";
NSString * kRemoteInfoMinimalCost = @"minimal-cost";
NSString * kRemoteInfoFreeDeliveryCost = @"free-delivery-cost";
NSString * kRemoteInfoDeliveryCost = @"delivery-cost";
NSString * kRemoteInfoUpdateURL = @"ios-update-url";
NSString * kRemoteInfoCallcenterNumber = @"callcenter_number";


@interface AppDelegate ()<UIAlertViewDelegate>

@end

@implementation AppDelegate


+ (AppDelegate *)app
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (SWRevealViewController *)revealViewController
{
    if ([self.window.rootViewController isKindOfClass:[SWRevealViewController class]])
    {
        return (SWRevealViewController *)self.window.rootViewController;
    }
    return nil;
}

- (void)resetMenuToOrder:(OrderObject *)order
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
    
    if (order)
    {
        for (OrderItemObject * oi in order.list)
        {
            MenuItemObject * item = [self.menuData itemById:oi.itemId];
            item.count = oi.count;
        }
    }
    
    self.reinitialized = YES;
}

- (MenuItemObject *)itemObjectWithTitles:(NSDictionary *)titles descriptions:(NSDictionary *)descriptions cost:(NSInteger)cost weight:(NSInteger)weight withId:(NSInteger)objectId
{
    MenuItemObject * item = [[MenuItemObject alloc] initWithId:@(objectId).stringValue];
    
    for (NSString * key in titles.allKeys)
    {
        [item setTitle:titles[key] forLng:key];
    }
    
    for (NSString * key in descriptions.allKeys)
    {
        [item setDesc:descriptions[key] forLng:key];
    }
    [item setCost:cost forWeight:weight];
    
    return item;
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
    NSInteger catId = 0;
    
    MenuObject * obj = [[MenuObject alloc] init];
    
    MenuCategoryObject * cat = [[MenuCategoryObject alloc] initWithId:@(catId++).stringValue];
    [cat setTitle:@"Горячее" forLng:@"ru"];
    [cat setTitle:@"Main Courses" forLng:@"en"];
    [obj addMenuCategory:cat];
    
    MenuItemObject * item = [self itemObjectWithTitles:@{@"ru": @"Плов «Праздничный»",
                                                        @"en": @"Prazdnichnyy Plov"}
                                          descriptions:@{@"ru": @"Рис лазер, мясо барашка, желтая и красная морковь, горох нут, узбекский темный изюм с добавлением восточных специй.",
                                                         @"en": @"Lamb, lazer rice, yellow and red carrots, chickpeas, with dark Uzbek raisins and oriental spices."}
                                                  cost:330
                                                weight:250
                                                withId:++itemId];
    [item setImageId:1];
    [cat addMenuItem:item];
    
    item = [self itemObjectWithTitles:@{@"ru": @"Плов «Вегетарианский»",
                                        @"en": @"Vegetarian Plov"}
                         descriptions:@{@"ru": @"Приготовленный на масле из виноградных косточек, с добавлением кураги и чернослива. Рис лазер, лук, жёлтая и красная морковь с душистыми специями.",
                                        @"en": @"Lazer rice, onions, yellow and red carrots with spices, dried apricots and prunes. Cooked with grape seed oil."}
                                 cost:330
                               weight:250
                               withId:++itemId];
    [item setImageId:2];
    [cat addMenuItem:item];
    
    item = [self itemObjectWithTitles:@{@"ru": @"Плов «Чайханский»",
                                        @"en": @"Chaykhansky Plov"}
                         descriptions:@{@"ru": @"Традиционный узбекский плов из бараньей ножки с рисом лазер, жёлтой и красной морковью, ароматным чесноком и с добавлением зиры.",
                                        @"en": @"Traditional Uzbek plov with lamb, lazer rice, yellow and red carrots, spiced with garlic and cumin."}
                                 cost:330
                               weight:250
                               withId:++itemId];
    [item setImageId:3];
    [cat addMenuItem:item];
    
    item = [self itemObjectWithTitles:@{@"ru": @"Плов Chicken",
                                        @"en": @"Chicken Plov"}
                         descriptions:@{@"ru": @"Легкий и нежный плов, приготовленный из сочного куриного мяса, риса, красной и жёлтой моркови с ароматными специями.",
                                        @"en": @"Light and tender plov, made with juicy chicken meat, rice, yellow and red carrots, and flavorful spices."}
                                 cost:300
                               weight:250
                               withId:++itemId];
    [item setImageId:4];
    [cat addMenuItem:item];
    
    item = [self itemObjectWithTitles:@{@"ru": @"Жан-Клод Лагман",
                                        @"en": @"Jean-Claude Laghman"}
                         descriptions:@{@"ru": @"Настоящая домашняя лапша, сделанная вручную. С мякотью баранины, сельде- реем, красным и жёлтым перцем, томатами, луком и китайской капустой. Подаются с острым соусом Пападжика.",
                                        @"en": @"Homemade noodles with juicy lamb meat, celery, yellow and red carrots, tomatoes, onions and bok choy."}
                                 cost:320
                               weight:300
                               withId:++itemId];
    [item setImageId:5];
    [cat addMenuItem:item];
    
    item = [self itemObjectWithTitles:@{@"ru": @"Le Манты с бараниной",
                                        @"en": @"Le Manty"}
                         descriptions:@{@"ru": @"Нежные, приготовленные на пару из рубленой сочной баранины, лука и ароматных специй. Подаются с соусом Мамацони.",
                                        @"en": @"Tender steamed manty with succulent lamb, onions and spices. Served with matzoon – a yogurt sauce with herbs."}
                                 cost:380
                               weight:210
                               withId:++itemId];
    [item setImageId:6];
    [cat addMenuItem:item];
    
    item = [self itemObjectWithTitles:@{@"ru": @"Le Манты с говядиной",
                                        @"en": @"Le Manty with beef"}
                         descriptions:@{@"ru": @"Аппетитные манты, приготовленные на пару с мякотью говядины, репчатым луком, специями и соусом Мамацони.",
                                        @"en": @"Mouth-watering steamed manty with tender beef, onions and spices. Served with Mamatsioni sauce."}
                                 cost:380
                               weight:210
                               withId:++itemId];
    [item setImageId:7];
    [cat addMenuItem:item];
    
    item = [self itemObjectWithTitles:@{@"ru": @"Le Манты с картофелем",
                                        @"en": @"Le Manty with potatoes"}
                         descriptions:@{@"ru": @"Сочные манты, приготовленные на пару, с рубленым кубиками картофелем, репчатым луком и специями. Подаются со сметаной.",
                                        @"en": @"Juicy steamed manty with minced potatoes, onions and spices. Served with sour cream."}
                                 cost:300
                               weight:210
                               withId:++itemId];
    [item setImageId:8];
    [cat addMenuItem:item];
    
    item = [self itemObjectWithTitles:@{@"ru": @"Le Манты с тыквой",
                                        @"en": @"Pumpkin Le Manty"}
                         descriptions:@{@"ru": @"Ароматные манты, приготовленные на пару, с начинкой из тыквы с добавлением специй. Подаются со сметаной.",
                                        @"en": @"Delicious steamed manty with seasoned pumpkin filling. Served with sour cream."}
                                 cost:300
                               weight:210
                               withId:++itemId];
    [item setImageId:9];
    [cat addMenuItem:item];
    
//-----------------
    cat = [[MenuCategoryObject alloc] initWithId:@(catId++).stringValue];
    [cat setTitle:@"Супы" forLng:@"ru"];
    [cat setTitle:@"Soups" forLng:@"en"];
    [obj addMenuCategory:cat];
    
    item = [self itemObjectWithTitles:@{@"ru": @"Тыквенный крем-суп",
                                        @"en": @"Pumpkin cream soup"}
                         descriptions:@{@"ru": @"Нежный крем-суп из ароматной тыквы с добавлением сливок, репчатого лука и порции поджареных сухариков.",
                                        @"en": @"Delicate pumpkin cream soup. Made with cream, onions and served with croutons."}
                                 cost:230
                               weight:250
                               withId:++itemId];
    [item setImageId:10];
    [cat addMenuItem:item];
    
    item = [self itemObjectWithTitles:@{@"ru": @"Куриный суп-лапша",
                                        @"en": @"Chicken noodle soup"}
                         descriptions:@{@"ru": @"Аппетитное первое блюдо с куриной грудкой и бульоном, лапшой, болгарским перцем, красной морковью и специями.",
                                        @"en": @"An appetizing soup with chicken breast, noodles, bell peppers, carrots and spices."}
                                 cost:230
                               weight:250
                               withId:++itemId];
    [item setImageId:11];
    [cat addMenuItem:item];
    
//-----------------
    cat = [[MenuCategoryObject alloc] initWithId:@(catId++).stringValue];
    [cat setTitle:@"Закуски" forLng:@"ru"];
    [cat setTitle:@"Appetizers" forLng:@"en"];
    [obj addMenuCategory:cat];
    
    item = [self itemObjectWithTitles:@{@"ru": @"Казы",
                                        @"en": @"Kazy"}
                         descriptions:@{@"ru": @"Особый деликатес из конины, сваренный с добавлением ароматных приправ.",
                                        @"en": @"Special delicacy from horse meat, cooked with flavorful spices."}
                                 cost:330
                               weight:100
                               withId:++itemId];
    [item setImageId:12];
    [cat addMenuItem:item];
    
    item = [self itemObjectWithTitles:@{@"ru": @"Манты Карло",
                                        @"en": @"Manty Carlo"}
                         descriptions:@{@"ru": @"Карликовые манты, фаршированные бараниной. Поджарены на сковороде с добавлением лука и душистых специй. Подаются со сметаной.",
                                        @"en": @"Bite-sized manty with lamb. Pan-fried and seasoned with onions and flavorful spices. Served with sour cream."}
                                 cost:250
                               weight:150
                               withId:++itemId];
    [item setImageId:13];
    [cat addMenuItem:item];
    

//-----------------
    cat = [[MenuCategoryObject alloc] initWithId:@(catId++).stringValue];
    [cat setTitle:@"Соусы" forLng:@"ru"];
    [cat setTitle:@"Sauces" forLng:@"en"];
    [obj addMenuCategory:cat];
    
    item = [self itemObjectWithTitles:@{@"ru": @"Пападжика",
                                        @"en": @"Papadzhika"}
                         descriptions:@{@"ru": @"Острый соус на основе стручкового и болгарского перцев, томатов, укропа, чеснока и специй.",
                                        @"en": @"Hot sauce made with chili and bell peppers, tomatoes, dill, garlic and spices."}
                                 cost:50
                               weight:50
                               withId:++itemId];
    [item setImageId:14];
    [cat addMenuItem:item];
    
    item = [self itemObjectWithTitles:@{@"ru": @"Мамациони",
                                        @"en": @"Mamatsioni"}
                         descriptions:@{@"ru": @"Нежный кисломолочный соус в сочетании со свежей ароматной кинзой.",
                                        @"en": @"Delicate sour cream sauce served with fresh cilantro."}
                                 cost:50
                               weight:50
                               withId:++itemId];
    [item setImageId:15];
    [cat addMenuItem:item];
    
    item = [self itemObjectWithTitles:@{@"ru": @"Сметана",
                                        @"en": @"Sour cream"}
                         descriptions:@{@"ru": @"Кисломолочный продукт, на основе сливок и закваски.",
                                        @"en": @"Cream-based dairy product."}
                                 cost:50
                               weight:50
                               withId:++itemId];
    [item setImageId:16];
    [cat addMenuItem:item];
    
    
//-----------------
    cat = [[MenuCategoryObject alloc] initWithId:@(catId++).stringValue];
    [cat setTitle:@"Салаты" forLng:@"ru"];
    [cat setTitle:@"Salads" forLng:@"en"];
    [obj addMenuCategory:cat];
    
    item = [self itemObjectWithTitles:@{@"ru": @"i — Чучук",
                                        @"en": @"i - Chuchuk"}
                         descriptions:@{@"ru": @"Тонко порезанные спелые ароматные помидоры, белый лук, вместе с нашинкованным зеленым базиликом — традиционный салат для плова.",
                                        @"en": @"Thinly sliced ripe tomatoes, white onions and chopped fresh basil. Traditional salad served with plov."}
                                 cost:180
                               weight:150
                               withId:++itemId];
    [item setImageId:17];
    [cat addMenuItem:item];
    
    item = [self itemObjectWithTitles:@{@"ru": @"Салат Fresh",
                                        @"en": @"Fresh Salad"}
                         descriptions:@{@"ru": @"Ароматный огуречный салат со свежей кинзой, укропом, рубленым зеленым луком, с добавлением растительного масла и соли.",
                                        @"en": @"Fragrant cucumber salad seasoned with fresh cilantro, dill, chopped scallions, vegetable oil and salt."}
                                 cost:180
                               weight:150
                               withId:++itemId];
    [item setImageId:18];
    [cat addMenuItem:item];
    
//-----------------
    cat = [[MenuCategoryObject alloc] initWithId:@(catId++).stringValue];
    [cat setTitle:@"Выпечка" forLng:@"ru"];
    [cat setTitle:@"Pastries" forLng:@"en"];
    [obj addMenuCategory:cat];
    
    item = [self itemObjectWithTitles:@{@"ru": @"Самса с ягнятиной",
                                        @"en": @"Samsa with Lamb"}
                         descriptions:@{@"ru": @"Приготовленная по традиционному узбекскому рецепту, с начинкой из мелко рубленной баранины с добавлением лука и душистых специй в слоеном тесте.",
                                        @"en": @"Traditional Uzbek samsa – puff pastry stuffed with finely chopped lamb, onions and fragrant spices."}
                                 cost:130
                               weight:100
                               withId:++itemId];
    [item setImageId:19];
    [cat addMenuItem:item];
    
    item = [self itemObjectWithTitles:@{@"ru": @"Самса с зеленью и сыром",
                                        @"en": @"Samsa with cheese"}
                         descriptions:@{@"ru": @"Приготовленная с добавлением зелёного лука, укропа, кориандра, специй и трёх видов сыра: сулугуни, брынза и гауда.",
                                        @"en": @"Baked samsa with onions, dill, cilantro, spices and three cheeses – sulugini, gouda and feta cheese."}
                                 cost:130
                               weight:100
                               withId:++itemId];
    [item setImageId:20];
    [cat addMenuItem:item];
    
    item = [self itemObjectWithTitles:@{@"ru": @"Самса с овощами и курицей",
                                        @"en": @"Samsa with chicken and vegetables"}
                         descriptions:@{@"ru": @"Запечённое слоёное тесто с куриной грудкой, болгарским перцем, томатом, укропом, репчатым луком и специями.",
                                        @"en": @"Baked puff pastry with chicken breast, bell peppers, tomatoes, dill, onions and spices."}
                                 cost:130
                               weight:100
                               withId:++itemId];
    [item setImageId:21];
    [cat addMenuItem:item];
    
    item = [self itemObjectWithTitles:@{@"ru": @"Самса с тыквой",
                                        @"en": @"Samsa with pumpkin"}
                         descriptions:@{@"ru": @"Запечённое слоёное тесто с начинкой из ароматной тыквы, лука, с добавлением душистых специй.",
                                        @"en": @"Baked puff pastry with flavorful pumpkin, onions and fragrant spices."}
                                 cost:130
                               weight:100
                               withId:++itemId];
    [item setImageId:22];
    [cat addMenuItem:item];
    
    item = [self itemObjectWithTitles:@{@"ru": @"Роберт-Брауни младший",
                                        @"en": @"Robert Brownie, Jr"}
                         descriptions:@{@"ru": @"Десерт из темного бельгийского шоколада с добавлением натурального какао, грецкого ореха и белого шоколада.",
                                        @"en": @"Chocolate desert. Made with dark Belgian chocolate, natural cocoa, walnuts and white chocolate."}
                                 cost:140
                               weight:100
                               withId:++itemId];
    [item setImageId:23];
    [cat addMenuItem:item];
    
    
//-----------------
    cat = [[MenuCategoryObject alloc] initWithId:@(catId++).stringValue];
    [cat setTitle:@"Напитки" forLng:@"ru"];
    [cat setTitle:@"Beverages" forLng:@"en"];
    [obj addMenuCategory:cat];
    
    item = [self itemObjectWithTitles:@{@"ru": @"Coca-Cola",
                                        @"en": @"Coca-Cola"}
                         descriptions:@{@"ru": @"Газированный напиток.",
                                        @"en": @"Soda drink"}
                                 cost:0
                               weight:0
                               withId:++itemId];
    [item setCost:70 forMlitres:330];
    [item setImageId:24];
    [cat addMenuItem:item];
    
    item = [self itemObjectWithTitles:@{@"ru": @"Dr Pepper",
                                        @"en": @"Dr Pepper"}
                         descriptions:@{@"ru": @"Газированный напиток.",
                                        @"en": @"Soda drink"}
                                 cost:0
                               weight:0
                               withId:++itemId];
    [item setCost:90 forMlitres:330];
    [item setImageId:25];
    [cat addMenuItem:item];
    
    item = [self itemObjectWithTitles:@{@"ru": @"Borjomi",
                                        @"en": @"Borjomi"}
                         descriptions:@{@"ru": @"Минеральная газированная лечебно-столовая вода.",
                                        @"en": @"Mineral sparkling water."}
                                 cost:0
                               weight:0
                               withId:++itemId];
    [item setCost:100 forMlitres:300];
    [item setImageId:26];
    [cat addMenuItem:item];
    
    item = [self itemObjectWithTitles:@{@"ru": @"Соки Rich",
                                        @"en": @"Juices Rich"}
                         descriptions:@{@"ru": @"Фруктовые соки в ассортименте.",
                                        @"en": @"Assorted fruit juices"}
                                 cost:0
                               weight:0
                               withId:++itemId];
    [item setCost:160 forMlitres:1000];
    [item setImageId:27];
    [cat addMenuItem:item];

    item = [self itemObjectWithTitles:@{@"ru": @"Компоты Х.О.",
                                        @"en": @"Compote X.O."}
                         descriptions:@{@"ru": @"Разнообразные компоты с ягодами и плодами с чудесным ароматом и вкусом.",
                                        @"en": @"Selection of flavorful fruit and berry compotes."}
                                 cost:0
                               weight:0
                               withId:++itemId];
    [item setCost:280 forMlitres:1000];
    [item setImageId:28];
    [cat addMenuItem:item];

    
    obj.minimalCost = [self.remoteAppInfo[kRemoteInfoMinimalCost] integerValue];
    obj.freeDeliveryCost = [self.remoteAppInfo[kRemoteInfoFreeDeliveryCost] integerValue];
    obj.deliveryCost = [self.remoteAppInfo[kRemoteInfoDeliveryCost] integerValue];
    
    return obj;
}

- (void)updateApplication
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil
                                                     message:LOC(@"LOC_MINIMAL_VER")
                                                    delegate:self
                                           cancelButtonTitle:LOC(@"UPDATE_ACTION")
                                           otherButtonTitles:nil];
    
    alert.tag = 100;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100)
    {
        NSURL *appStoreURL = [NSURL URLWithString:self.remoteAppInfo[kRemoteInfoUpdateURL]];
        [[UIApplication sharedApplication] openURL:appStoreURL];
    }
}

- (BOOL)updateRemoteInfo
{
    if (self.remoteAppInfo)
    {
        return YES;
    }
    
    NSData * str = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://plov.com/apps.php"] options:0 error:nil];
    
    if (str.length)
    {
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:str options:0 error:nil];
        
        if (json.count)
        {
            self.remoteAppInfo = json;
        }
    }
    
    return self.remoteAppInfo.count > 0;
}

- (BOOL)checkForAppVersion
{
    if ([self updateRemoteInfo])
    {
        NSInteger minBuild = [self.remoteAppInfo[kRemoteInfoBuildNumber] integerValue];
        
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
    
    application.applicationIconBadgeNumber = 0;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    [Intercom setDeviceToken:deviceToken];
    NSLog(@"My token is: %@", deviceToken);
    
//    [self.tracking ParseRegisterPush:deviceToken];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    [self.tracking ParseHandlePush:userInfo];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

@end
