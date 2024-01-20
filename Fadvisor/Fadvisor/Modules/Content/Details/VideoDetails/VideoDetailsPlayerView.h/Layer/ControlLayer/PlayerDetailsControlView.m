//
//  AliyunControlView.m
//

#import "PlayerDetailsControlView.h"

#import "PlayerLoopView.h"
#import "PlayerDetailsTrackButtonsView.h"
#import "PlayerDetailsGestureView.h"
#import "Utils.h"

static const CGFloat ControlViewTopViewHeight = 48;      //topView 高度
static const CGFloat ControlViewBottomViewHeight = 48;   //bottomView 高度
static const CGFloat ControlViewLockButtonLeft = 20;     //lockButton 左侧距离父视图距离
static const CGFloat ControlViewLockButtonHeight = 40;   //lockButton 高度

@interface PlayerDetailsControlView ()<PlayerDetailsControlTopViewDelegate, PlayerDetailsControlBottomViewDelegate, PlayerDetailsGestureViewDelegate, PlayerDetailsQualityListViewDelegate>

@property (nonatomic, strong) PlayerLoopView *loopView;
@property (nonatomic, assign) BOOL hiddenLoopView;

@property (nonatomic, strong) PlayerDetailsGestureView *guestureView;    //手势view

@property (nonatomic, assign) BOOL isHiddenView;                    //是否需要隐藏topView、bottomView
@property (nonatomic, assign) CGRect selfFrame;
@property (nonatomic, assign) CGFloat bottomViewStartProgress; //水平手势记录开始时的progress

@property (nonatomic, assign) BOOL showLoopView;

//清晰度，码率，音轨 三个视图
@property (nonatomic, strong) PlayerDetailsTrackButtonsView *videoTrackView;
@property (nonatomic, strong) PlayerDetailsTrackButtonsView *audioTrackView;

@end
@implementation PlayerDetailsControlView

- (PlayerLoopView *)loopView {
    if (!_loopView) {
        NSInteger loopWidth = ScreenWidth > ScreenHeight ? ScreenWidth : ScreenHeight;
        _loopView = [[PlayerLoopView alloc] initWithFrame:CGRectMake(0, 0, loopWidth, 40)];
        [_loopView setTickerArrs:@[@"跑马灯演示字幕"]];
        [_loopView setCountTime:5];
        [_loopView setBackColor:[UIColor colorWithRed:0.00f green:0.69f blue:0.82f alpha:0.90f]];
    }
    return _loopView;
}

- (PlayerDetailsControlTopView *)topView {
    if (!_topView) {
        _topView = [[PlayerDetailsControlTopView alloc] init];
    }
    return _topView;
}

- (PlayerDetailsControlBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[PlayerDetailsControlBottomView alloc] init];
    }
    return _bottomView;
}

- (PlayerDetailsGestureView *)guestureView {
    if (!_guestureView) {
        _guestureView = [[PlayerDetailsGestureView alloc] init];
    }
    return _guestureView;
}

- (PlayerDetailsQualityListView *)qualityListView {
    if (!_qualityListView) {
        _qualityListView = [[PlayerDetailsQualityListView alloc] init];
    }
    return _qualityListView;
}

- (UIButton *)lockButton {
    if (!_lockButton) {
        _lockButton = [[UIButton alloc] init];
    }
    return _lockButton;
}

- (UIButton *)snapshopButton {
    if (!_snapshopButton) {
        _snapshopButton = [[UIButton alloc] init];
    }
    return _snapshopButton;
}

- (PlayerDetailsTrackButtonsView *)videoTrackView {
    if (!_videoTrackView) {
        _videoTrackView = [[PlayerDetailsTrackButtonsView alloc]initWithFrame:CGRectZero isHorizontal:NO];
        _videoTrackView.backgroundColor = [UIColor colorWithHexString:@"1e222d"];
        _videoTrackView.hidden = YES;
        Weak(self);
        _videoTrackView.callBack = ^(NSInteger index, NSString *title) {
            [weakself trackButtonsViewSelectDefinition:title];
        };
    }
    return _videoTrackView;
}

