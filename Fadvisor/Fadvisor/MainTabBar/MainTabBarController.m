//
//  MainTabBarController.m
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/10.
//

#import "MainTabBarController.h"
#import <Lottie/LOTAnimationView.h>
#import "TabNavigationController.h"

#import "TabHomeViewController.h"
#import "TabColumnViewController.h"
//#import "TabElementController.h"
#import "TabDiscoveryViewController.h"
#import "TabAccountViewController.h"

#define LOTAnimationViewWidth  33
#define LOTAnimationViewHeight 33
#define tabBarItemsCount       4

@interface MainTabBarController ()

@property (nonatomic, strong) LOTAnimationView *lottieView;
@property (nonatomic, copy) NSArray *lottieAnimationJsonFileArr;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation MainTabBarController

+ (void)initialize {
    /** 通过appearance统一设置UITab的属性 */
    [UITabBar appearance].translucent = NO;

    /** 通过appearance统一设置所有UITabBarItem的文字属性 */
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    /** 设置默认状态 */
    NSMutableDictionary *norDict = @{}.mutableCopy;
    norDict[NSForegroundColorAttributeName] = [UIColor systemGrayColor];
    norDict[NSFontAttributeName] = [UIFont systemFontOfSize:10.0f];
    [tabBarItem setTitleTextAttributes:norDict forState:UIControlStateNormal];

    /** 设置选中状态 */
    NSMutableDictionary *selDict = @{}.mutableCopy;
    selDict[NSForegroundColorAttributeName] = [UIColor mainColor];
    selDict[NSFontAttributeName] = [UIFont systemFontOfSize:14.0f];
    [tabBarItem setTitleTextAttributes:selDict forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildViewControllers];
    self.currentIndex = 0;
    [self addLottieImage:self.currentIndex];
    [self playLottieAnimation];
    self.delegate = self;

    //解决iOS13选中字体变蓝色的情况
    self.tabBar.tintColor = [UIColor mainColor];
    // 改变 tabbar 背景色。https://www.jianshu.com/p/28916945a4ec
    if (@available(iOS 15.0, *)) {
        UITabBarAppearance *apperarance = [[UITabBarAppearance alloc] init];
        [apperarance setBackgroundColor:[UIColor backgroundColor]];
        [apperarance setBackgroundEffect:nil];
        self.tabBar.standardAppearance = apperarance;
        self.tabBar.scrollEdgeAppearance = apperarance;
    } else {
        self.tabBar.translucent =  NO;
        self.tabBar.backgroundColor = [UIColor backgroundColor];
    }
}

- (void)addChildViewControllers {
    TabNavigationController *one = [[TabNavigationController alloc] initWithRootViewController:[[TabHomeViewController alloc] init]];
    TabNavigationController *two = [[TabNavigationController alloc] initWithRootViewController:[[TabColumnViewController alloc] init]];
    TabNavigationController *four = [[TabNavigationController alloc] initWithRootViewController:[[TabDiscoveryViewController alloc] init]];
    TabNavigationController *five = [[TabNavigationController alloc] initWithRootViewController:[[TabAccountViewController alloc] init]];
    self.viewControllers = @[one, two, four, five];
}

- (void)addLottieImage:(NSInteger)index {
    if ([NSThread isMainThread]) {
        [self addLottieImageInMainThread:index];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addLottieImageInMainThread:index];
        });
    }
}

- (void)addLottieImageInMainThread:(NSInteger)index {
    LOTAnimationView *lottieView = [LOTAnimationView animationNamed:self.lottieAnimationJsonFileArr[index] inBundle:[NSBundle bundleWithPath:[[[NSBundle resourceBundle] resourcePath] stringByAppendingPathComponent:@"TabBarLottieFiles"]]];
    CGFloat singleW = ScreenWidth / tabBarItemsCount;

    CGFloat x = ceilf(index * singleW + (singleW - LOTAnimationViewWidth) / 2.0);
    lottieView.frame = CGRectMake(x - 1, 2, LOTAnimationViewWidth, LOTAnimationViewHeight);
    lottieView.userInteractionEnabled = NO;
    lottieView.contentMode = UIViewContentModeScaleAspectFill;
    self.lottieView = lottieView;
    [self.tabBar addSubview:lottieView];
}

- (void)playLottieAnimation {
    self.lottieView.animationProgress = 0;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@1.0, @1.1, @0.9, @1.0];
    animation.duration = 0.4f;
    animation.repeatCount = 1;
    animation.calculationMode = kCAAnimationCubic;
    [self.lottieView.layer addAnimation:animation forKey:nil];
    [self.lottieView play];
}

- (UINavigationController *)currentNavigationController {
    return self.selectedViewController;
}

#pragma mark - UITabBarControllerDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSInteger newIndex = [self.tabBar.items indexOfObject:item];
    if (self.currentIndex != newIndex) {
        self.currentIndex = newIndex;
        [self.lottieView removeFromSuperview];
        [self addLottieImage:self.currentIndex];
        [self playLottieAnimation];
    } else {
        [self playLottieAnimation];
    }
    //震动
    UIImpactFeedbackGenerator *impactLight = [[UIImpactFeedbackGenerator alloc]initWithStyle:UIImpactFeedbackStyleLight];
    [impactLight impactOccurred];
}

#pragma mark - lazy getter
- (NSArray *)lottieAnimationJsonFileArr {
    if (!_lottieAnimationJsonFileArr) {
        _lottieAnimationJsonFileArr = @[@"tab_home_animate", @"tab_column_animate", @"tab_discovery_animate", @"tab_account_animate"];
    }
    return _lottieAnimationJsonFileArr;
}

#pragma mark - 屏幕旋转

- (BOOL)shouldAutorotate {
    BOOL shouldAutorotate = self.selectedViewController.shouldAutorotate;
    return shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIInterfaceOrientationMask supportedInterfaceOrientations = self.selectedViewController.supportedInterfaceOrientations;
    return supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.selectedViewController.preferredInterfaceOrientationForPresentation;
    
    if (@available(iOS 16.0, *)) {
        [self.navigationController setNeedsUpdateOfSupportedInterfaceOrientations];
        
        NSArray *array = [[[UIApplication sharedApplication] connectedScenes] allObjects];
        UIWindowScene *ws = (UIWindowScene *)array[0];
        UIWindowSceneGeometryPreferencesIOS *geometryPreferences = [[UIWindowSceneGeometryPreferencesIOS alloc] init];
        geometryPreferences.interfaceOrientations = UIInterfaceOrientationMaskLandscapeLeft;
        [ws requestGeometryUpdateWithPreferences:geometryPreferences
            errorHandler:^(NSError * _Nonnull error) {
            //业务代码
        }];
    }
}

@end
