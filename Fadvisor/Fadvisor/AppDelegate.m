//
//  AppDelegate.m
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/10.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "TabDiscoveryViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
////    [self clearLaunchScreenCache];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    MainTabBarController *tabBarController = [[MainTabBarController alloc] init];
    
    [self.window setRootViewController:tabBarController];
    [self.window makeKeyAndVisible];


    
    return YES;
}

@end
