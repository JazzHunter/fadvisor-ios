//
//  BaseViewController.m
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/10.
//

#import "BaseViewController.h"
#import "NavigationBar.h"
#import <UMVerify/UMVerify.h>

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //背景色
    self.view.backgroundColor = [UIColor backgroundColorGray];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 11.0, *)) {
            [[UIScrollView appearanceWhenContainedInInstancesOfClasses:@[[BaseViewController class]]] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        }
    });
}

- (void)setNavigationBarTitle:(NSString *)navigationBarTitle {
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:navigationBarTitle];
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor titleTextColor] range:NSMakeRange(0, title.length)];
    [title addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(0, title.length)];
    self.navigationBar.title = title;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.view bringSubviewToFront:self.navigationBar];
}

- (void)accelerateLogin {
    //开始状态置为YES，默认当前环境可以使用一键登录
    [UMCommonHandler accelerateLoginPageWithTimeout:3.0 complete:^(NSDictionary *_Nonnull resultDic) {
//        NSLog(@"为后面授权页拉起加个速，加速结果：%@", resultDic);
    }];
}

#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 配置友盟统计
//    [UMengHelper beginLogPageViewName:self.title ? self.title: NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // 配置友盟统计
//    [UMengHelper endLogPageViewName:self.title ? self.title: NSStringFromClass([self class])];
}

- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        self.title = title.copy;
    }
    return self;
}

#pragma mark - DataSource
- (BOOL)baseViewControllerIsNeedNavBar:(BaseViewController *)baseViewController {
    return NO;
}

#pragma mark - NavigationBar
- (NavigationBar *)navigationBar {
    // 父类控制器必须是导航控制器
    if (!_navigationBar && [self baseViewControllerIsNeedNavBar:self]) {
        NavigationBar *navigationBar = [[NavigationBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kDefaultNavBarHeight)];
        navigationBar.dataSource = self;
        navigationBar.delegate = self;
        [self.view addSubview:navigationBar];
        _navigationBar = navigationBar;
    }
    return _navigationBar;
}

#pragma mark - InjectionIII
#if DEBUG
- (void)injected {
    //自定义修改...
    //重新加载view
    [self viewDidLoad];
}

#endif

#pragma mark - 默认竖屏
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
