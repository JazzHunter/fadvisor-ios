//
//  TabAccountHeaderNotLogin.m
//  Fadvisor
//
//  Created by 韩建伟 on 2023/12/19.
//

#import "TabAccountHeaderNotLoginView.h"
#import "ImageButton.h"
#import "UserLoginViewController.h"

#define btnSize 32.f

@implementation TabAccountHeaderNotLoginView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.myHeight = MyLayoutSize.wrap;
        self.padding = UIEdgeInsetsMake(12, 16, 12, 16);
        [self setupUI];
        
    }
    return self;
}

- (void) setupUI {
    UIButton *loginMainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginMainButton.titleLabel.font =  [UIFont systemFontOfSize:24 weight:UIFontWeightBold];
    loginMainButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [loginMainButton setTitleColor:[UIColor titleTextColor] forState:UIControlStateNormal];
    [loginMainButton setTitle:[@"点我登录" localString] forState:UIControlStateNormal];
    loginMainButton.leftPos.equalTo(self.leftPos);
    loginMainButton.topPos.equalTo(self.topPos);
    [loginMainButton addTarget:self action:@selector(mainBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [loginMainButton sizeToFit];
    [self addSubview:loginMainButton];
    
    UIImageView *rightArr = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_right_arr"]];
    rightArr.frame = CGRectMake(0, 0, 12, 12);
    rightArr.contentMode = UIViewContentModeScaleAspectFit;
    rightArr.leftPos.equalTo(loginMainButton.rightPos).offset(4);
    rightArr.centerYPos.equalTo(loginMainButton.centerYPos);
    [self addSubview:rightArr];
    
    ImageButton *phoneLoginBtn = [[ImageButton alloc] initWithFrame:CGRectMake(0, 0, btnSize, btnSize) imageName:@"ic_phone_round"];
    phoneLoginBtn.leftPos.equalTo(loginMainButton.leftPos);
    phoneLoginBtn.topPos.equalTo(loginMainButton.bottomPos).offset(12);
    [self addSubview:phoneLoginBtn];
    
    ImageButton *wechatLoginBtn = [[ImageButton alloc] initWithFrame:CGRectMake(0, 0, btnSize, btnSize) imageName:@"ic_wechat_round"];
    wechatLoginBtn.leftPos.equalTo(phoneLoginBtn.rightPos).offset(16);
    wechatLoginBtn.centerYPos.equalTo(phoneLoginBtn.centerYPos);
    [self addSubview:wechatLoginBtn];
    
    ImageButton *qqLoginBtn = [[ImageButton alloc] initWithFrame:CGRectMake(0, 0, btnSize, btnSize) imageName:@"ic_qq_round"];
    qqLoginBtn.leftPos.equalTo(wechatLoginBtn.rightPos).offset(16);
    qqLoginBtn.centerYPos.equalTo(phoneLoginBtn.centerYPos);
    [self addSubview:qqLoginBtn];
    
    ImageButton *sinaLoginBtn = [[ImageButton alloc] initWithFrame:CGRectMake(0, 0, btnSize, btnSize) imageName:@"ic_weibo_round"];
    sinaLoginBtn.leftPos.equalTo(qqLoginBtn.rightPos).offset(16);
    sinaLoginBtn.centerYPos.equalTo(phoneLoginBtn.centerYPos);
    [self addSubview:sinaLoginBtn];
    
    ImageButton *appleLoginBtn = [[ImageButton alloc] initWithFrame:CGRectMake(0, 0, btnSize, btnSize) imageName:@"ic_apple_login_round"];
    appleLoginBtn.leftPos.equalTo(sinaLoginBtn.rightPos).offset(16);
    appleLoginBtn.centerYPos.equalTo(phoneLoginBtn.centerYPos);
    [self addSubview:appleLoginBtn];

}

- (void)mainBtnClicked:(UIButton *)mainBtnClicked {
    UserLoginViewController *userLoginVC = [UserLoginViewController new];
    [self.viewController presentViewController:userLoginVC animated:YES completion:nil];
}


@end
