//
//  MBProgressHUD+Additions.m
//  FingerAdvisor
//
//  Created by 韩建伟 on 2020/2/22.
//  Copyright © 2020 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//

#import "MBProgressHUD+Additions.h"

@implementation MBProgressHUD (Additions)

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error ToView:(UIView *)view {
    [self showCustomIcon:@"MBHUD_Error" Title:error ToView:view];
}

+ (void)showSuccess:(NSString *)success ToView:(UIView *)view
{
    [self showCustomIcon:@"MBHUD_Success" Title:success ToView:view];
}

+ (void)showInfo:(NSString *)Info ToView:(UIView *)view
{
    [self showCustomIcon:@"MBHUD_Info" Title:Info ToView:view];
}

+ (void)showWarn:(NSString *)Warn ToView:(UIView *)view
{
    [self showCustomIcon:@"MBHUD_Warn" Title:Warn ToView:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message ToView:(UIView *)view {
    if (view == nil) view = (UIView *)[UIApplication sharedApplication].delegate.window;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    hud.label.font = [UIFont systemFontOfSize:15];
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;

    return hud;
}

+ (MBProgressHUD *)showMessage:(NSString *)message alwaysInView:(UIView *)view {
    if (view == nil) view = (UIView *)[UIApplication sharedApplication].delegate.window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:true];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    hud.contentColor = [UIColor whiteColor];
    hud.label.numberOfLines = 10;
    hud.label.text = message;

    //代表需要蒙版效果
//    hud.dimBackground = YES;
    hud.backgroundColor = [UIColor maskBgColor]; // 设置遮罩背景色
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;

    return hud;
}

//加载视图
+ (void)showLoading {
    [self showMessage:[NSString stringWithFormat:@"%@...", [@"Loading" localString]] alwaysInView:nil];
}

+ (void)showLoadingToView:(UIView *)view {
    [self showMessage:[NSString stringWithFormat:@"%@...", [@"Loading" localString]] alwaysInView:nil];
}

/**
 *  进度条View
 */
+ (MBProgressHUD *)showProgressToView:(UIView *)view Text:(NSString *)text {
    if (view == nil) view = (UIView *)[UIApplication sharedApplication].delegate.window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    hud.label.font = [UIFont systemFontOfSize:15];

    return hud;
}

//快速显示一条提示信息
+ (void)showAutoMessage:(NSString *)message {
    [self showAutoMessage:message ToView:nil];
}

//自动消失提示，无图
+ (void)showAutoMessage:(NSString *)message ToView:(UIView *)view {
    [self showMessage:message ToView:view RemainTime:1 Model:MBProgressHUDModeText];
}

//自定义停留时间，有图
+ (void)showIconMessage:(NSString *)message ToView:(UIView *)view RemainTime:(CGFloat)time {
    [self showMessage:message ToView:view RemainTime:time Model:MBProgressHUDModeIndeterminate];
}

//自定义停留时间，无图
+ (void)showMessage:(NSString *)message ToView:(UIView *)view RemainTime:(CGFloat)time {
    [self showMessage:message ToView:view RemainTime:time Model:MBProgressHUDModeText];
}

+ (void)showMessage:(NSString *)message ToView:(UIView *)view RemainTime:(CGFloat)time Model:(MBProgressHUDMode)model {
    if (view == nil) view = (UIView *)[UIApplication sharedApplication].delegate.window;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    hud.label.font = [UIFont systemFontOfSize:15];
    //模式
    hud.mode = model;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 代表需要蒙版效果
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // X秒之后再消失
    [hud hideAnimated:YES afterDelay:time];
}

+ (void)showCustomIcon:(NSString *)iconName Title:(NSString *)title ToView:(UIView *)view {
    if (view == nil) view = (UIView *)[UIApplication sharedApplication].delegate.window;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = title;
    hud.label.font = [UIFont systemFontOfSize:15];
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];

    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;

    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;

    // 代表需要蒙版效果
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;

    // 3秒之后再消失
    [hud hideAnimated:YES afterDelay:3];
}

+ (void)hideHUDForView:(UIView *)view {
    if (view == nil) view = (UIView *)[UIApplication sharedApplication].delegate.window;
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD {
    [self hideHUDForView:nil];
}

@end
