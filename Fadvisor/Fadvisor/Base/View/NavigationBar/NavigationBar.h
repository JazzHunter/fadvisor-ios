//
//  NavigationBar.h
//  NewsDetailsDemo
//
//  Created by 李响 on 2017/9/22.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MyLayout/MyLayout.h>

@class NavigationBar;
// 主要处理导航条
@protocol  NavigationBarDataSource<NSObject>
@optional
/**头部标题*/
- (NSMutableAttributedString *)navigationBarTitle:(NavigationBar *)navigationBar;
/** 背景图片 */
- (UIImage *)navigationBarBackgroundImage:(NavigationBar *)navigationBar;
/** 背景色 */
- (UIColor *)navigationBarBackgroundColor:(NavigationBar *)navigationBar;
/** 是否显示底部黑线 */
- (BOOL)navigationBarHideBottomLine:(NavigationBar *)navigationBar;
/** 是否显示左边的view */
- (BOOL)navigationBarHideLeftView:(NavigationBar *)navigationBar;
/** 是否显示右边的view */
- (BOOL)navigationBarHideRightView:(NavigationBar *)navigationBar;
/** 导航条的左边的 view */
- (UIView *)navigationBarLeftView:(NavigationBar *)navigationBar;
/** 导航条右边的 view */
- (UIView *)navigationBarRightView:(NavigationBar *)navigationBar;
/** 导航条中间的 View */
- (UIView *)navigationBarTitleView:(NavigationBar *)navigationBar;
/** 导航条左边的按钮 */
- (UIImage *)navigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(NavigationBar *)navigationBar;
/** 导航条右边的按钮 */
- (UIImage *)navigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(NavigationBar *)navigationBar;
@end

@protocol NavigationBarDelegate <NSObject>
@optional
/** 左边的按钮的点击 */
- (void)leftButtonEvent:(UIButton *)sender navigationBar:(NavigationBar *)navigationBar;
/** 右边的按钮的点击 */
- (void)rightButtonEvent:(UIButton *)sender navigationBar:(NavigationBar *)navigationBar;
/** 中间如果是 label 就会有点击 */
- (void)titleClickEvent:(UILabel *)sender navigationBar:(NavigationBar *)navigationBar;
@end

@interface NavigationBar : UIView;

@property (strong, nonatomic) UIImageView *bgView;
@property (strong, nonatomic) UIView *titleView;
@property (strong, nonatomic) UIView *leftView;
@property (strong, nonatomic) UIView *rightView;
@property (strong, nonatomic) NSAttributedString *title;
@property (strong, nonatomic) id<NavigationBarDataSource> dataSource;
@property (strong, nonatomic) id<NavigationBarDelegate> delegate;
- (void)setTitleText: (NSString *)titleText;
/** 根视图 */
@property (strong, nonatomic) MyBaseLayout *rootLayout;

@end