- (PlayerDetailsTrackButtonsView *)audioTrackView {
    if (!_audioTrackView) {
        _audioTrackView = [[PlayerDetailsTrackButtonsView alloc]initWithFrame:CGRectZero isHorizontal:NO];
        _audioTrackView.backgroundColor = [UIColor colorWithHexString:@"1e222d"];
        _audioTrackView.hidden = YES;
        Weak(self);
        _audioTrackView.callBack = ^(NSInteger index, NSString *title) {
            [weakself trackButtonsViewSelectDefinition:title];
        };
    }
    return _audioTrackView;
}

- (void)trackButtonsViewSelectDefinition:(NSString *)definition {
    for (AVPTrackInfo *track in self.info) {
        if ([definition isEqualToString:track.trackDefinition]) {
            if ([self.delegate respondsToSelector:@selector(controlView:selectTrackIndex:)]) {
                NSString *showString = [NSString stringWithFormat:@"%@%@", [@"准备为你切换至" localString], [track.trackDefinition localString]];
                [MBProgressHUD showMessage:showString ToView:nil];
                [self.delegate controlView:self selectTrackIndex:track.trackIndex];
            }
            return;
        }
    }
}

- (void)setInfo:(NSArray<AVPTrackInfo *> *)info {
    for (AVPTrackInfo *trackInfo in info) {
        if (trackInfo.trackType == AVPTRACK_TYPE_VIDEO) {
            AVPTrackInfo *autoInfo = [[AVPTrackInfo alloc]init];
            autoInfo.trackIndex = -1;
            autoInfo.trackDefinition = @"AUTO";
            autoInfo.trackType = AVPTRACK_TYPE_VIDEO;
            NSMutableArray *tempInfoArray = [NSMutableArray arrayWithArray:info];
            [tempInfoArray insertObject:autoInfo atIndex:0];
            info = [tempInfoArray copy];
            break;
        }
    }
    _info = info;

    NSMutableArray *videoTracksArray = [NSMutableArray array];
    NSMutableArray *audioTracksArray = [NSMutableArray array];
    NSMutableArray *vodTracksArray = [NSMutableArray array];
    for (int i = 0; i < info.count; i++) {
        AVPTrackInfo *track = [info objectAtIndex:i];
        switch (track.trackType) {
            case AVPTRACK_TYPE_VIDEO: {
                [videoTracksArray addObject:track.trackDefinition];
            }
            break;
            case AVPTRACK_TYPE_AUDIO: {
                [audioTracksArray addObject:track.trackDefinition];
            }
            break;
            case AVPTRACK_TYPE_SUBTITLE: {
                break;
            }
            case AVPTRACK_TYPE_SAAS_VOD: {
                [vodTracksArray addObject:track.trackDefinition];
            }
            break;
            default:
                break;
        }
    }
    self.audioTrackView.titleArray = audioTracksArray;
    if (vodTracksArray.count > 0) {
        self.videoTrackView.titleArray = vodTracksArray;
        [self.bottomView.videoButton setTitle:@"清晰度" forState:UIControlStateNormal];
        [self.bottomView.videoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.bottomView.videoButton.userInteractionEnabled = YES;
    } else if (videoTracksArray.count > 0) {
        self.videoTrackView.titleArray = videoTracksArray;
        [self.bottomView.videoButton setTitle:@"码率" forState:UIControlStateNormal];
        [self.bottomView.videoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.bottomView.videoButton.userInteractionEnabled = YES;
    } else {
        [self.bottomView.videoButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.bottomView.videoButton.userInteractionEnabled = NO;
    }
    if (audioTracksArray.count > 0) {
        [self.bottomView.audioButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.bottomView.audioButton.userInteractionEnabled = YES;
    } else {
        [self.bottomView.audioButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.bottomView.audioButton.userInteractionEnabled = NO;
    }
}

#pragma mark - init
- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.masksToBounds = YES;
        self.isHiddenView = NO;
        self.showLoopView = NO;

        [self addSubview:self.loopView];

        self.guestureView.delegate = self;
        [self addSubview:self.guestureView];

        self.topView.delegate = self;
        [self addSubview:self.topView];

        self.bottomView.delegate = self;
        [self addSubview:self.bottomView];

        self.qualityListView.delegate = self;

        [self.lockButton setImage:[UIImage imageNamed:@"player_unlock"] forState:UIControlStateNormal];
        [self.lockButton setImage:[UIImage imageNamed:@"player_lock"] forState:UIControlStateSelected];
        self.lockButton.selected = NO;
        [self.lockButton addTarget:self action:@selector(lockButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.lockButton];

        [self.snapshopButton setImage:[UIImage imageNamed:@"ic_snapshot"] forState:UIControlStateNormal];
        [self.snapshopButton addTarget:self action:@selector(snapshopButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.snapshopButton];

        [self addSubview:self.videoTrackView];
        [self addSubview:self.audioTrackView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;

    float topBarHeight = ControlViewTopViewHeight;
    float bottomBarHeight = ControlViewBottomViewHeight;
    float bottomBarY = height - bottomBarHeight;

    CGFloat safeLeft = 0;
    if (@available(iOS 11.0, *)) {
        safeLeft = self.safeAreaInsets.left;
    }

    if (![Utils isInterfaceOrientationPortrait]) {
        bottomBarHeight = 72;
    }

    self.bottomView.frame = CGRectMake(0, bottomBarY, width, bottomBarHeight);
    if (![Utils isInterfaceOrientationPortrait]) {
        bottomBarY = height - bottomBarHeight - 20;
        self.bottomView.frame = CGRectMake(0, bottomBarY, width, bottomBarHeight + 20);
    }

    self.guestureView.frame = self.bounds;
    self.topView.frame = CGRectMake(0, 0, width, topBarHeight);

    self.lockButton.frame = CGRectMake(safeLeft + ControlViewLockButtonLeft, (height - ControlViewLockButtonHeight) / 2.0, 2 * ControlViewLockButtonLeft, ControlViewLockButtonHeight);
    self.snapshopButton.frame = CGRectMake(width - ControlViewLockButtonLeft * 3, (height - ControlViewLockButtonHeight) / 2.0 + ControlViewLockButtonHeight / 2, 2 * ControlViewLockButtonLeft, ControlViewLockButtonHeight);

    float tempX = width - (BottomViewFullScreenButtonWidth + BottomViewQualityButtonWidth);
    float tempW = BottomViewQualityButtonWidth;

    if (self.isProtrait) {
        self.lockButton.hidden = NO;
        self.snapshopButton.hidden = NO;
        self.qualityListView.frame = CGRectMake(tempX, height - [self.qualityListView estimatedHeight] - bottomBarHeight, tempW, [self.qualityListView estimatedHeight]);
        return;
    }

    if ([Utils isInterfaceOrientationPortrait]) {
        self.lockButton.hidden = YES;
        self.snapshopButton.hidden = YES;
        self.qualityListView.hidden = YES;
        self.loopView.hidden = YES;
    } else {
        self.lockButton.hidden = NO;
        self.snapshopButton.hidden = NO;
        self.qualityListView.hidden = !self.bottomView.qualityButton.selected;
        if (self.showLoopView == NO) {
            self.loopView.hidden = YES;
        } else {
            self.loopView.hidden = self.hiddenLoopView;
        }

        self.loopView.frame = CGRectMake(0, 0, self.bounds.size.width, 40);

        self.videoTrackView.frame = self.audioTrackView.frame = CGRectMake(self.width - self.height * 9 / 16, 0, self.height * 9 / 16, self.height);
    }
    self.qualityListView.frame = CGRectMake(tempX, height - [self.qualityListView estimatedHeight] - self.bottomView.height, tempW, [self.qualityListView estimatedHeight]);

    _selfFrame = self.bounds;
}

#pragma mark - 锁屏按钮 action
- (void)lockButtonClicked:(UIButton *)sender {
    [self.guestureView setIsLock:!_lockButton.selected];
    if (self.delegate && [self.delegate respondsToSelector:@selector(onLockButtonClickedWithControlView:)]) {
        [self.delegate onLockButtonClickedWithControlView:self];
    }
}

#pragma mark - 截图按钮 action
- (void)snapshopButtonClicked:(UIButton *)sender {
    [self hiddenView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSnapshopButtonClickedWithControlView:)]) {
        [self.delegate onSnapshopButtonClickedWithControlView:self];
    }
}

#pragma mark - 重写setter方法
- (void)setIsProtrait:(BOOL)isProtrait {
    _isProtrait = isProtrait;
    self.bottomView.isPortrait = isProtrait;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self.topView setTopTitle:title];
}

- (void)setBottomViewTrackInfo:(AVPTrackInfo *)trackInfo {
    [self.bottomView setCurrentTrackInfo:trackInfo];
}

- (void)setVideoInfo:(AVPMediaInfo *)videoInfo {
    _videoInfo = videoInfo;
    self.bottomView.videoInfo = videoInfo;

    [self.qualityListView removeFromSuperview];
    self.qualityListView = nil;
    self.qualityListView = [[PlayerDetailsQualityListView alloc] init];
    NSArray *tracks = videoInfo.tracks;
    self.qualityListView.allSupportQualities = tracks;
    self.qualityListView.delegate = self;
    self.bottomView.qualityButton.selected = NO;
    [self setNeedsLayout];
}

- (void)setBufferedProgress:(float)bufferedProgress {
    _bufferedProgress = bufferedProgress;
    self.bottomView.bufferedProgress = bufferedProgress;
}

- (void)setPlayMethod:(AlvcPlayMethod)playMethod {
    _playMethod = playMethod;
    _topView.playMethod = playMethod;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - PlayerDetailsControlTopViewDelegate
- (void)onBackViewClickWithTopView:(PlayerDetailsControlTopView *)topView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onBackViewClickWithControlView:)]) {
        [self.delegate onBackViewClickWithControlView:self];
    }
}

- (void)onDownloadButtonClickWithAliyunPVTopView:(PlayerDetailsControlTopView *)topView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onDownloadButtonClickWithControlView:)]) {
        [self.delegate onDownloadButtonClickWithControlView:self];
    }
}

