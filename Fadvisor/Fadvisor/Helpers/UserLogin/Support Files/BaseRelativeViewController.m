//
//  BaseRelativeViewController.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/10/10.
//

#import "BaseRelativeViewController.h"

@interface BaseRelativeViewController ()

@property (nonatomic, strong) MyRelativeLayout *rootLayout;

@end

@implementation BaseRelativeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor backgroundColor];

    _rootLayout = [[MyRelativeLayout alloc] initWithFrame:self.view.bounds];
    _rootLayout.insetsPaddingFromSafeArea = UIRectEdgeBottom;
    
    [self.view addSubview:_rootLayout];

    self.navigationBar.leftPos.equalTo(_rootLayout.leftPos);
    self.navigationBar.topPos.equalTo(_rootLayout.topPos);
    [_rootLayout addSubview:self.navigationBar];
}

#pragma mark - NavigationBar
- (NavigationBar *)navigationBar {
    // 父类控制器必须是导航控制器
    if (!_navigationBar) {
        NavigationBar *navigationBar = [[NavigationBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kDefaultNavBarHeight)];
        navigationBar.dataSource = self;
        navigationBar.delegate = self;
        _navigationBar = navigationBar;
    }
    return _navigationBar;
}

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
