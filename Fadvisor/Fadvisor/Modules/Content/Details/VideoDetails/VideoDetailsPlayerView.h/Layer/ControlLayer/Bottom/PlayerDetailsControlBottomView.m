//
//  AlyunVodBottomView.m
//  playtset
//

#import "PlayerDetailsControlBottomView.h"

static const CGFloat BottomViewPlayButtonWidth = 52;           //播放按钮宽度
static const CGFloat BottomViewFullScreenTimeWidth = 80 + 40;  //全屏时间宽度
static const CGFloat BottomViewFullScreenLeftWidth = 60;       //全屏左右时间宽度
static const CGFloat BottomViewTextSizeFont = 12.0f;           //字体字号
static NSString *const BottomViewDefaultTime = @"00:00:00";    //默认时间样式

@interface PlayerDetailsControlBottomView ()<PlayerDetailsControlProgressViewDelegate>
@property (nonatomic, strong) UIImageView *bottomBarBG;        //背景图片
@property (nonatomic, strong) UIButton *playButton;            //播放按钮
@property (nonatomic, strong) UILabel *leftTimeLabel;          //左侧时间
@property (nonatomic, strong) UILabel *rightTimeLabel;         //右侧时间
@property (nonatomic, strong) UILabel *fullScreenTimeLabel;    //全屏时时间
@property (nonatomic, strong) UIButton *fullScreenButton;      //全屏按钮
@property (nonatomic, strong) PlayerDetailsControlProgressView *progressView;  //进度条

@end

@implementation PlayerDetailsControlBottomView

- (UIImageView *)bottomBarBG {
    if (!_bottomBarBG) {
        _bottomBarBG = [[UIImageView alloc] init];
    }
    return _bottomBarBG;
}

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [[UIButton alloc] init];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"player_play"] forState:UIControlStateNormal];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"player_pause"] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(playButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (void)playButtonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickedPlayButtonWithBottomView:)]) {
        [self.delegate onClickedPlayButtonWithBottomView:self];
    }
}

- (UILabel *)leftTimeLabel {
    if (!_leftTimeLabel) {
        _leftTimeLabel = [[UILabel alloc] init];
        _leftTimeLabel.textAlignment = NSTextAlignmentLeft;
        [_leftTimeLabel setFont:[UIFont systemFontOfSize:BottomViewTextSizeFont]];
        [_leftTimeLabel setTextColor:[UIColor colorFromHexString:@"e7e7e7"]]];
        _leftTimeLabel.text = BottomViewDefaultTime;
    }
    return _leftTimeLabel;
}

- (UILabel *)rightTimeLabel {
    if (!_rightTimeLabel) {
        _rightTimeLabel = [[UILabel alloc] init];
        _rightTimeLabel.textAlignment = NSTextAlignmentRight;
        [_rightTimeLabel setFont:[UIFont systemFontOfSize:BottomViewTextSizeFont]];
        [_rightTimeLabel setTextColor:[UIColor colorFromHexString:@"e7e7e7"]]];
        _rightTimeLabel.text = BottomViewDefaultTime;
    }
    return _rightTimeLabel;
}

- (UILabel *)fullScreenTimeLabel {
    if (!_fullScreenTimeLabel) {
        _fullScreenTimeLabel = [[UILabel alloc] init];
        _fullScreenTimeLabel.textAlignment = NSTextAlignmentCenter;
        [_fullScreenTimeLabel setFont:[UIFont systemFontOfSize:BottomViewTextSizeFont]];
        NSString *curTimeStr = @"00:00:00";
        NSString *totalTimeStr = @"00:00:00";
        NSString *time = [NSString stringWithFormat:@"%@/%@", curTimeStr, totalTimeStr];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:time];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"e7e7e7"]] range:NSMakeRange(0, curTimeStr.length)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"9e9e9e"] range:NSMakeRange(curTimeStr.length, curTimeStr.length + 1)];
        [_fullScreenTimeLabel setAttributedText:str];
    }
    return _fullScreenTimeLabel;
}

- (UIButton *)qualityButton {
    if (!_qualityButton) {
        _qualityButton = [[UIButton alloc] init];
        [_qualityButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_qualityButton setTitleColor:[UIColor colorFromHexString:@"e7e7e7"]] forState:UIControlStateNormal];
        [_qualityButton setTitleColor:[UIColor mainColor] forState:UIControlStateSelected];
        [_qualityButton setTag:1003];
        [_qualityButton addTarget:self action:@selector(qualityButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qualityButton;
}

- (void)qualityButtonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomView:qulityButton:)]) {
        [self.delegate bottomView:self qulityButton:sender];
        sender.selected = !sender.isSelected;
    }
}

