//
//  LoginPanel.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/10/12.
//

#import "LoginPanel.h"
#import <LEEAlert/LEEAlert.h>
#import "ImageButton.h"
#import "LoginAgreementsLabel.h"
#import "LoginSmsSendViewController.h"
#import "Utils.h"
#import "LoginAgreementsConfirmationPanel.h"
#import "OtherLoginPanel.h"

@interface LoginPanel ()

@property (nonatomic) CGFloat viewWidth;
@property (nonatomic, strong) LoginAgreementsLabel *agreementsLabel;

@end

@implementation LoginPanel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat screenWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
        CGFloat screenHeight = CGRectGetHeight([[UIScreen mainScreen] bounds]);
        self.viewWidth = screenWidth > screenHeight ? screenHeight : screenWidth;

        self.backgroundColor = [UIColor backgroundColor];
        self.mySize = CGSizeMake(self.viewWidth, MyLayoutSize.wrap);
//        self.insetsPaddingFromSafeArea = UIRectEdgeBottom;
        self.padding = UIEdgeInsetsMake(24, ViewHorizonlMargin, 24, ViewHorizonlMargin);
        self.backgroundImage = [UIImage imageNamed:@"login_alert_bg"];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    ImageButton *closeButton = [[ImageButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24) imageName:@"ic_close" color:[UIColor metaTextColor]];
    [closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    closeButton.topPos.equalTo(self.topPos);
    closeButton.rightPos.equalTo(self.rightPos);
    [self addSubview:closeButton];

    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightSemibold];
    titleLabel.text = [NSString stringWithFormat:@"欢迎登录%@", AppName];
    titleLabel.textColor = [UIColor titleTextColor];
    titleLabel.topPos.equalTo(closeButton.bottomPos).offset(12);
    titleLabel.leftPos.equalTo(self.leftPos);
    [titleLabel sizeToFit];
    [self addSubview:titleLabel];

    UILabel *descriptionLabel = [UILabel new];
    descriptionLabel.font = [UIFont systemFontOfSize:13];
    descriptionLabel.text = @"登录后享受更多精彩功能";
    descriptionLabel.textColor = [UIColor descriptionTextColor];
    descriptionLabel.topPos.equalTo(titleLabel.bottomPos).offset(6);
    descriptionLabel.leftPos.equalTo(self.leftPos);
    [descriptionLabel sizeToFit];
    [self addSubview:descriptionLabel];

    MyLinearLayout *phoneLoginLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    phoneLoginLayout.myHorzMargin = 0;
    phoneLoginLayout.myHeight = 50;
    phoneLoginLayout.subviewHSpace = 6;
    phoneLoginLayout.gravity = MyGravity_Center;
    phoneLoginLayout.backgroundColor = [UIColor mainColor];
    phoneLoginLayout.highlightedOpacity = 0.5;
    phoneLoginLayout.layer.masksToBounds = YES;
    phoneLoginLayout.layer.cornerRadius = 25;
    phoneLoginLayout.topPos.equalTo(descriptionLabel.bottomPos).offset(42);
    [phoneLoginLayout setTarget:self action:@selector(phoneLoginClicked:)];
    [self addSubview:phoneLoginLayout];

    UIImageView *phoneIconImageView = [[UIImageView alloc] initWithImage:[[[[UIImage imageNamed:@"ic_phone"] imageWithTintColor:[UIColor whiteColor]] scaleToSize:CGSizeMake(20, 20)] imageWithRenderingMode:(UIImageRenderingModeAutomatic)]];
    [phoneLoginLayout addSubview:phoneIconImageView];

    UILabel *phoneLoginText = [UILabel new];
    [phoneLoginText setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightSemibold]];
    phoneLoginText.textColor = [UIColor whiteColor];
    phoneLoginText.text = @"手机号登录";
    [phoneLoginText sizeToFit];
    [phoneLoginLayout addSubview:phoneLoginText];

    MyLinearLayout *wechatLoginLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    wechatLoginLayout.myHorzMargin = 0;
    wechatLoginLayout.myHeight = 50;
    wechatLoginLayout.subviewHSpace = 6;
    wechatLoginLayout.gravity = MyGravity_Center;
    wechatLoginLayout.backgroundColor = [UIColor backgroundColorGray];
    wechatLoginLayout.highlightedOpacity = 0.5;
    wechatLoginLayout.layer.masksToBounds = YES;
    wechatLoginLayout.layer.cornerRadius = 25;
    wechatLoginLayout.topPos.equalTo(phoneLoginLayout.bottomPos).offset(12);
    [wechatLoginLayout setTarget:self action:@selector(wechatClicked:)];
    [self addSubview:wechatLoginLayout];

    UIImageView *wechatIconImageView = [[UIImageView alloc] initWithImage:[[[UIImage imageNamed:@"ic_wechat_color"] scaleToSize:CGSizeMake(20, 20)] imageWithRenderingMode:(UIImageRenderingModeAutomatic)]];
    [wechatLoginLayout addSubview:wechatIconImageView];

    UILabel *wechatLoginText = [UILabel new];
    [wechatLoginText setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightSemibold]];
    wechatLoginText.textColor = [UIColor titleTextColor];
    wechatLoginText.text = @"微信登录";
    [wechatLoginText sizeToFit];
    [wechatLoginLayout addSubview:wechatLoginText];

    UIButton *otherLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [otherLoginButton.titleLabel setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightSemibold]];
    [otherLoginButton setTitleColor:[UIColor descriptionTextColor] forState:UIControlStateNormal];
    [otherLoginButton setTitle:@"其他登录方式 >" forState:UIControlStateNormal];
    [otherLoginButton sizeToFit];
    otherLoginButton.centerXPos.equalTo(self.centerXPos);
    otherLoginButton.topPos.equalTo(wechatLoginLayout.bottomPos).offset(12);
    [otherLoginButton addTarget:self action:@selector(otherLoginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:otherLoginButton];

    _agreementsLabel = [LoginAgreementsLabel new];
    _agreementsLabel.myHorzMargin = 0;
    _agreementsLabel.myHeight = MyLayoutSize.wrap;
    _agreementsLabel.topPos.equalTo(otherLoginButton.bottomPos).offset(24);
    [self addSubview:_agreementsLabel];
}

