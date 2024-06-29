//
//  AlyunVodTopView.m
//

#import "PlayerDetailsControlTopView.h"
#import "Utils.h"
#import "ImageButton.h"

#define kLeftRightViewHorzPadding  8.0

@interface PlayerDetailsControlTopView ()

@property (nonatomic, strong) UILabel *titleLabel;          //标题
@property (nonatomic, strong) CAGradientLayer *gradientLayer; //渐变色背景涂层
@property (nonatomic, strong) ImageButton *backButton;      //返回按钮
@property (nonatomic, strong) ImageButton *moreButton;      //返回按钮
@end

@implementation PlayerDetailsControlTopView

#pragma mark - set And get

- (ImageButton *)backButton {
    if (!_backButton) {
        _backButton = [[ImageButton alloc] initWithFrame:CGRectMake(0, 0, kButtonStandardSize, kButtonStandardSize) imageName:@"player_back"];
        _backButton.imageSize = CGSizeMake(36, 36);
        _backButton.leftPos.equalTo(self.leftPos);
        self.backButton.centerYPos.equalTo(self.centerYPos).offset(0);
        [_backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (ImageButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [[ImageButton alloc] initWithFrame:CGRectMake(0, 0, kButtonStandardSize, kButtonStandardSize) imageName:@"player_more"];
        _moreButton.imageSize = CGSizeMake(32, 32);
        _moreButton.rightPos.equalTo(self.rightPos);
        _moreButton.centerYPos.equalTo(@0);
        [_moreButton addTarget:self action:@selector(moreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.weight = UIFontWeightMedium;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.myHeight = MyLayoutSize.wrap;
        _titleLabel.leftPos.equalTo(_backButton.rightPos);
        _titleLabel.rightPos.equalTo(_moreButton.leftPos);
        _titleLabel.centerYPos.equalTo(_backButton.centerYPos);
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.colors = @[(id)[[UIColor colorFromHexString:@"333333"] colorWithAlphaComponent:1].CGColor, (id)[[UIColor colorFromHexString:@"333333"] colorWithAlphaComponent:0].CGColor]; //设置渐变颜色
        _gradientLayer.locations = @[@0.0, @0.8]; //颜色的起点位置，递增，并且数量跟颜色数量相等
        _gradientLayer.startPoint = CGPointMake(0.5, 0); //
        _gradientLayer.endPoint = CGPointMake(0.5, 1); //
        [self.layer insertSublayer:_gradientLayer atIndex:0];
    }
    return _gradientLayer;
}

#pragma mark - init
- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.backButton];
        [self addSubview:self.moreButton];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.gradientLayer.frame = self.bounds;
}

- (void)resetLayout:(BOOL)isPortrait {
    if (isPortrait) {
    } else {
    }
}

- (void)setTitle:(NSString *)titleText {
    self.titleLabel.text = titleText;
}

#pragma mark - ButtonClicked
- (void)backButtonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onTopViewBackButtonClicked:topView:)]) {
        [self.delegate onTopViewBackButtonClicked:sender topView:self];
    }
}

- (void)moreButtonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onTopViewMoreButtonClicked:topView:)]) {
        [self.delegate onTopViewMoreButtonClicked:sender topView:self];
    }
}

@end