- (void)onSpeedViewClickedWithAliyunPVTopView:(PlayerDetailsControlTopView *)topView {
    [self checkDelayHideMethod];
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSpeedViewClickedWithControlView:)]) {
        [self.delegate onSpeedViewClickedWithControlView:self];
    }
}

- (void)loopViewClickedWithAliyunPVTopView:(PlayerDetailsControlTopView *)topView {
    NSLog(@"跑马灯点击");
    self.loopView.hidden = self.hiddenLoopView = !self.hiddenLoopView;
}

#pragma mark - PlayerDetailsControlBottomViewDelegate
- (void)bottomView:(PlayerDetailsControlBottomView *)bottomView dragProgressSliderValue:(float)progressValue event:(UIControlEvents)event {
    switch (event) {
        case UIControlEventTouchDown:{
            //slider 手势按下时，不做隐藏操作
            self.isHiddenView = NO;
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayHideControlLayer) object:nil];
        }
        break;
        case UIControlEventValueChanged:{
        }
        break;
        case UIControlEventTouchUpInside:{
            //slider滑动结束后，
            self.isHiddenView = YES;
            [self performSelector:@selector(delayHideControlLayer) withObject:nil afterDelay:5];
        }
        break;
        default:
            break;
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(controlView:dragProgressSliderValue:event:)]) {
        [self.delegate controlView:self dragProgressSliderValue:progressValue event:event];
    }
}

