//
//  LoginSmsSendViewController.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/10/10.
//

#import "LoginSmsSendViewController.h"
#import "UITextField+Format.h"
#import "LoginAgreementsLabel.h"
#import "LoginSocialButtonsView.h"
#import "LoginSmsFillViewController.h"
#import "LoginService.h"
#import "NotificationView.h"
#import "LoginAgreementsConfirmationPanel.h"

@interface LoginSmsSendViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *regionCodeButton;

@property (nonatomic, strong) UITextField *phoneNumTextfield;

@property (nonatomic, strong) UIButton *sendSmsButton;

@property (nonatomic, strong) UIButton *passwordLoginButton;

@property (nonatomic, strong) LoginAgreementsLabel *agreementsLabel;

@end

@implementation LoginSmsSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI {
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"短信验证码登录";
    titleLabel.font = [UIFont systemFontOfSize:28 weight:UIFontWeightSemibold];
    titleLabel.textColor = [UIColor titleTextColor];
    [titleLabel sizeToFit];
    titleLabel.topPos.equalTo(self.navigationBar.bottomPos).offset(32);
    titleLabel.myHorzMargin = ViewHorizonlMargin * 2;

    [self.rootLayout addSubview:titleLabel];

    UILabel *descLabel = [UILabel new];
    descLabel.text = @"未注册手机验证后自动登录";
    descLabel.font = [UIFont systemFontOfSize:13];
    descLabel.textColor = [UIColor metaTextColor];
    [descLabel sizeToFit];
    descLabel.topPos.equalTo(titleLabel.bottomPos).offset(6);
    descLabel.leftPos.equalTo(titleLabel.leftPos);

    [self.rootLayout addSubview:descLabel];

    MyLinearLayout *phoneNumberLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    phoneNumberLayout.subviewSpace = 4;
    phoneNumberLayout.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
    phoneNumberLayout.topPos.equalTo(descLabel.bottomPos).offset(64);
    phoneNumberLayout.myHorzMargin = ViewHorizonlMargin * 2;
    phoneNumberLayout.gravity = MyGravity_Vert_Center;
    phoneNumberLayout.bottomBorderline = [[MyBorderline alloc] initWithColor:[UIColor borderColor] thick:1];
    phoneNumberLayout.paddingBottom = 6;
    [self.rootLayout addSubview:phoneNumberLayout];

    _regionCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _regionCodeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_regionCodeButton setTitleColor:[UIColor titleTextColor] forState:UIControlStateNormal];
    [_regionCodeButton setTitle:@"+ 86" forState:UIControlStateNormal];
    [_regionCodeButton addTarget:self action:@selector(regionCodeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_regionCodeButton sizeToFit];
    [phoneNumberLayout addSubview:_regionCodeButton];

    UIImageView *downImageView = [[UIImageView alloc] initWithImage:[[[[UIImage imageNamed:@"ic_down"] imageWithTintColor:[UIColor metaTextColor]] scaleToSize:CGSizeMake(12, 12)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [phoneNumberLayout addSubview:downImageView];

    UIView *verticalDivider = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 12)];
    verticalDivider.backgroundColor = [UIColor borderColor];
    [phoneNumberLayout addSubview:verticalDivider];

    _phoneNumTextfield = [[UITextField alloc] init];
    _phoneNumTextfield.myHeight = MyLayoutSize.wrap;
    _phoneNumTextfield.weight = 1;
    _phoneNumTextfield.placeholder = @"请输入手机号";
    _phoneNumTextfield.style = UIInputTextFieldStyle_Phone;
    _phoneNumTextfield.keyboardType = UIKeyboardTypePhonePad;
//    [_phoneNumTextfield setValue:[UIColor metaTextColor] forKeyPath:@"_placeholderLabel.textColor"];
    _phoneNumTextfield.font = [UIFont systemFontOfSize:15];
    [phoneNumberLayout addSubview:_phoneNumTextfield];

    _sendSmsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendSmsButton.myHorzMargin = ViewHorizonlMargin * 2;
    _sendSmsButton.myHeight = 50;
    _sendSmsButton.backgroundColor = [UIColor mainColor];
    [_sendSmsButton.titleLabel setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightSemibold]];
    [_sendSmsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sendSmsButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    _sendSmsButton.layer.masksToBounds = YES;
    _sendSmsButton.layer.cornerRadius = 25;
    _sendSmsButton.centerYPos.equalTo(self.rootLayout.centerYPos);
    [_sendSmsButton addTarget:self action:@selector(sendSmsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

//    [_sendSmsButton addTarget:self action:@selector(handleTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.rootLayout addSubview:_sendSmsButton];

    _passwordLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _passwordLoginButton.myHorzMargin = ViewHorizonlMargin * 2;
    _passwordLoginButton.myHeight = 50;
    _passwordLoginButton.backgroundColor = [UIColor backgroundColorGray];
    [_passwordLoginButton.titleLabel setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightSemibold]];
    [_passwordLoginButton setTitleColor:[UIColor titleTextColor] forState:UIControlStateNormal];
    [_passwordLoginButton setTitle:@"密码登录" forState:UIControlStateNormal];
    _passwordLoginButton.layer.masksToBounds = YES;
    _passwordLoginButton.layer.cornerRadius = 25;
    _passwordLoginButton.topPos.equalTo(_sendSmsButton.bottomPos).offset(16);
    [_passwordLoginButton addTarget:self action:@selector(passwordLoginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [_passwordLoginButton addTarget:self action:@selector(handleTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.rootLayout addSubview:_passwordLoginButton];

    _agreementsLabel = [LoginAgreementsLabel new];
    _agreementsLabel.myHorzMargin = ViewHorizonlMargin * 2;
    _agreementsLabel.myHeight = MyLayoutSize.wrap;
    _agreementsLabel.topPos.equalTo(_passwordLoginButton.bottomPos).offset(12);
    [self.rootLayout addSubview:_agreementsLabel];

    LoginSocialButtonsView *socialButtonsView = [LoginSocialButtonsView new];
    socialButtonsView.myHorzMargin = 0;
    socialButtonsView.bottomPos.equalTo(self.rootLayout.bottomPos).offset(64);
    [self.rootLayout addSubview:socialButtonsView];
}

#pragma mark - Actions

- (void)handleTouchDown:(UIButton *)sender {
    sender.transform = CGAffineTransformIdentity;
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:0 animations: ^{
        sender.alpha = 0.5;
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:0.3 delay:0 options:0 animations: ^{
            sender.alpha = 1;
        } completion:nil];
    }];
}

- (void)sendSmsButtonClicked:(UIView *)sender {
    // TODO
    // 验证手机号格式正确
    if (!_agreementsLabel.isAgreeSelect) {
        Weak(self);
        [[LoginAgreementsConfirmationPanel sharedInstance] showPanelWithBlock:^{
            [weakself sendSmsAndNaviToNext];
        }];
    } else {
        [self sendSmsAndNaviToNext];
    }
}

- (void)sendSmsAndNaviToNext {
    [MBProgressHUD showLoading];
    Weak(self);
    NSString *phone = _phoneNumTextfield.text.copy;
    [[LoginService sharedInstance] sendLoginPhoneSms:[phone stringByReplacingOccurrencesOfString:@" " withString:@""] completion:^(NSString *_Nonnull errorMsg) {
        [MBProgressHUD hideHUD];
        if (errorMsg) {
            [NotificationView showNotificaiton:errorMsg type:NotificationDanger];
            return;
        }
        [NotificationView showNotificaiton:@"手机验证码发送成功" type:NotificationSuccess];

        LoginSmsFillViewController *vc = [[LoginSmsFillViewController alloc] initWithPhone:weakself.phoneNumTextfield.text];
        UINavigationController *nc = self.navigationController;
        [nc pushViewController:vc animated:YES];
    }];
}

- (void)passwordLoginButtonClicked:(UIView *)sender {
}

- (void)regionCodeButtonClicked:(UIView *)sender {
}

#pragma mark - UITextFieldDelegate
// https://blog.csdn.net/yejiajun945/article/details/51743671
// 监听键盘Return事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    switch (textField.returnKeyType) {
        // 键盘为done的Case
        case UIReturnKeyDone:
            [textField resignFirstResponder];
            break;

        default:
            break;
    }
    return YES;
}

#pragma mark - 监听View点击事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    // 如果点击到UITextField以外的View则收回键盘
    if (![touch.view isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
    }
}

#pragma mark - NavigationBarDataSource
- (UIImage *)navigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(NavigationBar *)navigationBar {
    return [[[[UIImage imageNamed:@"ic_close"] imageWithTintColor:[UIColor metaTextColor]] scaleToSize:CGSizeMake(24, 24)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (BOOL)navigationBarHideBottomLine:(NavigationBar *)navigationBar {
    return YES;
}

#pragma mark - NavigationBarDelegate
- (void)leftButtonEvent:(UIButton *)sender navigationBar:(NavigationBar *)navigationBar {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
