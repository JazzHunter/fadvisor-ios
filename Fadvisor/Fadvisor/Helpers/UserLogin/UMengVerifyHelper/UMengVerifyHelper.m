//
//  UMengVerifyHelper.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/10/10.
//

#import "UMengVerifyHelper.h"
#import <UMVerify/UMVerify.h>
#import "Utils.h"
#import "LoginSmsSendViewController.h"
#import "LoginPanel.h"

@implementation UMengVerifyHelper

+ (void)popLoginAlert:(UIView *)sender {
    //检查当前环境是否支持一键登录或号码认证，resultDic 返回 PNSCodeSuccess 说明当前环境支持
    
    [UMCommonHandler checkEnvAvailableWithAuthType:UMPNSAuthTypeLoginToken complete:^(NSDictionary * _Nullable resultDic) {
        NSString *resultCode = [resultDic objectForKey:@"resultCode"];
        if (![PNSCodeSuccess isEqualToString:resultCode]) {
            [[LoginPanel sharedInstance] showPanel];
        } else {
            [UMengVerifyHelper popPNSAuthTypeLoginToken];
        }
    }];
}

+ (void)popPNSAuthTypeLoginToken {
    UMCustomModel *model = [[UMCustomModel alloc] init];
    model.supportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;
    model.backgroundImage = [UIImage imageNamed:@"login_alert_bg"];

    model.contentViewFrameBlock = ^CGRect (CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.size.width = superViewSize.width;
        frame.size.height = 380;
        frame.origin.x = 0;
        frame.origin.y = superViewSize.height - frame.size.height;
        return frame;
    };

    model.alertCornerRadiusArray = @[@10, @0, @0, @10];
    model.alertTitleBarColor = [UIColor clearColor];

    NSDictionary *alertTitleAttributes = @{
            NSForegroundColorAttributeName: [UIColor descriptionTextColor],
            NSFontAttributeName: [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold]
    };
    model.alertTitle = [[NSAttributedString alloc] initWithString:@"注册或登录后继续操作" attributes:alertTitleAttributes];
    
    model.alertCloseImage = [[[UIImage imageNamed:@"ic_close"] scaleToSize:CGSizeMake(24, 24)] imageWithTintColor:[UIColor metaTextColor]];
    model.alertTitleBarFrameBlock = ^CGRect (CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.size.height = 64;
        return frame;
    };

    model.logoIsHidden = YES;

    // Slogon 一单设置就没有“中国联通提供认证服务”这个字符了
    model.sloganFrameBlock = ^CGRect (CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 8;
        return frame;
    };

    model.numberFrameBlock = ^CGRect (CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 40;
        return frame;
    };

    model.loginBtnBgImgs = [NSArray arrayWithObjects:[UIImage imageWithColor:[UIColor mainColor]], [UIImage imageWithColor:[UIColor lightMainColor]], [UIImage imageWithColor:[UIColor mainColor]],  nil];
    model.loginBtnFrameBlock = ^CGRect (CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 96;
        return frame;
    };

    NSDictionary *changeBtnTitleAttributes = @{
            NSForegroundColorAttributeName: [UIColor descriptionTextColor],
            NSFontAttributeName: [UIFont systemFontOfSize:16]
    };

    model.changeBtnTitle = [[NSAttributedString alloc] initWithString:@"切换到其他方式" attributes:changeBtnTitleAttributes];
    model.changeBtnFrameBlock = ^CGRect (CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 96 + 50 + 20;
        return frame;
    };

    model.privacyOne = @[@"用户协议", @"https://www.taobao.com"];
    model.privacyTwo = @[@"隐私保护指引", @"https://www.taobao.com"];
    model.privacyColors = @[[UIColor metaTextColor], [UIColor mainColor]];

    // 隐私
    model.privacyAlertIsNeedShow = YES;
    model.privacyAlertMaskAlpha = 0.3;
    model.privacyAlertMaskColor = UIColor.blackColor;
    model.privacyAlertCornerRadiusArray = @[@10, @0, @0, @10];
    model.privacyAlertBackgroundColor = UIColor.whiteColor;
    model.privacyAlertAlpha = 1.0;
    model.privacyAlertTitleBackgroundColor = UIColor.whiteColor;
    model.privacyAlertContentBackgroundColor = UIColor.whiteColor;
    model.privacyAlertTitleFont = [UIFont systemFontOfSize:16];
    model.privacyAlertTitleColor = UIColor.blackColor;
    model.privacyAlertContentColors = @[[UIColor metaTextColor], [UIColor mainColor]];
    model.privacyAlertContentAlignment = NSTextAlignmentCenter;

    UIImage *activeImage = [UMCommonUtils imageWithColor:[UIColor mainColor] size:CGSizeMake(UIScreen.mainScreen.bounds.size.width - 2 * 18, 50) isRoundedCorner:YES radius:10];
    UIImage *hightLightImage = [UMCommonUtils imageWithColor:[UIColor lightMainColor] size:CGSizeMake(UIScreen.mainScreen.bounds.size.width - 2 * 18, 50) isRoundedCorner:YES radius:10];
    model.privacyAlertBtnBackgroundImages = @[activeImage, hightLightImage];
    model.privacyAlertButtonTextColors = @[UIColor.whiteColor, UIColor.whiteColor];
    model.privacyAlertButtonFont = [UIFont systemFontOfSize:16];
    model.privacyAlertCloseButtonIsNeedShow = YES;
    model.privacyAlertMaskIsNeedShow = YES;
    model.privacyAlertIsNeedAutoLogin = YES;

    model.privacyAlertTitleFrameBlock = ^CGRect (CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return CGRectMake(0, 20, frame.size.width, frame.size.height);
    };
    model.privacyAlertPrivacyContentFrameBlock = ^CGRect (CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return CGRectMake(0, frame.origin.y + 10, frame.size.width, frame.size.height);
    };
    model.privacyAlertButtonFrameBlock = ^CGRect (CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return CGRectMake(frame.origin.x, frame.origin.y + 20, frame.size.width, frame.size.height);
    };
    model.privacyAlertFrameBlock = ^CGRect (CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return CGRectMake(0, superViewSize.height - 200, screenSize.width, 200);
    };

    [UMCommonHandler getLoginTokenWithTimeout:3.0 controller:[Utils currentViewController] model:model complete:^(NSDictionary *_Nonnull resultDic) {
        NSString *resultCode = [resultDic objectForKey:@"resultCode"];
        if ([PNSCodeLoginControllerPresentSuccess isEqualToString:resultCode]) {
            NSLog(@"授权页拉起成功回调：%@", resultDic);
            [MBProgressHUD hideHUD];
        } else if ([PNSCodeLoginControllerClickCancel isEqualToString:resultCode] ||
                   [PNSCodeLoginControllerClickLoginBtn isEqualToString:resultCode] ||
                   [PNSCodeLoginControllerClickCheckBoxBtn isEqualToString:resultCode] ||
                   [PNSCodeLoginControllerClickProtocol isEqualToString:resultCode] ||
                   [PNSCodeLoginClickPrivacyAlertView isEqualToString:resultCode] ||
                   [PNSCodeLoginPrivacyAlertViewClickContinue isEqualToString:resultCode] ||
                   [PNSCodeLoginPrivacyAlertViewClose isEqualToString:resultCode] ||
                   [PNSCodeLoginPrivacyAlertViewPrivacyContentClick isEqualToString:resultCode]) {
            //            NSLog(@"页面点击事件回调：%@", resultDic);
        } else if ([PNSCodeLoginControllerClickChangeBtn isEqualToString:resultCode]) {
            NSLog(@"其他按钮点击回调：%@", resultDic);

            [UMCommonHandler cancelLoginVCAnimated:YES complete:^{
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[LoginSmsSendViewController alloc] init]];
                
                navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
                navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                
                [[Utils currentViewController] presentViewController:navigationController animated:YES completion:nil];
                
            }];
        } else if ([PNSCodeSuccess isEqualToString:resultCode]) {
            NSLog(@"获取LoginToken成功回调：%@", resultDic);
            NSLog(@"接下来可以拿着Token去服务端换取手机号，有了手机号就可以登录，SDK提供服务到此结束");

            [MBProgressHUD showLoading];
            NSString *token = [resultDic objectForKey:@"token"];

            [UMCommonHandler cancelLoginVCAnimated:YES complete:nil];
        } else {
            NSLog(@"获取LoginToken或拉起授权页失败回调：%@", resultDic);
            //失败后可以跳转到短信登录界面
            LoginSmsSendViewController *vc = [[LoginSmsSendViewController alloc] init];
            [[Utils currentViewController] presentViewController:vc animated:YES completion:nil];
        }
    }];
}

@end
