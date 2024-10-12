//
//  AppDelegate.m
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/10.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "TabDiscoveryViewController.h"
#import "UMengHelper.h"
#import <LEEAlert/LEEAlert.h>
#import "CacheKey.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
////    [self clearLaunchScreenCache];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    MainTabBarController *tabBarController = [[MainTabBarController alloc] init];

    [self.window setRootViewController:tabBarController];
    [self.window makeKeyAndVisible];

    // ⚠️ LeeAlert设置主Window
    [LEEAlert configMainWindow:self.window];

    // ⚠️ 注册NSUserStandards默认值
    [self registerDefaultsForNSUserDefaults];

    if (launchOptions) {
        [LEEAlert alert].config
        .LeeTitle(@"有launchOptions!!")
        .LeeContent(launchOptions.description)
        .LeeAction(@"好的", ^{})
        .LeeShow();
    }
    
    // ⚠️ 友盟初始化
    [self initUM];
    
    
//    [PopCommentInputManager manager];
    #if DEBUG
    [self startDevelopTools];
    #endif

    return YES;
}


#pragma mark - NSUserDefaults 默认值
//注册NSUserDefaults设置的默认值
- (void)registerDefaultsForNSUserDefaults {
    //注册默认
    NSDictionary *dict = @{
            NightTheme: @YES,
            ContentZoom: @1
    };
    [[NSUserDefaults standardUserDefaults] registerDefaults:dict];
    if (@available(iOS 13.0, *)) {
        [self.window setOverrideUserInterfaceStyle:[[NSUserDefaults standardUserDefaults] boolForKey:NightTheme] ? UIUserInterfaceStyleUnspecified : UIUserInterfaceStyleLight];
    }
}

#pragma mark - 初始化开发工具
- (void)startDevelopTools {
    // ⚠️ InjectionIII
//    [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle"] load];
    // ⚠️ Doraemon
//    [[DoraemonManager shareInstance] install];
}

- (void) initUM {
    // 根据App相关监管规定，未进行合规配置的App或将面临通报处罚或下架风险。
    // 为了确保您的App合规，您所运营App的SDK必须在《隐私政策》中明确告知用户，并做好延迟初始化配置，确保用户同意《隐私政策》后，再进行初始化SDK数据采集。
    // 为了避免您的App被下架，请您务必参考以下文档完成进行合规配置： https://developer.umeng.com/docs/147377/detail/213789
    
    [UMengHelper UMStart:ThirdSDKUMConfigInstanceAppKey channel:ThirdSDKUMConfigInstanceChannelId];
    [UMengHelper UMVerifyStart];
    [UMengHelper UMSocialStart:ThirdSDKQQAppKey wechatAppKey:ThirdSDKWeChatAppKey wechatAppSecret:ThirdSDKWeChatAppSecret weiboAppKey:ThirdSDKWeiboAppKey weiboAppSecret:ThirdSDKWeiboAppSecret weiboCallback:ThirdSDKWeiboCallback];
    //    [UMengHelper UMAnalyticStart];
    
    //    [UMengHelper UMPushStart:launchOptions delegate:self];
}


//设置UM系统回调
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
        [LEEAlert alert].config
        .LeeTitle(@"Web应用跳转")
        .LeeContent(url.query)
        .LeeAction(@"好的", ^{})
        .LeeShow();
    }
    return result;
}

#pragma mark - 设置Universal Links系统回调
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring> > *_Nullable))restorationHandler
{
    if (userActivity.webpageURL) {
        NSLog(@"%@", userActivity.webpageURL);
        [LEEAlert alert].config
        .LeeTitle(@"其他SDK的回调")
        .LeeAction(@"好的", ^{})
        .LeeShow();
    }

    return YES;
}

@end