- (UIButton *)fullScreenButton {
    if (!_fullScreenButton) {
        _fullScreenButton = [[UIButton alloc] init];
        [_fullScreenButton setTag:1004];
        [_fullScreenButton addTarget:self action:@selector(fullScreenButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenButton;
}

- (void)fullScreenButtonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickedfullScreenButtonWithBottomView:)]) {
        [self.delegate onClickedfullScreenButtonWithBottomView:self];
    }
}

- (PlayerDetailsControlProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[PlayerDetailsControlProgressView alloc] init];
    }
    return _progressView;
}

- (UIButton *)videoButton {
    if (!_videoButton) {
        _videoButton = [[UIButton alloc] init];
        [_videoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_videoButton setTitle:[@"码率" localString] forState:UIControlStateNormal];
        _videoButton.titleLabel.font = [UIFont boldSystemFontOfSize:BottomViewTextSizeFont];
        [_videoButton addTarget:self action:@selector(videoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _videoButton;
}

- (void)videoButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(onClickedVideoButtonWithBottomView:)]) {
        [self.delegate onClickedVideoButtonWithBottomView:self];
    }
}

- (UIButton *)audioButton {
    if (!_audioButton) {
        _audioButton = [[UIButton alloc] init];
        [_audioButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_audioButton setTitle:[@"音轨" localString] forState:UIControlStateNormal];
        _audioButton.titleLabel.font = [UIFont boldSystemFontOfSize:BottomViewTextSizeFont];
        [_audioButton addTarget:self action:@selector(audioButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _audioButton;
}

- (void)audioButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(onClickedAudioButtonWithBottomView:)]) {
        [self.delegate onClickedAudioButtonWithBottomView:self];
    }
}

#pragma mark - init
- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.bottomBarBG setImage:[UIImage imageNamed:@"player_bg"]];

        [self.playButton setBackgroundImage:[UIImage imageNamed:@"player_play"] forState:UIControlStateNormal];
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"player_pause"] forState:UIControlStateSelected];

        //    [self.fullScreenButton setBackgroundImage:[AliyunUtil imageWithNameInBundle:@"al_play_screen" skin:skin] forState:UIControlStateSelected];
        //    [self.fullScreenButton setBackgroundImage:[AliyunUtil imageWithNameInBundle:@"al_play_screen_full" skin:skin] forState:UIControlStateNormal];
        [self.fullScreenButton setImage:[UIImage imageNamed:@"player_fullscreen"] forState:UIControlStateSelected];
        [self.fullScreenButton setImage:[UIImage imageNamed:@"player_fullscreen"] forState:UIControlStateNormal];

        [self.qualityButton setBackgroundImage:[UIImage imageNamed:@"player_quality_normal"] forState:UIControlStateNormal];
        [self.qualityButton setBackgroundImage:[UIImage imageNamed:@"player_rectangle_color"] forState:UIControlStateSelected];
        [self initView];
    }
    return self;
}