- (void)onClickedPlayButtonWithBottomView:(PlayerDetailsControlBottomView *)bottomView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayHideControlLayer) object:nil];
    [self performSelector:@selector(delayHideControlLayer) withObject:nil afterDelay:5];
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickedPlayButtonWithControlView:)]) {
        [self.delegate onClickedPlayButtonWithControlView:self];
    }
}

- (void)bottomView:(PlayerDetailsControlBottomView *)bottomView qulityButton:(UIButton *)qulityButton {
    if (!qulityButton.selected) {
        self.qualityListView.hidden = NO;
        [self addSubview:self.qualityListView];
    } else {
        [self.qualityListView removeFromSuperview];
    }
}

- (void)onClickedfullScreenButtonWithBottomView:(PlayerDetailsControlBottomView *)bottomView {
    [self.qualityListView removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickedfullScreenButtonWithControlView:)]) {
        [self.delegate onClickedfullScreenButtonWithControlView:self];
    }
}

- (void)onClickedVideoButtonWithBottomView:(PlayerDetailsControlBottomView *)bottomView {
    self.videoTrackView.hidden = NO;
    [self bringSubviewToFront:self.videoTrackView];
    [self hiddenView];
}

- (void)onClickedAudioButtonWithBottomView:(PlayerDetailsControlBottomView *)bottomView {
    self.audioTrackView.hidden = NO;
    [self bringSubviewToFront:self.audioTrackView];
    [self hiddenView];
}

