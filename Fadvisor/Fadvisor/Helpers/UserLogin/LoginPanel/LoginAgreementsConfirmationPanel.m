//
//  LoginAgreementsConfirmationPanel.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/10/13.
//

#import "LoginAgreementsConfirmationPanel.h"
#import <LEEAlert/LEEAlert.h>
#import "ImageButton.h"

@interface LoginAgreementsConfirmationPanel ()

@property (nonatomic) CGFloat viewWidth;

@property (nonatomic, copy) void (^ confirmBlock)(void);

@end

@implementation LoginAgreementsConfirmationPanel

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
    titleLabel.text = @"请阅读并同意以下条款";
    titleLabel.textColor = [UIColor titleTextColor];
    titleLabel.topPos.equalTo(self.topPos);
    titleLabel.centerXPos.equalTo(self.centerXPos);
    [titleLabel sizeToFit];
    [self addSubview:titleLabel];

    YYLabel *textLabel = [YYLabel new];
    textLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.myHeight = MyLayoutSize.wrap;
    textLabel.myHorzMargin = 0;
    textLabel.topPos.equalTo(titleLabel.bottomPos).offset(32);
    textLabel.centerXPos.equalTo(self.centerXPos);

    //设置整段字符串的颜色
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:14], NSForegroundColorAttributeName: [UIColor metaTextColor] };

    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"用户协议和隐私保护指引" attributes:attributes];
    //设置高亮色和点击事件
    [text setTextHighlightRange:[[text string] rangeOfString:@"用户协议"] color:[UIColor mainColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
        NSLog(@"点击了《用户协议》");
    }];
    //设置高亮色和点击事件
    [text setTextHighlightRange:[[text string] rangeOfString:@"隐私保护指引"] color:[UIColor mainColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
        NSLog(@"点击了《隐私政策》");
    }];
    textLabel.attributedText = text;

    [self addSubview:textLabel];

    MyLinearLayout *agreeLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    agreeLayout.myHorzMargin = 0;
    agreeLayout.myHeight = 50;
    agreeLayout.gravity = MyGravity_Center;
    agreeLayout.backgroundColor = [UIColor mainColor];
    agreeLayout.highlightedOpacity = 0.5;
    agreeLayout.layer.masksToBounds = YES;
    agreeLayout.layer.cornerRadius = 25;
    agreeLayout.topPos.equalTo(textLabel.bottomPos).offset(32);
    [agreeLayout setTarget:self action:@selector(agreeClicked:)];
    [self addSubview:agreeLayout];

    UILabel *agreeTextLabel = [UILabel new];
    [agreeTextLabel setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightSemibold]];
    agreeTextLabel.textColor = [UIColor whiteColor];
    agreeTextLabel.text = @"同意并继续";
    [agreeTextLabel sizeToFit];
    [agreeLayout addSubview:agreeTextLabel];
}

#pragma mark - Acitons

- (void)closeButtonClicked:(UIView *)sender {
    // 关闭当前显示的Alert或ActionSheet
    [LEEAlert closeWithIdentifier:NSStringFromClass([self class]) completionBlock:nil];
}

- (void)agreeClicked:(UIView *)sender {
    Weak(self);
    [LEEAlert closeWithIdentifier:NSStringFromClass([self class]) completionBlock:^{
        !weakself.confirmBlock ? : weakself.confirmBlock();
        weakself.confirmBlock = nil;
    }];
}

- (void)showPanelWithBlock:(void (^)(void))confirmBlock {
    self.confirmBlock = confirmBlock;

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
    .LeePriority(3)
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
    static LoginAgreementsConfirmationPanel *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

@end
