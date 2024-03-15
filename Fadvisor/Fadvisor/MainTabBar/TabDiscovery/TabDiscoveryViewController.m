//
//  TabDiscoveryViewController.m
//  Fadvisor
//
//  Created by 韩建伟 on 2021/3/20.
//

#import "TabDiscoveryViewController.h"
#import "DemoAudioCallViewController.h"

@interface TabDiscoveryViewController ()

@end

@implementation TabDiscoveryViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        //TabBar的配置
        self.tabBarItem.title = [@"TabDiscoveryName" localString];
        self.tabBarItem.image = [[UIImage imageNamed:@"tab_discovery_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage = [[UIImage alloc] init];
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:[@"点击我" localString] forState:UIControlStateNormal];
    [btn setTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(100, 100, 200, 120);
    
    [self.view addSubview:btn];
}

- (void)btnClicked:(UIButton *)sender {
    DemoAudioCallViewController *vc = [DemoAudioCallViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