- (void)initView {
    [self addSubview:self.bottomBarBG];

    self.playButton.tag = 1076399;
    [self addSubview:self.playButton];
    [self addSubview:self.leftTimeLabel];
    [self addSubview:self.rightTimeLabel];
    [self addSubview:self.fullScreenTimeLabel];
    [self addSubview:self.videoButton];
    [self addSubview:self.audioButton];
//    [self addSubview:self.qualityButton];//原来的x清晰度按钮
//    [self.qualityButton setBackgroundColor:[UIColor redColor]];
    [self addSubview:self.fullScreenButton];

    self.progressView.delegate = self;
    self.progressView.tag = 1076398;
    [self addSubview:self.progressView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.bottomBarBG.frame = self.bounds;
    float width = self.bounds.size.width;
    float height = 48; // 控件所占用的高度

    CGFloat safeLeft = 0;
    if (@available(iOS 11.0, *)) {
        safeLeft = self.safeAreaInsets.left;
    }

    self.playButton.frame = CGRectMake(safeLeft, self.height - height, BottomViewPlayButtonWidth, height);
    self.fullScreenButton.frame = CGRectMake(width - BottomViewFullScreenButtonWidth, self.height - height, BottomViewFullScreenButtonWidth, height);

    if (self.isPortrait) {
        self.fullScreenButton.selected = YES;
        self.qualityButton.hidden = NO;
        self.leftTimeLabel.hidden = NO;
        self.rightTimeLabel.hidden = NO;
        self.fullScreenTimeLabel.hidden = YES;

        int qualityWidth = BottomViewQualityButtonWidth;
        NSArray *qualityAry = [self.videoInfo.tracks copy];
        if (qualityAry && qualityAry.count > 0) {
            self.qualityButton.hidden = NO;
        } else {
            self.qualityButton.hidden = YES;
            qualityWidth = 0;
        }

        self.progressView.frame = CGRectMake(BottomViewPlayButtonWidth, height,
                                             width - (BottomViewPlayButtonWidth + BottomViewFullScreenButtonWidth + qualityWidth),
                                             height);

        CGRect progressFrame = self.progressView.frame;
        self.leftTimeLabel.frame = CGRectMake(progressFrame.origin.x, height / 2, progressFrame.size.width / 2, height / 2);
        self.rightTimeLabel.frame = CGRectMake(progressFrame.origin.x + progressFrame.size.width / 2, height / 2, progressFrame.size.width / 2, height / 2);
        return;
    }

    if ([AliyunUtil isInterfaceOrientationPortrait]) {
        self.fullScreenButton.selected = NO;
        self.qualityButton.hidden = YES;
        self.qualityButton.selected = NO;

        self.leftTimeLabel.hidden = NO;
        self.rightTimeLabel.hidden = NO;
        self.fullScreenTimeLabel.hidden = YES;
        self.fullScreenButton.hidden = NO;
        self.videoButton.hidden = self.audioButton.hidden = YES;

        self.progressView.frame = CGRectMake(BottomViewPlayButtonWidth, 0,
                                             width - (BottomViewPlayButtonWidth + BottomViewFullScreenButtonWidth),
                                             height);

        CGRect progressFrame = self.progressView.frame;
        self.leftTimeLabel.frame = CGRectMake(progressFrame.origin.x, height / 2, progressFrame.size.width / 2, height / 2);
        self.rightTimeLabel.frame = CGRectMake(progressFrame.origin.x + progressFrame.size.width / 2, height / 2, progressFrame.size.width / 2, height / 2);
    } else {
        self.fullScreenButton.selected = YES;
        self.qualityButton.hidden = NO;
//        self.qualityButton.selected = NO;

        self.leftTimeLabel.hidden = NO;
        self.rightTimeLabel.hidden = NO;
        self.fullScreenTimeLabel.hidden = YES;
        self.fullScreenButton.hidden = YES;
        self.videoButton.hidden = self.audioButton.hidden = NO;

        self.fullScreenTimeLabel.frame = CGRectMake(BottomViewPlayButtonWidth, 0, BottomViewFullScreenTimeWidth, height);

        int qualityWidth = BottomViewQualityButtonWidth;
        NSArray *qualityAry = [self.videoInfo.tracks copy];
        if (qualityAry && qualityAry.count > 0) {
            self.qualityButton.hidden = NO;
        } else {
            self.qualityButton.hidden = YES;
            qualityWidth = 0;
        }
        self.qualityButton.frame = CGRectMake(width - (BottomViewQualityButtonWidth + BottomViewFullScreenButtonWidth), 0, BottomViewQualityButtonWidth, height);

        self.progressView.frame = CGRectMake(safeLeft + BottomViewPlayButtonWidth + BottomViewFullScreenTimeWidth + BottomViewMargin, 0, width - (BottomViewPlayButtonWidth + BottomViewFullScreenTimeWidth + 2 * BottomViewMargin  + qualityWidth + BottomViewFullScreenButtonWidth + safeLeft), height);

        self.progressView.frame = CGRectMake(safeLeft + BottomViewFullScreenLeftWidth + 20, 0,
                                             width - BottomViewFullScreenLeftWidth * 2 - 40 - safeLeft,
                                             height);
        self.leftTimeLabel.frame = CGRectMake(safeLeft + 20, 0, BottomViewFullScreenLeftWidth, height);
        self.rightTimeLabel.frame = CGRectMake(width - BottomViewFullScreenLeftWidth - 20, 0, BottomViewFullScreenLeftWidth, height);

        self.videoButton.frame = CGRectMake(width - BottomViewFullScreenLeftWidth - 10, self.height - height, BottomViewFullScreenLeftWidth, height);
        self.audioButton.frame = CGRectMake(width - BottomViewFullScreenLeftWidth * 2 - 10, self.height - height, BottomViewFullScreenLeftWidth, height);
    }
}

#pragma mark - 重写属性setter方法
- (NSString *)qualityFromTrackDefinition:(NSString *)definition {
    NSArray *array = @[@"FD", @"HD", @"LD", @"OD", @"SD", @"2K", @"4K", @"SQ", @"HQ"];
    NSInteger index = [array indexOfObject:definition];
    NSString *nameStr;
    switch (index) {
        case 0:
            nameStr = [@"流畅" localString];
            break;
        case 1:
            nameStr = [@"超清" localString];
            break;
        case 2:
            nameStr = [@"标清" localString];
            break;
        case 3:
            nameStr = [@"原画" localString];
            break;
        case 4:
            nameStr = [@"高清" localString];
            break;
        case 5:
            nameStr = [@"2K" localString];
            break;
        case 6:
            nameStr = [@"4K" localString];
            break;
        case 7:
            nameStr = [@"低音质" localString];
            break;
        case 8:
            nameStr = [@"高音质" localString];
            break;
        default:
            break;
    }

    return nameStr;
}

- (void)setCurrentTrackInfo:(AVPTrackInfo *)trackInfo {
    NSString *title = [self qualityFromTrackDefinition:trackInfo.trackDefinition];
    if (trackInfo.trackDefinition) {
        [self.qualityButton setTitle:title forState:UIControlStateNormal];
    }
}

- (void)setVideoInfo:(AVPMediaInfo *)videoInfo {
    _videoInfo = videoInfo;
    NSArray *ary = [AliyunUtil allQualities];
    if (videoInfo) {
//        if ((int)videoInfo.videoQuality < 0) {
//            [self.qualityButton setTitle:videoInfo.videoDefinition forState:UIControlStateNormal];
//        }else{
//            [self.qualityButton setTitle:ary[videoInfo.videoQuality] forState:UIControlStateNormal];
//        }
        self.qualityButton.hidden = NO;
    }
    [self setNeedsLayout];
}

- (void)setProgress:(float)progress {
    self.progressView.progress = progress;
}

- (float)progress {
    return self.progressView.progress;
}

- (CGFloat)getSliderValue {
    return [_progressView getSliderValue];
}

- (void)setLoadTimeProgress:(float)bufferedProgress {
    self.progressView.bufferedProgress = bufferedProgress;
}

- (void)setIsPortrait:(BOOL)isPortrait {
    _isPortrait = isPortrait;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - progressDelegate
- (void)progressView:(PlayerDetailsControlProgressView *)progressView dragProgressSliderValue:(float)value event:(UIControlEvents)event {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomView:dragProgressSliderValue:event:)]) {
        [self.delegate bottomView:self dragProgressSliderValue:value event:event];
    }
}

