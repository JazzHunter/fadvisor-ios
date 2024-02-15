//
//  AlyunVodBottomView.m
//  playtset
//

#import "PlayerDetailsControlBottomView.h"
#import "ImageButton.h"
#import "Utils.h"
#import "DBSlider.h"

#define kLeftRightViewHorzPadding  8.0
#define kLeftRightViewStandardSize 44.0

static NSString *const BottomViewDefaultTime = @"00:00:00";    //默认时间样式

@interface PlayerDetailsControlBottomView ()

@property (nonatomic, strong) ImageButton *playButton;           //播放按钮

@property (nonatomic, strong) ImageButton *fullScreenSwitchButton;      //全屏按钮
@property (nonatomic, strong) UIButton *trackSelectButton;      //清晰度选择按钮

@property (nonatomic, strong) UIProgressView *bufferedProgressView; //缓冲条，bufferedView
@property (nonatomic, strong) DBSlider *progressSlider; //进度条

@property (nonatomic, strong) UILabel *timeLabel;    //全屏时间

@property (nonatomic, strong) MyRelativeLayout *portraitLayout;    //竖屏时候的布局
@property (nonatomic, strong) MyRelativeLayout *horizontalLayout;    //全屏时候的布局

@end

@implementation PlayerDetailsControlBottomView

#pragma mark - set And get
- (ImageButton *)playButton {
    if (!_playButton) {
        _playButton = [[ImageButton alloc] initWithFrame:CGRectMake(0, 0, kLeftRightViewStandardSize, kLeftRightViewStandardSize) imageName:@"player_play"];
        [_playButton setImage:[UIImage imageNamed:@"player_paused"] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(playButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (void)playButtonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onBottomViewPlayButtonClicked:bottomView:)]) {
        [self.delegate onBottomViewPlayButtonClicked:sender bottomView:self];
    }
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor colorFromHexString:@"e7e7e7"];
    }
    return _timeLabel;
}

- (ImageButton *)fullScreenSwitchButton {
    if (!_fullScreenSwitchButton) {
        _fullScreenSwitchButton = [[ImageButton alloc] initWithFrame:CGRectMake(0, 0, kLeftRightViewStandardSize, kLeftRightViewStandardSize) imageName:@"player_fullscreen"];
        _fullScreenSwitchButton.imageSize = CGSizeMake(20, 20);
        [_fullScreenSwitchButton enableTouchDownAnimation];
        [_fullScreenSwitchButton addTarget:self action:@selector(fullScreenButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenSwitchButton;
}

- (void)fullScreenButtonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onBottomViewFullScreenButtonClicked:bottomView:)]) {
        [self.delegate onBottomViewFullScreenButtonClicked:sender bottomView:self];
    }
}

- (UIProgressView *)bufferedProgressView {
    if (!_bufferedProgressView) {
        _bufferedProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _bufferedProgressView.progress = 0.0;
        _bufferedProgressView.trackTintColor = [UIColor clearColor];
        _bufferedProgressView.heightSize.equalTo(@2);
        //设置轨道的颜色
        _bufferedProgressView.progressTintColor = [UIColor colorFromHexString:@"e7e7e7"];
    }
    return _bufferedProgressView;
}

- (DBSlider *)progressSlider {
    if (!_progressSlider) {
        _progressSlider = [[DBSlider alloc] init];
        _progressSlider.value = 0.0;
        _progressSlider.userInteractionEnabled = YES;

        _progressSlider.minimumTrackTintColor = [UIColor mainColor]; //左侧的颜色
        _progressSlider.maximumTrackTintColor = [UIColor colorWithWhite:0.6 alpha:0.4]; //右侧的颜色
        _progressSlider.heightSize.equalTo(@2);
        //thumb图片
        [_progressSlider setThumbImage:[[UIImage imageNamed:@"player_radio_normal"] scaleToSize:CGSizeMake(32, 32)] forState:UIControlStateNormal];
        //手指落下
        [_progressSlider addTarget:self action:@selector(sliderDown:) forControlEvents:UIControlEventTouchDown];
        //手指抬起
        [_progressSlider addTarget:self action:@selector(progressSliderUpAction:) forControlEvents:UIControlEventTouchUpInside];
        //value发生变化
        [_progressSlider addTarget:self action:@selector(updateProgressSliderAction:) forControlEvents:UIControlEventValueChanged];

        [_progressSlider addTarget:self action:@selector(cancelProgressSliderAction:) forControlEvents:UIControlEventTouchCancel];

        //手指在外面抬起
        [_progressSlider addTarget:self action:@selector(updateProgressUpOutsideSliderAction:) forControlEvents:UIControlEventTouchUpOutside];
    }
    return _progressSlider;
}

- (UIButton *)trackSelectButton {
    if (!_trackSelectButton) {
        _trackSelectButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, 36)];
    }
    return _trackSelectButton;
}

- (MyRelativeLayout *)portraitLayout {
    if (!_portraitLayout) {
        _portraitLayout = [[MyRelativeLayout alloc] init];
        _portraitLayout.leftPos.equalTo(self.leftPos);
        _portraitLayout.widthSize.equalTo(self.widthSize);
        _portraitLayout.heightSize.equalTo(@(MyLayoutSize.wrap));
        _portraitLayout.gravity = MyGravity_Vert_Center;
    }
    return _portraitLayout;
}

- (MyRelativeLayout *)horizontalLayout {
    if (!_horizontalLayout) {
        _horizontalLayout = [[MyRelativeLayout alloc] init];
        _horizontalLayout.leftPos.equalTo(self.leftPos);
        _horizontalLayout.widthSize.equalTo(self.widthSize);
        _horizontalLayout.heightSize.equalTo(@(MyLayoutSize.wrap));
    }
    return _horizontalLayout;
}

