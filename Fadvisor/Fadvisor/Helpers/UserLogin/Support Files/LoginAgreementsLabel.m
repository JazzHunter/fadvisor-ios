//
//  LoginAgreementsLabel.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/10/12.
//

#import "LoginAgreementsLabel.h"
#import "ImageButton.h"

@interface LoginAgreementsLabel()

@property(nonatomic, strong) ImageButton *checkBoxButton;

@end

@implementation LoginAgreementsLabel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isAgreeSelect = NO;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.orientation = MyOrientation_Horz;
//    self.subviewHSpace = 4;
    self.gravity = MyGravity_Vert_Center;

    _checkBoxButton = [[ImageButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24) imageName:@"icon_uncheck" imageSize:CGSizeMake(14, 14)];
    [_checkBoxButton setImage:[UIImage imageNamed:@"icon_check"] forState:UIControlStateSelected];
    [_checkBoxButton addTarget:self action:@selector(checkBoxButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_checkBoxButton];

    YYLabel *textLabel = [YYLabel new];
    textLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    textLabel.textAlignment = NSTextAlignmentLeft;
    textLabel.myHeight = MyLayoutSize.wrap;
    textLabel.weight = 1;

    //设置整段字符串的颜色
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:13], NSForegroundColorAttributeName: [UIColor metaTextColor] };

    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"我已阅读并同意用户协议和隐私保护指引" attributes:attributes];
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
}

- (void)checkBoxButtonClicked:(UIButton *)sender {
    self.isAgreeSelect = !self.isAgreeSelect;
    sender.selected = self.isAgreeSelect;
}

- (void)agree {
    self.isAgreeSelect = YES;
}

@end
