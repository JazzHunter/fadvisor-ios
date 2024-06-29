//
//  PlayerDetailsHorzMoreView.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/21.
//

#import "PlayerDetailsSideMoreView.h"
#import <MyLayout/MyLayout.h>
#import "ImageTextVButton.h"

@interface PlayerDetailsSideMoreView ()

@property (nonatomic, strong) MyLinearLayout *contentLayout;

@end

@implementation PlayerDetailsSideMoreView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        UIEdgeInsets contentInset = self.contentInset;
//        contentInset.right += kDefaultNavBarHeight;
//        self.contentInset = contentInset;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
//        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
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
    ImageTextVButton *button = [[ImageTextVButton alloc]initWithFrame:CGRectMake(0, 0, 56, 56)];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor mainColor] forState:UIControlStateSelected];
    [button setTitle:@"测试按钮" forState:UIControlStateNormal];
    [button setImage:[[[[UIImage imageNamed:@"ic_reload"] imageWithTintColor:[UIColor whiteColor]] scaleToSize:CGSizeMake(24, 24)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [button setImage:[[[[UIImage imageNamed:@"ic_reload"] imageWithTintColor:[UIColor mainColor]] scaleToSize:CGSizeMake(24, 24)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];

    UIView *a = [UIView new];
    a.heightSize.equalTo(@200);
    [a addSubview:button];
    a.backgroundColor = [UIColor yellowColor];
    [self.contentLayout addSubview:a];
    // 创建播放方式
}

- (void)handleClick:(UIView *)sender {
    NSLog(@"点击View");
}

- (void)btnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSLog(@"%@", sender.selected ? @"是" : @"否");
}

@end
