//
//  LoginSmsFillViewController.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/10/13.
//

#import "LoginSmsFillViewController.h"
#import "SecurityCodeView.h"

@interface LoginSmsFillViewController ()

@property (nonatomic, copy) NSString *phoneNumber;

@end

@implementation LoginSmsFillViewController

- (instancetype)initWithPhone:(NSString *)phoneNumber {
    self = [super init];
    if (self) {
        self.phoneNumber = phoneNumber.copy;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"输入验证码";
    titleLabel.font = [UIFont systemFontOfSize:28 weight:UIFontWeightSemibold];
    titleLabel.textColor = [UIColor titleTextColor];
    [titleLabel sizeToFit];
    titleLabel.topPos.equalTo(self.navigationBar.bottomPos).offset(32);
    titleLabel.myHorzMargin = ViewHorizonlMargin * 2;

    [self.rootLayout addSubview:titleLabel];

    UILabel *descLabel = [UILabel new];
    descLabel.text = [NSString stringWithFormat:@"验证码已发送至 +86 %@", self.phoneNumber];
    descLabel.font = [UIFont systemFontOfSize:13];
    descLabel.textColor = [UIColor metaTextColor];
    [descLabel sizeToFit];
    descLabel.topPos.equalTo(titleLabel.bottomPos).offset(6);
    descLabel.leftPos.equalTo(titleLabel.leftPos);

    [self.rootLayout addSubview:descLabel];
    
    SecurityCodeView *codeView = [[SecurityCodeView alloc]initWithFrame:CGRectMake(0, 0, self.view.width - ViewHorizonlMargin * 4, 100) count:4 space:24 type:securityCodeTypeDownLine];
    codeView.defaultColor = [UIColor borderColor];
    codeView.selectedColor = [UIColor descriptionTextColor];
    codeView.markColor = [UIColor mainColor];
    codeView.topPos.equalTo(descLabel.bottomPos).offset(64);
    codeView.leftPos.equalTo(self.rootLayout.leftPos).offset(ViewHorizonlMargin * 2);
    [self.rootLayout addSubview:codeView];
}
@end
