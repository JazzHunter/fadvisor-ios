//
//  AlyunVodTopView.m
//

#import "PlayerDetailsControlTopView.h"
#import "Utils.h"
#import "ImageButton.h"

#define kLeftRightViewHorzPadding  8.0
#define kLeftRightViewStandardSize 44.0

@interface PlayerDetailsControlTopView ()

@property (nonatomic, strong) UILabel *titleLabel;          //标题
@property (nonatomic, strong) ImageButton *backButton;      //返回按钮
@property (nonatomic, strong) ImageButton *moreButton;      //返回按钮

@end

@implementation PlayerDetailsControlTopView

#pragma mark - set And get

- (ImageButton *)backButton {
    if (!_backButton) {
        _backButton = [[ImageButton alloc] initWithFrame:CGRectMake(0, 0, kLeftRightViewStandardSize, kLeftRightViewStandardSize) imageName:@"player_back"];
        _backButton.imageSize = CGSizeMake(36, 36);
        _backButton.leftPos.equalTo(self.leftPos);
        _backButton.centerYPos.equalTo(@0);
        [_backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (ImageButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [[ImageButton alloc] initWithFrame:CGRectMake(0, 0, kLeftRightViewStandardSize, kLeftRightViewStandardSize) imageName:@"player_more"];
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
        _titleLabel.centerYPos.equalTo(@0);
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

#pragma mark - init
- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor redColor];
        [self addSubview:self.backButton];
        [self addSubview:self.moreButton];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)titleText {
    self.titleLabel.text = titleText;
}

- (void)resetLayout:(BOOL)isPortrait {
    if (isPortrait) {
        
    } else {
        
    }
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
