//
//  MBProgressHUD+Additions.h
//  FingerAdvisor
//
//  Created by 韩建伟 on 2020/2/22.
//  Copyright © 2020 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (Additions)
/**
 *  自定义图片的提示，3s后自动消息
 *
 *  @param title 要显示的文字
 *  @param iconName 图片地址(建议不要太大的图片)
 *  @param view 要添加的view
 */
+ (void)showCustomIcon:(NSString *)iconName Title:(NSString *)title ToView:(UIView *)view;

/**
 *  自动消失成功提示，带默认图
 *
 *  @param success 要显示的文字
 *  @param view    要添加的view
 */
+ (void)showSuccess:(NSString *)success ToView:(UIView *)view;

/**
 *  自动消失错误提示,带默认图
 *
 *  @param error 要显示的错误文字
 *  @param view  要添加的View
 */
+ (void)showError:(NSString *)error ToView:(UIView *)view;

/**
 *  自动消失提示,带默认图
 *
 *  @param Info 要显示的文字
 *  @param view  要添加的View
 */
+ (void)showInfo:(NSString *)Info ToView:(UIView *)view;

/**
 *  自动消失提示,带默认图
 *
 *  @param Warn 要显示的文字
 *  @param view  要添加的View
 */
+ (void)showWarn:(NSString *)Warn ToView:(UIView *)view;

/**
 *  文字+菊花提示,不自动消失
 *
 *  @param message 要显示的文字
 *  @param view    要添加的View
 *
 *  @return MBProgressHUD
 */
+ (MBProgressHUD *)showMessage:(NSString *)message ToView:(UIView *)view;

/**
 一直展示信息

 @param message 信息
 @param view 展示view所在的视图
 */
+ (MBProgressHUD *)showMessage:(NSString *)message alwaysInView:(UIView *)view;

/**
 *  快速显示一条提示信息
 *
 *  @param message 要显示的文字
 */
+ (void)showAutoMessage:(NSString *)message;

/**
 *  自动消失提示，无图
 *
 *  @param message 要显示的文字
 *  @param view    要添加的View
 */
+ (void)showAutoMessage:(NSString *)message ToView:(UIView *)view;

/**
 *  自定义停留时间，有图
 *
 *  @param message 要显示的文字
 *  @param view    要添加的View
 *  @param time    停留时间
 */
+ (void)showIconMessage:(NSString *)message ToView:(UIView *)view RemainTime:(CGFloat)time;

/**
 *  自定义停留时间，无图
 *
 *  @param message 要显示的文字
 *  @param view 要添加的View
 *  @param time 停留时间
 */
+ (void)showMessage:(NSString *)message ToView:(UIView *)view RemainTime:(CGFloat)time;

/**
 *  加载视图
 */
+ (void)showLoading;

+ (void)showLoadingToView:(UIView *)view;

/**
 *  进度条View
 *
 *  @param view     要添加的View
 *  @param text     显示的文字
 *
 *  @return 返回使用
 */
+ (MBProgressHUD *)showProgressToView:(UIView *)view Text:(NSString *)text;

/**
 *  隐藏ProgressView
 *
 *  @param view superView

 */
+ (void)hideHUDForView:(UIView *)view;

/**
 *  快速从window中隐藏ProgressView
 */
+ (void)hideHUD;

@end
