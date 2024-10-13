//
//  OtherLoginPanel.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/10/13.
//

#import "OtherLoginPanel.h"
#import <LEEAlert/LEEAlert.h>
#import "ImageButton.h"
#import "LoginAgreementsLabel.h"
#import "LoginAgreementsConfirmationPanel.h"

#define btnSize 44.f

@interface OtherLoginPanel()

@property (nonatomic) CGFloat viewWidth;
@property (nonatomic, strong) LoginAgreementsLabel *agreementsLabel;

@end

@implementation OtherLoginPanel
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
    titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    titleLabel.text = @"选择其他登录方式";
    titleLabel.textColor = [UIColor titleTextColor];
    titleLabel.topPos.equalTo(self.topPos);
    titleLabel.centerXPos.equalTo(self.centerXPos);
    [titleLabel sizeToFit];
    [self addSubview:titleLabel];
    
    MyLinearLayout *contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    contentLayout.myHorzMargin = 0;
    contentLayout.myHeight = MyLayoutSize.wrap;
    contentLayout.gravity = MyGravity_Horz_Among | MyGravity_Vert_Center;
    contentLayout.topPos.equalTo(titleLabel.bottomPos).offset(24);
    [self addSubview:contentLayout];
    
    ImageButton *qqLoginBtn = [[ImageButton alloc] initWithFrame:CGRectMake(0, 0, btnSize, btnSize) imageName:@"ic_qq_round"];
    [qqLoginBtn addTarget:self action:@selector(qqLoginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentLayout addSubview:qqLoginBtn];
    
    ImageButton *sinaLoginBtn = [[ImageButton alloc] initWithFrame:CGRectMake(0, 0, btnSize, btnSize) imageName:@"ic_weibo_round"];
    [contentLayout addSubview:sinaLoginBtn];
    
    ImageButton *appleLoginBtn = [[ImageButton alloc] initWithFrame:CGRectMake(0, 0, btnSize, btnSize) imageName:@"ic_apple_login_round"];
    [contentLayout addSubview:appleLoginBtn];
    
    _agreementsLabel = [LoginAgreementsLabel new];
    _agreementsLabel.myHorzMargin = 0;
    _agreementsLabel.myHeight = MyLayoutSize.wrap;
    _agreementsLabel.topPos.equalTo(contentLayout.bottomPos).offset(24);
    [self addSubview:_agreementsLabel];
}

#pragma mark - Acitons

- (void)closeButtonClicked:(UIView *)sender {
    // 关闭当前显示的Alert或ActionSheet
    [LEEAlert closeWithIdentifier:NSStringFromClass([self class]) completionBlock:nil];
}

- (void)qqLoginBtnClicked:(UIView *)sender {
    if (!_agreementsLabel.isAgreeSelect) {
        Weak(self);
        [[LoginAgreementsConfirmationPanel sharedInstance] showPanelWithBlock:^{
            [LEEAlert clearQueue];
            [LEEAlert closeWithIdentifier:NSStringFromClass([self class]) completionBlock:nil];
            [weakself handleQqLogin];
        }];
    } else {
        [LEEAlert clearQueue];
        [LEEAlert closeWithIdentifier:NSStringFromClass([self class]) completionBlock:^{
            [self handleQqLogin];
        }];
    }
}

- (void)handleQqLogin {
    NSLog(@"QQ登录");
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
    .LeePriority(2)
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
    static OtherLoginPanel *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


@end
