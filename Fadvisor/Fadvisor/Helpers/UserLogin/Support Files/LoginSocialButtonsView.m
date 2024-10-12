//
//  LoginSocialButtonsView.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/10/12.
//

#import "LoginSocialButtonsView.h"
#import "ImageButton.h"
#import "UMengHelper.h"

#define btnSize 44.f

@implementation LoginSocialButtonsView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.orientation = MyOrientation_Horz;
    self.gravity = MyGravity_Horz_Among | MyGravity_Vert_Center;
    self.myHeight = MyLayoutSize.wrap;

    ImageButton *wechatLoginBtn = [[ImageButton alloc] initWithFrame:CGRectMake(0, 0, btnSize, btnSize) imageName:@"ic_wechat_round"];
    [wechatLoginBtn addTarget:self action:@selector(wechatLoginBtnclicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:wechatLoginBtn];

    ImageButton *qqLoginBtn = [[ImageButton alloc] initWithFrame:CGRectMake(0, 0, btnSize, btnSize) imageName:@"ic_qq_round"];
    [wechatLoginBtn addTarget:self action:@selector(qqLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:qqLoginBtn];

    ImageButton *sinaLoginBtn = [[ImageButton alloc] initWithFrame:CGRectMake(0, 0, btnSize, btnSize) imageName:@"ic_weibo_round"];
    [wechatLoginBtn addTarget:self action:@selector(sinaLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sinaLoginBtn];
}

- (void)wechatLoginBtnclicked:(UIView *)sender {
    [UMengHelper getUserInfoForPlatform:UMSocialPlatformType_WechatSession completion:^(id result, NSError *error) {
        if (error) {
            [MBProgressHUD showError:[error description] ToView:nil];
        } else {
            UMSocialUserInfoResponse *resp = result;
            // 授权信息
            NSLog(@"Wechat uid: %@", resp.uid);
            NSLog(@"Wechat openid: %@", resp.openid);
            NSLog(@"Wechat unionid: %@", resp.unionId);
            NSLog(@"Wechat accessToken: %@", resp.accessToken);
            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
            NSLog(@"Wechat expiration: %@", resp.expiration);
            // 用户信息
            NSLog(@"Wechat name: %@", resp.name);
            NSLog(@"Wechat iconurl: %@", resp.iconurl);
            NSLog(@"Wechat gender: %@", resp.unionGender);
            // 第三方平台SDK源数据
            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
        }
    }];
}

- (void)qqLoginBtn:(UIView *)sender {
    [UMengHelper getUserInfoForPlatform:UMSocialPlatformType_QQ completion:^(id result, NSError *error) {
        if (error) {
            [MBProgressHUD showError:[error description] ToView:nil];
        } else {
            UMSocialUserInfoResponse *resp = result;
            // 授权信息
            NSLog(@"Wechat uid: %@", resp.uid);
            NSLog(@"Wechat openid: %@", resp.openid);
            NSLog(@"Wechat unionid: %@", resp.unionId);
            NSLog(@"Wechat accessToken: %@", resp.accessToken);
            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
            NSLog(@"Wechat expiration: %@", resp.expiration);
            // 用户信息
            NSLog(@"Wechat name: %@", resp.name);
            NSLog(@"Wechat iconurl: %@", resp.iconurl);
            NSLog(@"Wechat gender: %@", resp.unionGender);
            // 第三方平台SDK源数据
            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
        }
    }];
}

- (void)sinaLoginBtn:(UIView *)sender {
    [UMengHelper getUserInfoForPlatform:UMSocialPlatformType_Sina completion:^(id result, NSError *error) {
        if (error) {
            [MBProgressHUD showError:[error description] ToView:nil];
        } else {
            UMSocialUserInfoResponse *resp = result;
            // 授权信息
            NSLog(@"Wechat uid: %@", resp.uid);
            NSLog(@"Wechat openid: %@", resp.openid);
            NSLog(@"Wechat unionid: %@", resp.unionId);
            NSLog(@"Wechat accessToken: %@", resp.accessToken);
            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
            NSLog(@"Wechat expiration: %@", resp.expiration);
            // 用户信息
            NSLog(@"Wechat name: %@", resp.name);
            NSLog(@"Wechat iconurl: %@", resp.iconurl);
            NSLog(@"Wechat gender: %@", resp.unionGender);
            // 第三方平台SDK源数据
            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
        }
    }];
}

@end