#pragma mark -  public method
/*
 * 功能 ：更新进度条
 * 参数 ：currentTime 当前播放时间
 durationTime 播放总时长
 */
- (void)updateProgressWithCurrentTime:(float)currentTime durationTime:(float)durationTime {
    //左右全屏时间
    if (durationTime < 0) {
        durationTime = 0;
    }
    NSString *curTimeStr = [AliyunUtil timeformatFromSeconds:roundf(currentTime)];
    NSString *totalTimeStr = [AliyunUtil timeformatFromSeconds:roundf(durationTime)];
    self.rightTimeLabel.text = totalTimeStr;
    self.leftTimeLabel.text = curTimeStr;
    NSString *time = [NSString stringWithFormat:@"%@/%@", curTimeStr, totalTimeStr];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:time];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"e7e7e7"]] range:NSMakeRange(0, curTimeStr.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"9e9e9e"] range:NSMakeRange(curTimeStr.length, curTimeStr.length + 1)];
    self.fullScreenTimeLabel.attributedText = str;

    //进度条
    [self.progressView updateProgressWithCurrentTime:currentTime durationTime:durationTime];
}

- (void)updateCurrentTime:(float)currentTime durationTime:(float)durationTime {
    //左右全屏时间
    NSString *curTimeStr = [AliyunUtil timeformatFromSeconds:roundf(currentTime)];
    NSString *totalTimeStr = [AliyunUtil timeformatFromSeconds:roundf(durationTime)];
    self.rightTimeLabel.text = totalTimeStr;
    self.leftTimeLabel.text = curTimeStr;
    NSString *time = [NSString stringWithFormat:@"%@/%@", curTimeStr, totalTimeStr];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:time];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"e7e7e7"]] range:NSMakeRange(0, curTimeStr.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"9e9e9e"] range:NSMakeRange(curTimeStr.length, curTimeStr.length + 1)];
    self.fullScreenTimeLabel.attributedText = str;
}

