//
//  PlayerDetailsPopErrorView.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/22.
//

#import "PlayerDetailsPopErrorView.h"
#import "Utils.h"

@interface PlayerDetailsPopErrorView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIButton *button;

@end

@implementation PlayerDetailsPopErrorView

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(0, 0, 160, 40);
        _button.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
        _button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_button setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
        [_button setTitle:[@"点击重试" localString] forState:UIControlStateNormal];
        _button.clipsToBounds = YES;
        [_button.layer setBorderColor:[UIColor mainColor].CGColor];
        _button.layer.borderWidth = 2;
        [_button setCornerRadius:6];
        [_button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 180, 180)];
        _imageView.image = [UIImage imageNamed:@"exception_error"];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.textColor = [UIColor whiteColor];
//        _textLabel.frame = CGRectMake(0, 0, 160, 80);
        _textLabel.heightSize.equalTo(@(MyLayoutSize.wrap));
        _textLabel.numberOfLines = 0;
    }
    return _textLabel;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        blurView.alpha = 0.9; // 控制模糊程度
        blurView.myMargin = 0;
        [self addSubview:blurView];
        
//        self.gravity = MyGravity_Center;
        
        self.textLabel.centerYPos.equalTo(self.centerYPos).offset(-(16 + 40) / 2); // 网上移动button的距离
        [self addSubview:self.textLabel];
        
        self.button.centerXPos.equalTo(self.textLabel.centerXPos);
        self.button.leftPos.equalTo(self.textLabel.leftPos);
        self.button.topPos.equalTo(self.textLabel.bottomPos).offset(16);
        [self addSubview:self.button];
        
        self.imageView.centerYPos.equalTo(self.centerYPos);
        self.imageView.rightPos.equalTo(self.textLabel.leftPos);
        [self addSubview:self.imageView];
        
        [self hide];
    }
    return self;
}

- (void)btnClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onButtonClickedWithPopErrorView:errorView:)]) {
        [self.delegate onButtonClickedWithPopErrorView:sender errorView:self];
    }
}

- (void)showWithMessage:(NSString *)errorMessage {
    self.textLabel.text = errorMessage;
    [self.textLabel sizeToFit];
    self.textLabel.textAlignment = errorMessage.length > 20 ? NSTextAlignmentLeft : NSTextAlignmentCenter;
    self.hidden = NO;
    self.isShow = YES;
}

- (void)hide {
    self.hidden = YES;
    self.isShow = NO;
}

- (void)resetLayout:(BOOL)isPortrait {
    self.imageView.visibility = isPortrait ? MyVisibility_Invisible : MyVisibility_Visible;
    
    self.textLabel.centerXPos.equalTo(self.centerXPos).offset(isPortrait ? 0 : 120);
    self.textLabel.widthSize.equalTo(self.widthSize).multiply(isPortrait ? 0.64 : 0.5);
    
    self.button.centerXPos.active = isPortrait;
    self.button.leftPos.active = !isPortrait;
}


@end