#pragma mark - Acitons

- (void)closeButtonClicked:(UIView *)sender {
    // 关闭当前显示的Alert或ActionSheet
    [LEEAlert closeWithIdentifier:NSStringFromClass([self class]) completionBlock:nil];
}

- (void)phoneLoginClicked:(UIView *)sender {
    [LEEAlert closeWithIdentifier:NSStringFromClass([self class]) completionBlock:^{
        LoginSmsSendViewController *vc = [[LoginSmsSendViewController alloc] init];
        [[Utils currentViewController] presentViewController:vc animated:YES completion:nil];
    }];
}

- (void)otherLoginButtonClicked:(UIView *)sender {
    [[OtherLoginPanel sharedInstance] showPanel];
}

- (void)wechatClicked:(UIView *)sender {
    if (!_agreementsLabel.isAgreeSelect) {
        Weak(self);
        [[LoginAgreementsConfirmationPanel sharedInstance] showPanelWithBlock:^{
            [LEEAlert clearQueue];
            [LEEAlert closeWithIdentifier:NSStringFromClass([self class]) completionBlock:nil];
            [weakself handleWeachatLogin];
        }];
    } else {
        [LEEAlert closeWithIdentifier:NSStringFromClass([self class]) completionBlock:^{
            [self handleWeachatLogin];
        }];
    }
}

// TODO
- (void)handleWeachatLogin {
    NSLog(@"微信登录");
}

- (void)showPanel {
    [LEEAlert actionsheet].config
    .LeeIdentifier(NSStringFromClass([self class]))
    .LeeAddCustomView(^(LEECustomView *custom) {
        custom.view = self;
        custom.isAutoWidth = YES;
    })
    .LeeItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeHeaderInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeActionSheetBottomMargin(0.0f)
    .LeeActionSheetBackgroundColor([UIColor backgroundColor])
    .LeeCornerRadius(10.0f)
//    .LeeBackGroundColor([UIColor grayColor])     //屏幕背景颜色
    .LeeBackgroundStyleTranslucent(0.5f)     //屏幕背景半透明样式 参数为透明度
    .LeeConfigMaxWidth(^CGFloat (LEEScreenOrientationType type, CGSize size) {     // 设置最大宽度 (根据横竖屏类型进行设置 最大高度同理)
        // 横屏类型
        if (type == LEEScreenOrientationTypeVertical) {
            return CGRectGetWidth([[UIScreen mainScreen] bounds]);
        }
        return 414.0f;
    })
    .LeeQueue(YES)
    .LeePriority(1)
    .LeeOpenAnimationConfig(^(void (^animatingBlock)(void), void (^animatedBlock)(void)) {
        [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            animatingBlock(); //调用动画中Block
        } completion:^(BOOL finished) {
            animatedBlock(); //调用动画结束Block
        }];
    })
    .LeeShow();
}

+ (instancetype)sharedInstance {
    static LoginPanel *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

@end
