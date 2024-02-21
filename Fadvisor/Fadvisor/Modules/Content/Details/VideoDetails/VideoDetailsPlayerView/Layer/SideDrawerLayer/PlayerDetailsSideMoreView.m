//
//  PlayerDetailsHorzMoreView.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/21.
//

#import "PlayerDetailsSideMoreView.h"
#import <MyLayout/MyLayout.h>

@interface PlayerDetailsSideMoreView ()

@property (nonatomic, strong) MyLinearLayout *contentLayout;

@end

@implementation PlayerDetailsSideMoreView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIEdgeInsets contentInset = self.contentInset;
        contentInset.right += kDefaultNavBarHeight;
        self.contentInset = contentInset;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        MyLinearLayout *contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
        contentLayout.padding = UIEdgeInsetsMake(12, 12, 16, 16); //设置布局内的子视图离自己的边距.
        contentLayout.myHorzMargin = 0;                          //同时指定左右边距为0表示宽度和父视图一样宽
        contentLayout.heightSize.lBound(self.heightSize, 0, 1); //高度虽然是自适应的。但是最小的高度不能低于父视图的高度.
        contentLayout.gravity = MyGravity_Horz_Fill;
        self.contentLayout = contentLayout;
        [self addSubview:contentLayout];

        [self initUI];

    }
    return self;
}

- (void)initUI {
    // 创建上部分区域
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [button setTitle:@"测试按钮" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentLayout addSubview:button];
    // 创建播放方式
}

- (void)handleClick:(UIView *)sender {
    NSLog(@"点击View");
}

- (void)btnClicked:(UIButton *)sender {
    NSLog(@"点击按钮");
}

@end
