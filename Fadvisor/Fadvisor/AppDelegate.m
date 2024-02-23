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
    [UMengHelper UMStart:ThirdSDKUMConfigInstanceAppKey channel:ThirdSDKUMConfigInstanceChannelId];
    [UMengHelper UMAnalyticStart];
    [UMengHelper UMSocialStart:ThirdSDKQQAppKey wechatAppKey:ThirdSDKWeChatAppKey wechatAppSecret:ThirdSDKWeChatAppSecret weiboAppKey:ThirdSDKWeiboAppKey weiboAppSecret:ThirdSDKWeiboAppSecret weiboCallback:ThirdSDKWeiboCallback];
//    [UMengHelper UMPushStart:launchOptions delegate:self];

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

// 在这里写支持的旋转方向，为了防止横屏方向，应用启动时候界面变为横屏模式
//- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
//    // 可以这么写
//    if (self.allowOrentitaionRotation) {
//        return UIInterfaceOrientationMaskAllButUpsideDown;
//    }
//    return UIInterfaceOrientationMaskPortrait;
//}

#pragma mark
- (void)startDevelopTools {
    // ⚠️ InjectionIII
//    [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle"] load];
    // ⚠️ Doraemon
//    [[DoraemonManager shareInstance] install];
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

//- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
//    // 播放器相关横竖屏适配
//    UIInterfaceOrientationMask orientationMask = UIViewController.topViewController.supportedInterfaceOrientations;
//
//    if ([AlivcPlayerManager manager].shouldFlowOrientation) {
//        BOOL landscape = ([AlivcPlayerManager manager].playContainView.window) && [AlivcPlayerManager manager].currentOrientation != 0;
//        orientationMask = landscape ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait;
//    } else {
//        return [UIViewController.topViewController supportedInterfaceOrientations];
//    }
//
//    if (orientationMask == UIInterfaceOrientationMaskAllButUpsideDown || orientationMask == UIInterfaceOrientationMaskAll) {
//        return UIInterfaceOrientationMaskPortrait;
//    }
//    return orientationMask;
//}

@end
