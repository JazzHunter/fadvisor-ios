//
//  AlyunVodTopView.m
//

#import "PlayerDetailsControlTopView.h"
#import "Utils.h"

static const CGFloat ALYPVTopViewTitleLabelMargin = 8;  //标题 间隙
static const CGFloat ALYPVTopViewBackButtonWidth = 40;  //返回按钮宽度
static const CGFloat ALYPVTopViewDownLoadButtonWidth = 30;  //返回按钮宽度

@interface PlayerDetailsControlTopView ()

@property (nonatomic, strong) UIImageView *topBarBG;        //背景图片
@property (nonatomic, strong) UILabel *titleLabel;          //标题
@property (nonatomic, strong) UIButton *backButton;         //返回按钮
@property (nonatomic, strong) UIButton *loopViewButton;     //跑马灯按钮
@property (nonatomic, strong) UIButton *downloadButton;     //下载视频

@end
@implementation PlayerDetailsControlTopView

- (UIImageView *)topBarBG {
    if (!_topBarBG) {
        _topBarBG = [[UIImageView alloc] init];
    }
    return _topBarBG;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextColor:[UIColor colorFromHexString:@"e7e7e7"]];
        [_titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
    }
    return _titleLabel;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        UIImage *backImage = [UIImage imageNamed:@"player_back"];
        [_backButton setImage:backImage forState:UIControlStateNormal];
        [_backButton setImage:backImage forState:UIControlStateSelected];
        [_backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)speedButton {
    if (!_speedButton) {
        _speedButton = [[UIButton alloc] init];
        [_speedButton addTarget:self action:@selector(speedButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _speedButton;
}

- (UIButton *)loopViewButton {
    if (!_loopViewButton) {
        _loopViewButton = [[UIButton alloc] init];
        [_loopViewButton addTarget:self action:@selector(loopViewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loopViewButton;
}

- (UIButton *)downloadButton {
    if (!_downloadButton) {
        _downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *downloadImage = [UIImage imageNamed:@"ic_download"];
        //        _downloadButton.frame = CGRectMake(0, 0, downloadImage.size.width, downloadImage.size.height);
        [_downloadButton setBackgroundImage:downloadImage forState:UIControlStateNormal];
        [_downloadButton setBackgroundImage:downloadImage forState:UIControlStateSelected];
        [_downloadButton addTarget:self action:@selector(downloadButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        //        _downloadButton.center = CGPointMake(self.width - 16 - self.downloadButton.frame.size.width / 2, 44);
    }
    return _downloadButton;
}

#pragma mark - init
- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.topBarBG];
        [self addSubview:self.titleLabel];
        [self addSubview:self.backButton];
        [self addSubview:self.downloadButton];
        [self addSubview:self.speedButton];
        [self addSubview:self.loopViewButton];
    }
    return self;
}

- (void)setPlayMethod:(AlvcPlayMethod)playMethod {
    _playMethod = playMethod;
    if (playMethod == AlvcPlayMethodUrl) {
        self.downloadButton.hidden = true;
    } else {
        if (ScreenWidth < ScreenHeight) {
            self.downloadButton.hidden = false;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    if ([Utils isInterfaceOrientationPortrait]) {
        //竖屏
        self.speedButton.hidden = true;
        self.loopViewButton.hidden = true;
        self.downloadButton.hidden = false;
    } else {
        //横屏
        self.speedButton.hidden = false;
        self.loopViewButton.hidden = false;
        self.downloadButton.hidden = true;
    }

    CGFloat safeLeft = 0;
    if (@available(iOS 11.0, *)) {
        safeLeft = self.safeAreaInsets.left;
    }

    self.topBarBG.frame = self.bounds;

    self.backButton.frame = CGRectMake(safeLeft + ALYPVTopViewTitleLabelMargin, (height - ALYPVTopViewBackButtonWidth) / 2.0, ALYPVTopViewBackButtonWidth, ALYPVTopViewBackButtonWidth);

    self.downloadButton.frame = CGRectMake(width - ALYPVTopViewTitleLabelMargin - ALYPVTopViewDownLoadButtonWidth, (height - ALYPVTopViewDownLoadButtonWidth) / 2.0, ALYPVTopViewDownLoadButtonWidth, ALYPVTopViewDownLoadButtonWidth);

    self.speedButton.frame = CGRectMake(width - ALYPVTopViewTitleLabelMargin - 50, (height - 40) / 2.0, 50, 40);

    self.loopViewButton.frame = CGRectMake(width - ALYPVTopViewTitleLabelMargin * 4 - ALYPVTopViewDownLoadButtonWidth * 2, (height - ALYPVTopViewDownLoadButtonWidth) / 2.0, ALYPVTopViewDownLoadButtonWidth, ALYPVTopViewDownLoadButtonWidth);


    CGFloat titleWidth = width - (ALYPVTopViewBackButtonWidth + 2 * ALYPVTopViewTitleLabelMargin) - (ALYPVTopViewDownLoadButtonWidth + 2 * ALYPVTopViewTitleLabelMargin);
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.backButton.frame) + ALYPVTopViewTitleLabelMargin, 0, titleWidth, height);

    if (self.playMethod == AlvcPlayMethodLocal) {
        self.downloadButton.hidden = true;
    }
}

#pragma mark - 重写setter方法
- (void)setTopTitle:(NSString *)topTitle {
    _topTitle = topTitle;
    self.titleLabel.text = topTitle;
}

#pragma mark - ButtonClicked
- (void)backButtonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onBackViewClickWithTopView:)]) {
        [self.delegate onBackViewClickWithTopView:self];
    }
}

- (void)speedButtonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSpeedViewClickedWithTopView:)]) {
        [self.delegate onSpeedViewClickedWithTopView:self];
    }
}

- (void)loopViewButtonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(loopViewClickedWithTopView:)]) {
        [self.delegate loopViewClickedWithTopView:self];
    }
}

- (void)downloadButtonTouched:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onDownloadButtonClickWithTopView:)]) {
        [self.delegate onDownloadButtonClickWithTopView:self];
    }
}

@end
