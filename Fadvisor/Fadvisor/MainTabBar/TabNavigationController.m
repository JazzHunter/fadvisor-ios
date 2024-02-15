//
//  TabNavigationController.m
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/10.
//

#import "TabNavigationController.h"

@interface TabNavigationController ()

@end

@implementation TabNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;

    // 不让自控制器控制系统导航条
    self.fd_viewControllerBasedNavigationBarAppearanceEnabled = NO;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count != 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark - 屏幕旋转

- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}

@end
