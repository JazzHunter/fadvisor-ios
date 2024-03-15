//
//  SettingViewController.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/3/15.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initNavigationBar];

    [self initUI];
}

- (void)initNavigationBar {
    self.navigationBar.delegate = self;
    self.navigationBar.dataSource = self;
    [self.navigationBar setTitleText:@"设置"];
}

- (void)initUI {
    self.contentLayout.gravity = MyGravity_Horz_Fill;
    self.contentLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);

    MyRelativeLayout *videoSettingLayout = [self createArrowLayout:@"视频播放设置" introductionText:@"设置视频播放相关的内容" action:@selector(videoSettingTap:)];
    videoSettingLayout.topBorderline = [[MyBorderline alloc] initWithColor:[UIColor backgroundColorGray]];
    videoSettingLayout.topBorderline.thick = 4;

    [self.contentLayout addSubview:videoSettingLayout];

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

- (void)videoSettingTap:(MyBaseLayout *)sender {
}

//创建可执动作事件的布局
- (MyRelativeLayout *)createArrowLayout:(NSString *)titleText introductionText:(NSString *)introductionText action:(SEL)action {
    MyRelativeLayout *arrowLayout = [MyRelativeLayout new];
    arrowLayout.backgroundColor = [UIColor backgroundColor];
    [arrowLayout setTarget:self action:action];
    arrowLayout.highlightedBackgroundColor = [UIColor lightBackgroundColor]; //可以设置高亮的背景色用于单击事件

    //左右内边距都是10，不包裹子视图，整体高度为50，里面的子布局垂直居中对齐。
    arrowLayout.padding = UIEdgeInsetsMake(10, 16, 10, 16);
    arrowLayout.myHorzMargin = 0;
    arrowLayout.heightSize.equalTo(@56);

    UILabel *titleLabel = [UILabel new];
    titleLabel.text = titleText;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor titleTextColor];
    [titleLabel sizeToFit];
    titleLabel.leftPos.equalTo(arrowLayout.leftPos);
    [arrowLayout addSubview:titleLabel];

    if (!introductionText) {
        titleLabel.centerYPos.equalTo(arrowLayout.centerYPos);
    } else {
        UILabel *introductionLabel = [UILabel new];
        introductionLabel.text = introductionText;
        introductionLabel.font = [UIFont systemFontOfSize:12];
        introductionLabel.textColor = [UIColor metaTextColor];
        [introductionLabel sizeToFit];
        introductionLabel.leftPos.equalTo(arrowLayout.leftPos);
        introductionLabel.topPos.equalTo(titleLabel.bottomPos).offset(4);
        [arrowLayout addSubview:introductionLabel];
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[[[UIImage imageNamed:@"ic_right_arr"] imageWithTintColor:[UIColor metaTextColor]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    imageView.frame = CGRectMake(0, 0, 12, 12);
    imageView.rightPos.equalTo(arrowLayout.rightPos);
    imageView.centerYPos.equalTo(arrowLayout.centerYPos);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [arrowLayout addSubview:imageView];

    return arrowLayout;
}

- (MyRelativeLayout *)createSwitchLayout:(NSString *)titleText introductionText:(NSString *)introductionText action:(SEL)action {
    MyRelativeLayout *switchLayout = [MyRelativeLayout new];
    switchLayout.backgroundColor = [UIColor backgroundColor];

    //左右内边距都是10，不包裹子视图，整体高度为50，里面的子布局垂直居中对齐。
    switchLayout.padding = UIEdgeInsetsMake(10, 16, 10, 16);
    switchLayout.myHorzMargin = 0;
    switchLayout.heightSize.equalTo(@56);

    UILabel *titleLabel = [UILabel new];
    titleLabel.text = titleText;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor titleTextColor];
    [titleLabel sizeToFit];
    titleLabel.leftPos.equalTo(switchLayout.leftPos);
    [switchLayout addSubview:titleLabel];

    if (!introductionText) {
        titleLabel.centerYPos.equalTo(switchLayout.centerYPos);
    } else {
        UILabel *introductionLabel = [UILabel new];
        introductionLabel.text = introductionText;
        introductionLabel.font = [UIFont systemFontOfSize:12];
        introductionLabel.textColor = [UIColor metaTextColor];
        [introductionLabel sizeToFit];
        introductionLabel.leftPos.equalTo(switchLayout.leftPos);
        introductionLabel.topPos.equalTo(titleLabel.bottomPos).offset(4);
        [switchLayout addSubview:introductionLabel];
    }

    return switchLayout;
}

#pragma mark - BaseViewControllerDatasource
- (BOOL)baseViewControllerIsNeedNavBar:(BaseViewController *)baseViewController {
    return YES;
}

#pragma mark - NavigationBarDelegate
- (void)leftButtonEvent:(UIButton *)sender navigationBar:(NavigationBar *)navigationBar {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