#pragma mark - PlayerDetailsGestureViewDelegate
- (void)onSingleClickedWithGestureView:(PlayerDetailsGestureView *)gestureView {
    //单击界面 显示时，快速隐藏；隐藏时，快速展示，并延迟5秒后隐藏
    if (self.self.videoTrackView.hidden == NO) {
        self.videoTrackView.hidden = YES;
    } else if (self.self.audioTrackView.hidden == NO) {
        self.audioTrackView.hidden = YES;
    } else {
        [self checkDelayHideMethod];
    }
}

- (void)onDoubleClickedWithGestureView:(PlayerDetailsGestureView *)gestureView {
    [self.bottomView playButtonClicked:nil];
}

- (void)horizontalOrientationMoveOffset:(float)moveOffset {
    if (self.isHiddenView) {
        [self showView];
    }

    CGFloat moveValue = self.bottomViewStartProgress + moveOffset / self.width;
    if (moveValue > 1) {
        moveValue = 1;
    }
    if (moveValue < 0) {
        moveValue = 0;
    }
    self.bottomView.progress = moveValue;

    if (self.delegate && [self.delegate respondsToSelector:@selector(controlView:dragProgressSliderValue:event:)]) {
        [self.delegate controlView:self dragProgressSliderValue:self.bottomView.progress event:UIControlEventValueChanged];
    }
}

//手势开始
- (void)UIGestureRecognizerStateBeganWithAliyunPVGestureView:(PlayerDetailsGestureView *)gestureView {
    self.bottomViewStartProgress = self.bottomView.progress;
    if (self.delegate && [self.delegate respondsToSelector:@selector(controlView:dragProgressSliderValue:event:)]) {
        [self.delegate controlView:self dragProgressSliderValue:self.bottomView.progress event:UIControlEventTouchDown];
    }
}

//手势结束
- (void)UIGestureRecognizerStateHorizontalEndedWithAliyunPVGestureView:(PlayerDetailsGestureView *)gestureView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(controlView:dragProgressSliderValue:event:)]) {
        [self.delegate controlView:self dragProgressSliderValue:self.bottomView.progress event:UIControlEventTouchUpInside];
    }
}

#pragma mark - PlayerDetailsQualityListViewDelegate
- (void)qualityListViewOnItemClick:(int)index {
//    self.bottomView.qualityButton.selected = !self.bottomView.qualityButton.isSelected;
//    NSArray *ary = [AliyunUtil allQualities];
//    [self.bottomView.qualityButton setTitle:ary[index] forState:UIControlStateNormal];
//
    self.bottomView.qualityButton.selected = NO;
    if ([self.delegate respondsToSelector:@selector(controlView:qualityListViewOnItemClick:)]) {
        [self.delegate controlView:self qualityListViewOnItemClick:index];
    }
}

- (void)setQualityButtonTitle:(NSString *)title {
//    self.bottomView.qualityButton.selected = !self.bottomView.qualityButton.isSelected;
    [self.bottomView.qualityButton setTitle:title forState:UIControlStateNormal];
    self.bottomView.qualityButton.selected = NO;
}

- (void)qualityListViewOnDefinitionClick:(NSString *)videoDefinition {
    self.bottomView.qualityButton.selected = !self.bottomView.qualityButton.isSelected;
    [self.bottomView.qualityButton setTitle:videoDefinition forState:UIControlStateNormal];
}

#pragma mark - public method

- (void)updateViewWithPlayerState:(AVPStatus)state isScreenLocked:(BOOL)isScreenLocked fixedPortrait:(BOOL)fixedPortrait {
    //  || state == AliyunVodPlayerStateLoading
    if (state ==  AVPStatusIdle) {
        [self.guestureView setEnableGesture:NO];
    } else {
        [self.guestureView setEnableGesture:YES];
    }

    if (isScreenLocked || fixedPortrait) {
        [self.guestureView setEnableGesture:NO];
    }

    [self.bottomView updateViewWithPlayerState:state];
}

/*
 * 功能 ：更新进度条
 */
- (void)updateProgressWithCurrentTime:(NSTimeInterval)currentTime durationTime:(NSTimeInterval)durationTime {
    self.currentTime = currentTime;
    self.duration = durationTime;
    [self.bottomView updateProgressWithCurrentTime:currentTime durationTime:durationTime];
}

- (void)updateCurrentTime:(NSTimeInterval)currentTime durationTime:(NSTimeInterval)durationTime {
    self.currentTime = currentTime;
    self.duration = durationTime;
    [self.bottomView updateCurrentTime:currentTime durationTime:durationTime];
}

/*
 * 功能 ：清晰度按钮颜色改变
 */