/*
 * 功能 ：根据播放器状态，改变状态
 * 参数 ：state 播放器状态
 */
- (void)updateViewWithPlayerState:(AVPStatus)state {
    switch (state) {
        case AVPStatusIdle:{
            [self.playButton setSelected:NO];
//            [self.qualityButton setUserInteractionEnabled:NO];
//            [self.progressView setUserInteractionEnabled:NO];
        }
        break;
        case AVPStatusError:{
            [self.playButton setSelected:NO];
            //cai 错误也应该让用户点击按钮重试
//            [self.playButton setUserInteractionEnabled:NO];
//            [self.progressView setUserInteractionEnabled:NO];
        }
        break;
        case AVPStatusPrepared:{
            [self.playButton setSelected:NO];
            [self.qualityButton setUserInteractionEnabled:YES];
            [self.progressView setUserInteractionEnabled:YES];
        }
        break;
        case  AVPStatusStarted:{
            [self.playButton setSelected:YES];
            [self.qualityButton setUserInteractionEnabled:YES];
            [self.progressView setUserInteractionEnabled:YES];
        }
        break;
        case  AVPStatusPaused:{
            [self.playButton setSelected:NO];
            [self.progressView setUserInteractionEnabled:YES];
        }
        break;
        case AVPStatusStopped:{
            [self.playButton setSelected:NO];
            [self.qualityButton setUserInteractionEnabled:NO];
            [self.progressView setUserInteractionEnabled:NO];
        }
        break;
//        case AliyunVodPlayerStateLoading:
//        {
//            [self.progressView setUserInteractionEnabled:YES];
//        }
//            break;
        case AVPStatusCompletion:{
            [self.playButton setSelected:NO];
            [self.progressView setUserInteractionEnabled:NO];
        }
        break;

        default:
            break;
    }
}

/*
 * 功能 ：锁屏状态
 * 参数 ：isScreenLocked 是否是锁屏状态
 fixedPortrait 是否是绝对竖屏状态
 */
- (void)lockScreenWithIsScreenLocked:(BOOL)isScreenLocked fixedPortrait:(BOOL)fixedPortrait {
    if (!isScreenLocked) {
        self.playButton.hidden = NO;
        self.fullScreenButton.hidden = NO;
        self.fullScreenTimeLabel.hidden = NO;
        self.qualityButton.hidden = NO;
        if (fixedPortrait) {
            self.leftTimeLabel.hidden = NO;
            self.rightTimeLabel.hidden = NO;
        } else {
            self.leftTimeLabel.hidden = YES;
            self.rightTimeLabel.hidden = YES;
        }
        NSArray *qualityAry = [self.videoInfo.tracks copy];
        if (qualityAry && qualityAry.count > 0) {
            self.qualityButton.hidden = NO;
        } else {
            self.qualityButton.hidden = YES;
        }
        self.progressView.hidden = NO;
    } else {
        self.playButton.hidden = YES;
        self.fullScreenButton.hidden = YES;
        self.fullScreenTimeLabel.hidden = YES;
        self.qualityButton.hidden = YES;
        self.progressView.hidden = YES;
        self.leftTimeLabel.hidden = YES;
        self.rightTimeLabel.hidden = YES;
    }
    [self layoutSubviews];
}

/*
 * 功能 ：取消锁屏
 * 参数 ：isScreenLocked 是否是锁屏状态
 fixedPortrait 是否是绝对竖屏状态
 */
- (void)cancelLockScreenWithIsScreenLocked:(BOOL)isScreenLocked fixedPortrait:(BOOL)fixedPortrait {
    if (isScreenLocked || fixedPortrait) {
        if (fixedPortrait) {
            self.leftTimeLabel.hidden = NO;
            self.rightTimeLabel.hidden = NO;
        } else {
            self.leftTimeLabel.hidden = YES;
            self.rightTimeLabel.hidden = YES;
        }
        self.fullScreenButton.hidden =  NO;
        self.fullScreenTimeLabel.hidden = NO;
        self.qualityButton.hidden = NO;
        self.playButton.hidden = NO;

        NSArray *qualityAry = [self.videoInfo.tracks copy];
        if (qualityAry && qualityAry.count > 0) {
            self.qualityButton.hidden = NO;
        } else {
            self.qualityButton.hidden = YES;
        }
        self.progressView.hidden = NO;
    }
}

@end
