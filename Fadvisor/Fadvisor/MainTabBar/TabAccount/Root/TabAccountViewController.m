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
    

//    MyLinearLayout *listLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
//    listLayout.myHorzMargin = 0;
//    listLayout.gravity = MyGravity_Horz_Fill;  //子视图里面的内容的宽度跟布局视图相等，这样子视图就不需要设置宽度了。
//    listLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
//    listLayout.backgroundColor = [UIColor backgroundColor];
//    [bottomLayout addSubview:listLayout];
//
//    //具有事件处理的layout,以及边界线效果的layout
//    MyLinearLayout *layout1 = [self createActionLayout:@"点击 1" action:@selector(handleTap:)];
//
//    layout1.topBorderline = [[MyBorderline alloc] initWithColor:[UIColor backgroundColorGray]];
//    layout1.topBorderline.headIndent = -10;
//    layout1.topBorderline.tailIndent = -10; //底部边界线如果为负数则外部缩进
//    layout1.bottomBorderline = [[MyBorderline alloc] initWithColor:[UIColor backgroundColorGray]];
//    [listLayout addSubview:layout1];
//
//    // 创建下面的列表
//    MyLinearLayout *layout2 = [self createActionLayout:@"点击 2" action:@selector(handleTap:)];
//    layout2.highlightedBackgroundColor = [UIColor lightBackgroundColor]; //可以设置高亮的背景色用于单击事件
//    layout2.bottomBorderline = [[MyBorderline alloc] initWithColor:[UIColor backgroundColorGray]];
//    layout2.bottomBorderline.thick = 4; //设置底部有红色的线，并且粗细为4
//    //您还可以为布局视图设置按下、按下取消的事件处理逻辑。
//    [layout2 setTouchDownTarget:self action:@selector(handleTouchDown:)];
//    [layout2 setTouchCancelTarget:self action:@selector(handleTouchCancel:)];
//    [listLayout addSubview:layout2];
}

//创建可执动作事件的布局
- (MyLinearLayout *)createActionLayout:(NSString *)title action:(SEL)action {
    MyLinearLayout *actionLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    actionLayout.backgroundColor = [UIColor backgroundColor];
    [actionLayout setTarget:self action:action];    //这里设置布局的触摸事件处理。

    //左右内边距都是10，不包裹子视图，整体高度为50，里面的子布局垂直居中对齐。
    actionLayout.paddingLeft = 10;
    actionLayout.paddingRight = 10;
    actionLayout.widthSize.equalTo(nil);
    actionLayout.heightSize.equalTo(@50);
    actionLayout.gravity = MyGravity_Vert_Center;

    UILabel *label = [UILabel new];
    label.text = title;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor titleTextColor];
    [label sizeToFit];
    label.tag = 1000;
    label.trailingPos.equalTo(@0.5);  //水平线性布局通过相对间距来实现左右分开排列。
    [actionLayout addSubview:label];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_right_arr"]];
    [imageView sizeToFit];
    imageView.leadingPos.equalTo(@0.5);
    [actionLayout addSubview:imageView];

    return actionLayout;
}

- (void)handleTouchDown:(MyBaseLayout *)sender {
    UILabel *label = (UILabel *)[sender viewWithTag:1000];
    label.textColor = [UIColor blueColor];

    NSLog(@"按下动作");
}

- (void)handleTouchCancel:(MyBaseLayout *)sender {
    UILabel *label = (UILabel *)[sender viewWithTag:1000];
    label.textColor = [UIColor blackColor];
    NSLog(@"按下取消");
}

#pragma mark - BaseViewControllerDatasource
- (BOOL)baseViewControllerIsNeedNavBar:(BaseViewController *)baseViewController {
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