- (void)setCurrentQuality:(int)quality {
    [self.qualityListView setCurrentQuality:quality];
}

/*
 * 功能 ：清晰度按钮颜色改变
 */
- (void)setCurrentDefinition:(NSString *)videoDefinition {
    [self.qualityListView setCurrentDefinition:videoDefinition];
}

/*
 * 功能 ：隐藏topView、bottomView
 */
- (void)hiddenView {
    self.isHiddenView = YES;
    self.topView.hidden = YES;
    self.bottomView.hidden = YES;
    self.snapshopButton.hidden = YES;
    self.lockButton.hidden = YES;
    self.qualityListView.hidden = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayHideControlLayer) object:nil];
}

/*
 * 功能 ：展示topView、bottomView
 */
- (void)showView {
    if (self.guestureView.delegate == nil) {
        self.guestureView.delegate = self;
    }
    self.isHiddenView = NO;
    [self performSelector:@selector(delayHideControlLayer) withObject:nil afterDelay:5];
    if (_lockButton.selected == YES) {
        _lockButton.hidden = NO;
        return;
    }

    self.topView.hidden = NO;

    self.bottomView.hidden = NO;

    if ([Utils isInterfaceOrientationPortrait]) {
        self.qualityListView.hidden = YES;
    } else {
        self.qualityListView.hidden = !self.bottomView.qualityButton.selected;
        
        self.snapshopButton.hidden = NO;
        self.lockButton.hidden = NO;
    }
}

- (void)showViewWithOutDelayHide {
    [self showView];
    self.guestureView.delegate = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayHideControlLayer) object:nil];
}

- (void)delayHideControlLayer {
    [self hiddenView];
}

- (void)checkDelayHideMethod {
    if (self.isHiddenView) {
        [self showView];
    } else {
        [self hiddenView];
    }
}

/*
 * 功能 ：锁屏
 */
- (void)lockScreenWithIsScreenLocked:(BOOL)isScreenLocked fixedPortrait:(BOOL)fixedPortrait {
    [self.bottomView lockScreenWithIsScreenLocked:isScreenLocked fixedPortrait:fixedPortrait];
    if (!isScreenLocked) {
//        [self.lockButton setBackgroundImage:[AliyunUtil imageWithNameInBundle:@"al_left_unlock"] forState:UIControlStateNormal];
        // [self.lockButton setImage:[UIImage imageNamed:@"player_unlock"] forState:UIControlStateNormal];
        self.topView.hidden = NO;
        self.bottomView.hidden = NO;
        self.snapshopButton.hidden = NO;
        self.qualityListView.hidden = NO;
        // [self setEnableGesture:YES];
    } else {
//        [self.lockButton setBackgroundImage:[AliyunUtil imageWithNameInBundle:@"al_left_lock"] forState:UIControlStateNormal];
        // [self.lockButton setImage:[UIImage imageNamed:@"player_lock"] forState:UIControlStateNormal];
        self.topView.hidden = YES;
        self.bottomView.hidden = YES;
        self.snapshopButton.hidden = YES;
        self.qualityListView.hidden = YES;
        //  [self setEnableGesture:NO];
    }
}

/*
 * 功能 ：取消锁屏
 */
- (void)cancelLockScreenWithIsScreenLocked:(BOOL)isScreenLocked fixedPortrait:(BOOL)fixedPortrait {
    if (isScreenLocked || fixedPortrait) {
        [self.bottomView cancelLockScreenWithIsScreenLocked:isScreenLocked fixedPortrait:fixedPortrait];
        //  [self.lockButton setImage:[UIImage imageNamed:@"player_unlock"] forState:UIControlStateNormal];
        self.lockButton.selected = NO;
        self.topView.hidden = NO;
        self.snapshopButton.hidden = NO;
        self.qualityListView.hidden = NO;
        [self setEnableGesture:YES];
    }
}

- (void)setButtonEnable:(BOOL)enable {
    self.snapshopButton.enabled = enable;
    self.lockButton.enabled = enable;
    self.topView.speedButton.enabled = enable;
}

- (void)loopViewPause {
    _loopView.hidden = YES;
}

- (void)loopViewStart {
    _loopView.hidden = NO;
}

- (void)loopViewStartAnimation {
    [_loopView start];
}

- (void)isShowLoopView:(BOOL)show {
    _showLoopView = show;
}

@end