#pragma mark - init
- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blueColor];
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.fullScreenSwitchButton.rightPos.equalTo(self.portraitLayout.rightPos);
    self.fullScreenSwitchButton.centerYPos.equalTo(@0);
    [self.portraitLayout addSubview:self.fullScreenSwitchButton];
    [self addSubview:self.portraitLayout];
    [self addSubview:self.horizontalLayout];
}

- (void)resetLayout:(BOOL)isPortrait {
    if (isPortrait) {
        self.horizontalLayout.hidden = YES;
        self.portraitLayout.hidden = NO;

        self.playButton.imageSize = CGSizeMake(24, 24);
        self.playButton.leftPos.equalTo(self.portraitLayout.leftPos);
        self.playButton.centerYPos.equalTo(@0);
        [self.portraitLayout addSubview:self.playButton];

        self.timeLabel.font = [UIFont systemFontOfSize:13];
        self.timeLabel.centerYPos.equalTo(@0);
        self.timeLabel.rightPos.equalTo(self.fullScreenSwitchButton.leftPos).offset(8);
        [self.portraitLayout addSubview:self.timeLabel];

        self.bufferedProgressView.leftPos.equalTo(self.playButton.rightPos).offset(12);
        self.bufferedProgressView.rightPos.equalTo(self.timeLabel.leftPos).offset(12);
        self.bufferedProgressView.centerYPos.equalTo(@0);
        [self.portraitLayout addSubview:self.bufferedProgressView];
        
        self.progressSlider.leftPos.equalTo(self.playButton.rightPos).offset(8);
        self.progressSlider.rightPos.equalTo(self.timeLabel.leftPos).offset(8);
        self.progressSlider.centerYPos.equalTo(@0);
        [self.portraitLayout addSubview:self.progressSlider];
        

    } else {
        self.horizontalLayout.hidden = NO;
        self.portraitLayout.hidden = YES;
        self.playButton.imageSize = CGSizeMake(kLeftRightViewStandardSize, kLeftRightViewStandardSize);
        [self.horizontalLayout addSubview:self.playButton];
    }
}

#pragma mark -  public method
/*
 * 功能 ：更新进度条
 * 参数 ：currentTime 当前播放时间
 durationTime 播放总时长
 */
- (void)updateProgressWithCurrentTime:(float)currentTime durationTime:(float)durationTime {
    NSString *curTimeStr = [Utils timeformatFromSeconds:roundf(currentTime)];
    NSString *totalTimeStr = [Utils timeformatFromSeconds:roundf(durationTime)];
    self.timeLabel.text = [NSString stringWithFormat:@"%@/%@", curTimeStr, totalTimeStr];
    [self.timeLabel sizeToFit];
    //进度条
    [self.progressSlider setValue:currentTime / durationTime animated:YES];
}

- (void)updatePlayerState:(AVPStatus)status {
    switch (status) {
        case AVPStatusIdle:
            [self.playButton setSelected:NO];
            [self.trackSelectButton setUserInteractionEnabled:NO];
            [self. progressSlider setUserInteractionEnabled:NO];
            break;
        case AVPStatusError:
            [self.playButton setSelected:NO];
            //cai 错误也应该让用户点击按钮重试
            [self.progressSlider setUserInteractionEnabled:NO];
            break;
        case AVPStatusPrepared:
            [self.playButton setSelected:NO];
            [self.trackSelectButton setUserInteractionEnabled:YES];
            [self.progressSlider setUserInteractionEnabled:YES];
            break;
        case  AVPStatusStarted:
            [self.playButton setSelected:YES];
            [self.trackSelectButton setUserInteractionEnabled:YES];
            [self.progressSlider setUserInteractionEnabled:YES];
            break;
        case  AVPStatusPaused:
            [self.playButton setSelected:NO];
            [self.progressSlider setUserInteractionEnabled:YES];
            break;
        case AVPStatusStopped:
            [self.playButton setSelected:NO];
            [self.trackSelectButton setUserInteractionEnabled:NO];
            [self.progressSlider setUserInteractionEnabled:YES];
            break;
        case AVPStatusCompletion:
            [self.playButton setSelected:NO];
            [self.progressSlider setUserInteractionEnabled:NO];
            break;

        default:
            break;
    }
}

#pragma mark - slider action
- (void)sliderDown:(UISlider *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onBottomViewSliderDrag:progress:event:)]) {
        [self.delegate onBottomViewSliderDrag:sender progress:sender.value event:UIControlEventTouchDown];
    }
}

- (void)updateProgressSliderAction:(UISlider *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onBottomViewSliderDrag:progress:event:)]) {
        [self.delegate onBottomViewSliderDrag:sender progress:sender.value event:UIControlEventValueChanged];
    }
}

- (void)progressSliderUpAction:(UISlider *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onBottomViewSliderDrag:progress:event:)]) {
        [self.delegate onBottomViewSliderDrag:sender progress:sender.value event:UIControlEventTouchUpInside];
    }
}

- (void)updateProgressUpOutsideSliderAction:(UISlider *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onBottomViewSliderDrag:progress:event:)]) {
        [self.delegate onBottomViewSliderDrag:sender progress:sender.value event:UIControlEventTouchUpOutside];
    }
}

- (void)cancelProgressSliderAction:(UISlider *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onBottomViewSliderDrag:progress:event:)]) {
        [self.delegate onBottomViewSliderDrag:sender progress:sender.value event:UIControlEventTouchCancel];
    }
}

- (void)setProgress:(float)progress {
    [self.progressSlider setValue:progress];
}

- (void)setBufferedProgress:(float)bufferedProgress {
    [self.bufferedProgressView setProgress:bufferedProgress];
}

- (float)progress {
    return self.progressSlider.value;
}

@end
