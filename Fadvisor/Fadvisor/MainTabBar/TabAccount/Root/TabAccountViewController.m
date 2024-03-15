//
//  TabAccountViewController.m
//  Fadvisor
//
//  Created by 韩建伟 on 2021/3/20.
//

#import "TabAccountViewController.h"
#import "AccountManager.h"
#import "TabAccountHeaderNotLoginView.h"
#import "ImageButton.h"
#import "UserLoginViewController.h"
#import "TabAccountNavigationView.h"
#import "TabAccountInternalBanner.h"
#import "TabAccountGeneralFuncsView.h"
#import "TabAccountBottomCardsView.h"

@interface TabAccountViewController ()

@property (nonatomic, strong) TabAccountHeaderNotLoginView *headerNotLoingView;
@property (nonatomic, strong) TabAccountInternalBanner *internalBanner;

@end

@implementation TabAccountViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        //TabBar的配置
        self.tabBarItem.title = [@"TabAccountName" localString];
        self.tabBarItem.image = [[UIImage imageNamed:@"tab_account_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage = [[UIImage alloc] init];

        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;

    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:self.navigationBar];
}

- (void)handleBtnTouchDown:(MyBaseLayout *)sender {
    NSLog(@"点击了");
    sender.transform = CGAffineTransformIdentity;

    [UIView animateKeyframesWithDuration:0.5 delay:0 options:0 animations: ^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 / 3.0 animations: ^{
            sender.transform = CGAffineTransformMakeScale(0.8, 0.8);
        }];

        [UIView addKeyframeWithRelativeStartTime:1 / 3.0 relativeDuration:1 / 3.0 animations: ^{
            sender.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }];

        [UIView addKeyframeWithRelativeStartTime:2 / 3.0 relativeDuration:1 / 3.0 animations: ^{
            sender.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    } completion:nil];
}

- (void)initUI {
    self.contentLayout.backgroundColor = [UIColor backgroundColor];

    TabAccountNavigationView *navigationView = [TabAccountNavigationView new];
    navigationView.paddingRight = 16;
    self.navigationBar.rightView = navigationView;

    if (!ACCOUNT_MANAGER.isLogin) {
        [self.contentLayout addSubview:self.headerNotLoingView];
    } else {
    }

    self.internalBanner.myHorzMargin = 16;
    self.internalBanner.myTop = 12;

    [self.contentLayout addSubview:self.internalBanner];

    // 顶部的那个曲线形状
    CGFloat curveViewHeight = 15;

    UIView *topCurveView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, curveViewHeight)];
    topCurveView.myTop = -1 * curveViewHeight;

    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint startPoint = CGPointMake(0, 0);
    CGPoint controlPoint = CGPointMake(self.view.width * 0.5, curveViewHeight * 2);
    CGPoint endPoint = CGPointMake(self.view.width, 0);

    [path moveToPoint:startPoint];
    [path addQuadCurveToPoint:endPoint controlPoint:controlPoint];
//
    [path addLineToPoint:CGPointMake(self.view.width, curveViewHeight)];
    [path addLineToPoint:CGPointMake(0, curveViewHeight)];

    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.path = path.CGPath;

    topCurveView.layer.mask = layer;
//    topCurveView.clipsToBounds = YES;
    topCurveView.backgroundColor = [UIColor backgroundColorGray];

    [self.contentLayout addSubview:topCurveView];

    MyLinearLayout *bottomLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    bottomLayout.myHorzMargin = 0;
    bottomLayout.padding = UIEdgeInsetsMake(12, 16, 12, 16);
    bottomLayout.backgroundColor = [UIColor backgroundColorGray];

    [self.contentLayout addSubview:bottomLayout];

    TabAccountGeneralFuncsView *generalFuncsView = [TabAccountGeneralFuncsView new];
    generalFuncsView.myHorzMargin = 0;
    [bottomLayout addSubview:generalFuncsView];

    TabAccountBottomCardsView *bottomCardsView = [TabAccountBottomCardsView new];
    bottomCardsView.myHorzMargin = 0;
    bottomCardsView.myTop = 12;
    [bottomLayout addSubview:bottomCardsView];
}

#pragma mark - BaseViewControllerDatasource
- (BOOL)baseViewControllerIsNeedNavBar:(BaseViewController *)baseViewController {
    return YES;
}

- (BOOL)navigationBarHideLeftView:(NavigationBar *)navigationBar {
    return YES;
}

#pragma mark - Getter & Setter

- (TabAccountHeaderNotLoginView *)headerNotLoingView {
    if (!_headerNotLoingView) {
        _headerNotLoingView = [[TabAccountHeaderNotLoginView alloc] init];
        _headerNotLoingView.myHorzMargin = 0;
    }
    return _headerNotLoingView;
}

- (TabAccountInternalBanner *)internalBanner {
    if (!_internalBanner) {
        _internalBanner = [TabAccountInternalBanner new];
    }
    return _internalBanner;
}

@end
