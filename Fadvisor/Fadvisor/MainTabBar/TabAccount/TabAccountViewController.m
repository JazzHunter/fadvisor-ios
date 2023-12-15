//
//  TabAccountViewController.m
//  Fadvisor
//
//  Created by 韩建伟 on 2021/3/20.
//

#import "TabAccountViewController.h"

@interface TabAccountViewController ()

@end

@implementation TabAccountViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        //TabBar的配置
        self.tabBarItem.title = NSLocalizedString(@"TabAccountName", nil);;
        self.tabBarItem.image = [[UIImage imageNamed:@"tab_account_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage = [[UIImage alloc] init];
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.scrollView setSafeBottomInset];
    
    [self initNavigationBar];
    [self initUI];
}

- (void)initNavigationBar {
    self.navigationBar.delegate = self;
    MyLinearLayout *navigationBarView = [[MyLinearLayout alloc] initWithOrientation:MyOrientation_Horz];
    navigationBarView.backgroundColor = [UIColor yellowColor];
    navigationBarView.subviewHSpace = 10;
    
    MyLinearLayout *settingBtn = [[MyLinearLayout alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [settingBtn setHighlightedOpacity:0.5];
    [settingBtn setBackgroundImage:[UIImage imageNamed:@"ic_share"]];
    [settingBtn setTarget:self action:@selector(handleSettingBtnClicked:)];
    settingBtn.centerYPos.equalTo(@0);  //在父视图中居中。
    [navigationBarView addSubview:settingBtn];
    
    MyLinearLayout *nightTehemeBtn = [[MyLinearLayout alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [nightTehemeBtn setHighlightedOpacity:0.5];
    [nightTehemeBtn setBackgroundImage:[UIImage imageNamed:@"ic_share"]];
    [nightTehemeBtn setTarget:self action:@selector(handleSettingBtnClicked:)];
    nightTehemeBtn.centerYPos.equalTo(@0);  //在父视图中居中。
    [navigationBarView addSubview:nightTehemeBtn];
    
    MyLinearLayout *scanBtn = [[MyLinearLayout alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [scanBtn setHighlightedOpacity:0.5];
    [scanBtn setBackgroundImage:[UIImage imageNamed:@"ic_share"]];
    [scanBtn setTarget:self action:@selector(handleSettingBtnClicked:)];
    scanBtn.centerYPos.equalTo(@0);  //在父视图中居中。
    [navigationBarView addSubview:scanBtn];
    
    self.navigationBar.rightView = navigationBarView;
    
}

- (void)initUI {
    
    MyLinearLayout *listLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    listLayout.myHorzMargin = 0;
    listLayout.gravity = MyGravity_Horz_Fill;  //子视图里面的内容的宽度跟布局视图相等，这样子视图就不需要设置宽度了。
    listLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    listLayout.backgroundColor = [UIColor backgroundColor];
    [self.contentLayout addSubview:listLayout];

    //具有事件处理的layout,以及边界线效果的layout
    MyLinearLayout *layout1 = [self createActionLayout:@"点击 1" action:@selector(handleTap:)];
    
    layout1.topBorderline = [[MyBorderline alloc] initWithColor:[UIColor backgroundColorGray]];
    layout1.topBorderline.headIndent = -10;
    layout1.topBorderline.tailIndent = -10; //底部边界线如果为负数则外部缩进
    layout1.bottomBorderline = [[MyBorderline alloc] initWithColor:[UIColor backgroundColorGray]];
    [listLayout addSubview:layout1];
    
    // 创建下面的列表
    MyLinearLayout *layout2 = [self createActionLayout:@"点击 2" action:@selector(handleTap:)];
    layout2.highlightedBackgroundColor = [UIColor lightBackgroundColor]; //可以设置高亮的背景色用于单击事件
    layout2.bottomBorderline = [[MyBorderline alloc] initWithColor:[UIColor backgroundColorGray]];
    layout2.bottomBorderline.thick = 4; //设置底部有红色的线，并且粗细为4
    //您还可以为布局视图设置按下、按下取消的事件处理逻辑。
    [layout2 setTouchDownTarget:self action:@selector(handleTouchDown:)];
    [layout2 setTouchCancelTarget:self action:@selector(handleTouchCancel:)];
    [listLayout addSubview:layout2];
    
}

//创建可执动作事件的布局
-(MyLinearLayout*)createActionLayout:(NSString*)title action:(SEL)action {
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
//    label.adjustsFontSizeToFitWidth = YES;
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

-(void)handleTouchDown:(MyBaseLayout*)sender {
    UILabel *label = (UILabel*)[sender viewWithTag:1000];
    label.textColor = [UIColor blueColor];
    
    NSLog(@"按下动作");
}

-(void)handleTouchCancel:(MyBaseLayout*)sender {
    UILabel *label = (UILabel*)[sender viewWithTag:1000];
    label.textColor = [UIColor blackColor];
    NSLog(@"按下取消");
}

#pragma mark - BaseViewControllerDatasource
- (BOOL)baseViewControllerIsNeedNavBar:(BaseViewController *)baseViewController {
    return YES;
}


#pragma mark - HeaderBtnClicked
-(void)handleSettingBtnClicked:(MyBaseLayout*)sender{
    
}

-(void)handleTap:(MyBaseLayout*)sender{
}
@end
