//
//  VideoDetailsPlayerView.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/1/17.
//

#import "VideoDetailsPlayerView.h"

#import "Reachability.h"
#import "AlivcPlayerManager.h"
#import "CommonFunc.h"
#import "ImageButton.h"

//view
#import "PlayerDetailsControlTopView.h"
#import "PlayerDetailsControlBottomView.h"
#import "PlayerDetailsGestureView.h"
#import "PlayerDetailsWatchTimeTips.h"
#import "PlayerDetailsSideMoreView.h"

#import "PlayerDetailsPreviewLogoBtn.h"
#import "PlayerDetailsThumbnailView.h"
#import "PlayerDetailsPreviewView.h"
#import "PlayerDetailsLoadingView.h"
#import "PlayerDetailsBulletView.h"

//tipsView
#import "PlayerDetailsPopView.h"

@interface VideoDetailsPlayerView ()<AlivcPlayerProtocal, AliPlayerPictureInPictureDelegate, PlayerDetailsControlTopViewDelegate, PlayerDetailsControlBottomViewDelegate, PlayerDetailsGestureViewDelegate, PlayerDetailsPopViewDelegate>

@property (nonatomic, strong) UIImageView *coverImageView;        //封面
@property (nonatomic, strong) UIView *playerView;   //播放的界面
@property (nonatomic, strong) UIImageView *logoImageView;         //右上角的 logo

@property (nonatomic, strong) PlayerDetailsGestureView *gestureView;
@property (nonatomic, strong) PlayerDetailsSideMoreView *sideMoreView;

@property (nonatomic, strong) PlayerDetailsPopView *popLayer;  //弹出的提示界面
@property (nonatomic, strong) PlayerDetailsLoadingView *loadingView; //loading
@property (nonatomic, strong) PlayerDetailsThumbnailView *thumbnailView;  //缩略图功能
@property (nonatomic, strong) PlayerDetailsBulletView *bulletView;  //跑马灯

@property (nonatomic, strong) PlayerDetailsLoadingView *qualityLoadingView;  //清晰度loading
@property (nonatomic, strong) PlayerDetailsPreviewLogoBtn *previewLogoBtn;
@property (nonatomic, strong) PlayerDetailsPreviewView *previewView;

#pragma mark - 控制
@property (nonatomic, strong) PlayerDetailsControlTopView *controlTopView;
@property (nonatomic, strong) PlayerDetailsControlBottomView *controlBottomView;
@property (nonatomic, strong) PlayerDetailsWatchTimeTips *watchTimeTips;

@property (nonatomic, strong) ImageButton *screenLockButtonRight;
@property (nonatomic, strong) ImageButton *screenLockButtonLeft;
@property (nonatomic, strong) ImageButton *snapshotButton;
@property (nonatomic, assign) CGFloat touchDownProgressValue;
@property (nonatomic, strong) NSTimer *hideControlViewTimer;
@property (nonatomic, assign) BOOL isControlViewShow;
@property (nonatomic, assign) BOOL isSideMoreViewShow;

#pragma mark - data
@property (nonatomic, assign) BOOL isPortrait;             //是否竖屏

@property (nonatomic, assign) BOOL mProgressCanUpdate;     //进度条是否更新，默认是NO
@property (strong, nonatomic) AVPTrackInfo *currentTrackInfo; //当前播放视频的清晰度信息
@property (assign, nonatomic) NSUInteger previewTime;
@property (nonatomic, assign) BOOL trackHasThumbnail; //当前音轨有缩略图
@property (nonatomic, assign) CGFloat gestureViewStartProgress; //水平手势记录开始时的progress

@property (nonatomic, assign) CGFloat statusBarHeight;

#pragma mark - 网络
@property (nonatomic, strong) Reachability *reachability;       //网络监听

@property (nonatomic, assign) NSTimeInterval keyFrameTime;
@property (nonatomic, assign) BOOL isLive;

//标准网络监听状态，保证只有切换网络时才调用reload
@property (nonatomic, assign) BOOL isNetChange;
@property (nonatomic, assign) BOOL isEnterBackground;
@property (nonatomic, assign) BOOL isPauseByBackground;

#pragma mark - 画中画
//https://help.aliyun.com/zh/vod/developer-reference/advanced-features-1#p-93m-izq-1p7
@property (nonatomic, assign) BOOL isPipPaused; // 监听画中画当前是否是暂停状态

@property (nonatomic, weak) AVPictureInPictureController *pipController; // 设置画中画控制器，在画中画即将启动的回调方法中设置，并需要在页面准备销毁时主动将其设置为nil，建议设置

@property (nonatomic, assign) int64_t currentPosition; // 监听播放器当前播放进度，currentPosition设置为监听视频当前播放位置回调中的position参数值

@end

@implementation VideoDetailsPlayerView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(becomeActive)
//                                                     name:UIApplicationDidBecomeActiveNotification
//                                                   object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(resignActive)
//                                                     name:UIApplicationDidEnterBackgroundNotification
//                                                   object:nil];

        //网络状态判定
        self.reachability = [Reachability reachabilityForInternetConnection];
        [self.reachability startNotifier];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged)
                                                     name:SVReachabilityChangedNotification
                                                   object:nil];

        PLAYER_MANAGER.delegate = self;

        self.isControlViewShow = NO;
        self.isScreenLocked = NO;
        self.statusBarHeight = kStatusBarHeight;

        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.insetsPaddingFromSafeArea = UIRectEdgeNone;

    //设置view
    self.coverImageView.myMargin = 0;
    self.coverImageView.centerXPos.equalTo(@0);
    self.coverImageView.centerYPos.equalTo(@0);
    [self addSubview:self.coverImageView];

    self.playerView.myMargin = 0;
    self.playerView.centerXPos.equalTo(@0);
    self.playerView.centerYPos.equalTo(@0);
    [self addSubview:self.playerView];

    [PLAYER_MANAGER setPlayerView:self.playerView];

    [self addSubview:self.bulletView];

    self.thumbnailView.centerXPos.equalTo(@0);
    self.thumbnailView.centerYPos.equalTo(@0);
    self.thumbnailView.hidden = YES;
    [self addSubview:self.thumbnailView];

    self.gestureView.myMargin = 0;
    [self addSubview:self.gestureView];

    self.controlTopView.topPos.equalTo(self.topPos);
    self.controlTopView.leftPos.equalTo(self.leftPos);
    self.controlTopView.widthSize.equalTo(self.widthSize);
    self.controlTopView.heightSize.equalTo(@(MyLayoutSize.wrap));
    self.controlTopView.alpha = 0;
    [self addSubview:self.controlTopView];

    self.controlBottomView.bottomPos.equalTo(@0);
    self.controlBottomView.leftPos.equalTo(self.leftPos);
    self.controlBottomView.widthSize.equalTo(self.widthSize);
    self.controlBottomView.heightSize.equalTo(@(MyLayoutSize.wrap));
    self.controlBottomView.alpha = 0;
    [self addSubview:self.controlBottomView];

    self.screenLockButtonRight.centerYPos.equalTo(self.centerYPos).offset(36);
    self.screenLockButtonRight.rightPos.equalTo(self.rightPos).offset(self.statusBarHeight);
    [self addSubview:self.screenLockButtonRight];
    self.screenLockButtonRight.alpha = 0;

    self.snapshotButton.centerXPos.equalTo(self.screenLockButtonRight.centerXPos);
    self.snapshotButton.bottomPos.equalTo(self.screenLockButtonRight.topPos).offset(16);
    [self addSubview:self.snapshotButton];
    self.snapshotButton.alpha = 0;

    self.screenLockButtonLeft.leftPos.equalTo(self.leftPos).offset(self.statusBarHeight);
    self.screenLockButtonLeft.centerYPos.equalTo(self.centerYPos);
    [self addSubview:self.screenLockButtonLeft];
    self.screenLockButtonLeft.visibility = MyVisibility_Invisible;
    self.screenLockButtonLeft.alpha = 0;

    self.watchTimeTips.bottomPos.equalTo(self.controlBottomView.topPos).offset(16);

    self.sideMoreView.widthSize.equalTo(self.widthSize).multiply(0.45);
    self.sideMoreView.heightSize.equalTo(self.heightSize);
    self.sideMoreView.leftPos.equalTo(self.rightPos);
    self.sideMoreView.leftPos.active = YES;
    self.sideMoreView.rightPos.active = NO;
    self.sideMoreView.rightPos.equalTo(self.rightPos);
    self.sideMoreView.centerYPos.equalTo(@0);
    [self addSubview:self.sideMoreView];

    self.popLayer.delegate = self;
    self.popLayer.centerYPos.equalTo(@0);
    self.popLayer.heightSize.equalTo(self.heightSize);
//    [self addSubview:self.popLayer];

//    [self addSubview:self.previewView];
//    [self addSubview:self.loadingView];
}

- (void)startNewPlayWithItem:(ItemModel *)itemModel details:(VideoDetailsModel *)detailsModel {
    self.mProgressCanUpdate = YES;
    self.isNetChange = NO;
    self.keyFrameTime = 0;

    // 封面
    if (itemModel.coverUrl) {
        [self.coverImageView setImageWithURL:itemModel.coverUrl];
    }

    [self.controlTopView setTitle:itemModel.title];

    // 预览时间
    self.previewTime = self.isPreviewMode ? detailsModel.previewTime : 0;

    // 跑马灯
    self.bulletView.hidden = ![JUDGE_IS isEqual:detailsModel.bulletScreen];

    // 初始化进度条,把上一条播放视频的进度条 设置为0
    [self.controlBottomView updateProgressWithCurrentTime:0 durationTime:itemModel.duration];

    [self playViewPrepareWithVid:detailsModel.videoId];
}

- (void)resetLayout:(BOOL)isPortrait {
    if (isPortrait == self.isPortrait) {
        return;
    }
    self.isPortrait = isPortrait;
    isPortrait ? [self setLayoutPortrait] : [self setLayoutLandscape];
}

- (void)hideControlView {
    if (self.isControlViewShow) {
        [UIView animateWithDuration:0.3 animations:^{
            if (!self.isScreenLocked) {
                self.controlTopView.alpha = 0;
                self.controlBottomView.alpha = 0;
            }
            self.screenLockButtonRight.alpha = 0;
            self.screenLockButtonLeft.alpha = 0;
            self.snapshotButton.alpha = 0;
            self.isControlViewShow = NO;
        }];
    }
    if (self.hideControlViewTimer) {
        [self.hideControlViewTimer invalidate];
        self.hideControlViewTimer = nil;
    }
}

- (void)showControlView {
    self.hideControlViewTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(hideControlView) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.hideControlViewTimer forMode:NSRunLoopCommonModes];

    if (!self.isControlViewShow) {
        [UIView animateWithDuration:0.3 animations:^{
            if (!self.isScreenLocked) {
                self.controlTopView.alpha = 1.0;
                self.controlBottomView.alpha = 1.0;
            }
            self.screenLockButtonRight.alpha = 1.0;
            self.screenLockButtonLeft.alpha = 1.0;
            self.snapshotButton.alpha = 1.0;
            self.isControlViewShow = YES;
        }];
    }
}

#pragma mark - 播放器开始播放入口
- (void)playViewPrepareWithURL:(NSURL *)url isLocal:(BOOL)isLocal {
    if ([self networkChangedToShowPopView]) {
        return;
    }
    PLAYER_MANAGER.playMethod = isLocal ? AlivcPlayMethodLocal : AlivcPlayMethodUrl;
    [PLAYER_MANAGER startPlayWithUrl:url];
    if (!isLocal) {
        [self.loadingView show];
    }
    NSLog(@"播放器prepareWithURL");
}

- (void)playViewPrepareWithVid:(NSString *)vid {
    if ([self networkChangedToShowPopView]) {
        return;
    }
    [self.loadingView show];
    Weak(self);
    [PLAYER_MANAGER startPlayWithVidAuth:vid errorBlock:^(NSString *errorMsg) {
        AVPErrorModel *errorModel = [AVPErrorModel new];
        errorModel.message = errorMsg;
//        [weakself showPopLayerWithErrorModel:errorModel];
    }];
    NSLog(@"播放器playAuth");
}

- (void)start {
    [PLAYER_MANAGER start];
}

- (void)pause {
    [PLAYER_MANAGER pause];
}

- (void)resume {
    [PLAYER_MANAGER start];
}

- (void)seekTo:(NSTimeInterval)seekTime {
    [PLAYER_MANAGER seekTo:seekTime];
    [self.loadingView show];
}

- (void)stop {
    [PLAYER_MANAGER stop];
    NSLog(@"播放器stop");
}

#pragma mark - 网络状态改变
- (void)reachabilityChanged {
    if (PLAYER_MANAGER.currentPlayStatus != AVPStatusIdle) {
        [self networkChangedToShowPopView];
    }
    _isNetChange = YES;
}

//网络状态判定
- (BOOL)networkChangedToShowPopView {
    BOOL ret = NO;
    switch ([self.reachability currentReachabilityStatus]) {
        case SVNetworkStatusNotReachable://由播放器底层判断是否有网络
            break;
        case SVNetworkStatusReachableViaWiFi:
            [self reloadWhenNetChange];
            break;
        case SVNetworkStatusReachableViaWWAN:
            [self reloadWhenNetChange];
            if (PLAYER_MANAGER.playMethod == AlivcPlayMethodLocal) {
                return NO;
            }
            // ⚠️显示4G 网络警告
//            [self stop];
//            [self unlockScreen];
            [self.popLayer showPopViewWithCode:PlayerPopCodeUseMobileNetwork popMsg:nil];
            [self.loadingView dismiss];
            [self.qualityLoadingView dismiss];
            NSLog(@"播放器展示4G提醒");
            ret = YES;
            break;
        default:
            break;
    }
    return ret;
}

- (void)reloadWhenNetChange {
    if (_isNetChange) {
        [PLAYER_MANAGER reload];
    }
}

#pragma mark - 屏幕旋转
- (void)setLayoutLandscape {
    [self.controlBottomView resetLayout:NO];
    [self.controlTopView resetLayout:NO];
    [self.gestureView resetLayout:NO];

    self.screenLockButtonRight.visibility = MyVisibility_Visible;
    self.snapshotButton.visibility = MyVisibility_Visible;

    self.watchTimeTips.leftPos.equalTo(self.leftPos).offset(self.statusBarHeight);
}

- (void)setLayoutPortrait {
    [self.controlBottomView resetLayout:YES];
    [self.controlTopView resetLayout:YES];
    [self.gestureView resetLayout:YES];

    self.screenLockButtonRight.visibility = MyVisibility_Invisible;
    self.snapshotButton.visibility = MyVisibility_Invisible;
    self.screenLockButtonLeft.visibility = MyVisibility_Invisible;

    self.watchTimeTips.leftPos.equalTo(self.leftPos).offset(0);
}

#pragma mark - AlivcPlayerProtocal
- (void)onPlayerEvent:(AliPlayer *)player eventType:(AVPEventType)eventType {
    switch (eventType) {
        case AVPEventPrepareDone: {
            [self.loadingView dismiss];
            self.popLayer.hidden = YES;
            AVPTrackInfo *info = [player getCurrentTrack:AVPTRACK_TYPE_SAAS_VOD];
            self.currentTrackInfo = info;

            // 定位到上次播放时间
            int64_t watchTime = [PLAYER_MANAGER localWatchTime];
            float duration = PLAYER_MANAGER.duration;
            if (watchTime > 0 && duration && watchTime < duration) {
                [PLAYER_MANAGER seekTo:watchTime];

                CGFloat progress = watchTime / duration;
                [self.controlBottomView setProgress:progress];
                [self.controlBottomView setBufferedProgress:progress];

                [self.watchTimeTips showWatchTimeTips:watchTime];
                [self addSubview:self.watchTimeTips];
            }
            [PLAYER_MANAGER enablePictureInPictureWithDelegate:self];
//            [self.controlView setBottomViewTrackInfo:info];
//            [self updateControlLayerDataWithMediaInfo:PLAYER_MANAGER.playMethod == AlivcPlayMethodUrl ? nil : [player getMediaInfo]];

            // 加密视频不支持投屏 非mp4 mov视频不支持airplay
            AVPMediaInfo *mediaInfo = [PLAYER_MANAGER getMediaInfo];
            for (AVPTrackInfo *info in mediaInfo.tracks) {
                NSLog(@"url:::::::%@", info.vodPlayUrl);
            }
        } break;
        case AVPEventFirstRenderedStart: {
            //开启常亮状态
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
            //隐藏封面
            self.coverImageView.hidden = YES;
        } break;
        case AVPEventCompletion: {
            if (self.delegate && [self.delegate respondsToSelector:@selector(onFinishWithPlayerView:)]) {
                [self.delegate onFinishWithPlayerView:self];
            }
            if (_pipController) {
                self.isPipPaused = YES;    // 播放结束后，将画中画状态变更为暂停
                [self.pipController invalidatePlaybackState];
            }
        } break;
        case AVPEventLoadingStart: {
            [self.loadingView show];
        } break;
        case AVPEventLoadingEnd: {
            [self.loadingView dismiss];
        } break;
        case AVPEventSeekEnd:{
            self.mProgressCanUpdate = YES;
            [self.loadingView dismiss];
            NSLog(@"seekDone");
            if (_pipController) {
                [self.pipController invalidatePlaybackState];
            }
        } break;
        case AVPEventLoopingStart:
            break;
        default:
            break;
    }
}

- (void)onPlayerEvent:(AliPlayer *)player eventWithString:(AVPEventWithString)eventWithString description:(NSString *)description {
    //过滤EVENT_PLAYER_DIRECT_COMPONENT_MSG 打印信息
    if (eventWithString != EVENT_PLAYER_DIRECT_COMPONENT_MSG) {
        [MBProgressHUD showMessage:description ToView:self];
    }
}

- (void)onError:(AliPlayer *)player errorModel:(AVPErrorModel *)errorModel {
    //关闭loading动画
    [self.loadingView dismiss];

    //根据播放器状态处理seek时thumb是否可以拖动
    // [self.controlView updateViewWithPlayerState:self.aliPlayer.playerState isScreenLocked:self.isScreenLocked fixedPortrait:self.isProtrait];
    //根据错误信息，展示popLayer界面
//    [self showPopLayerWithErrorModel:errorModel];
    NSLog(@"errorCode:%lu errorMessage:%@", (unsigned long)errorModel.code, errorModel.message);
}

- (void)onCurrentPositionUpdate:(AliPlayer *)player position:(int64_t)position {
    NSTimeInterval currentTime = position;
    NSTimeInterval durationTime = PLAYER_MANAGER.duration;
    self.currentPosition = position;

    if (self.isPreviewMode && self.previewTime > 0 && position >= self.previewTime * 1000) {
        [self.controlBottomView updateProgressWithCurrentTime:self.previewTime * 1000 durationTime:durationTime];
        [self stop];
    }

    if (self.mProgressCanUpdate) {
        if (self.keyFrameTime > 0 && position < self.keyFrameTime) {
            // 屏蔽关键帧问题
            return;
        }
        [self.controlBottomView updateProgressWithCurrentTime:currentTime durationTime:durationTime];
        self.keyFrameTime = 0;
    }
}

/**
 @brief 视频缓存位置回调
 @param player 播放器player指针
 @param position 视频当前缓存位置
 */
- (void)onBufferedPositionUpdate:(AliPlayer *)player position:(int64_t)position {
    [self.controlBottomView setBufferedProgress:(float)position / player.duration];
}

/**
 @brief 获取track信息回调
 @param player 播放器player指针
 @param info track流信息数组
 @see AVPTrackInfo
 */
- (void)onTrackReady:(AliPlayer *)player info:(NSArray<AVPTrackInfo *> *)info {
    AVPMediaInfo *mediaInfo = [player getMediaInfo];
    if (mediaInfo.thumbnails && ([mediaInfo.thumbnails count] > 0)) {
        [player setThumbnailUrl:[mediaInfo.thumbnails objectAtIndex:0].URL];
        self.trackHasThumbnail = YES;
    } else {
        self.trackHasThumbnail = NO;
    }
}

- (void)onTrackChanged:(AliPlayer *)player info:(AVPTrackInfo *)info {
    //选中切换
    NSLog(@"%@", info.trackDefinition);
    self.currentTrackInfo = info;
    [self.loadingView dismiss];
//    [self.controlView setBottomViewTrackInfo:info];
    NSString *showString = [NSString stringWithFormat:@"%@%@", [@"已为你切换至" localString], [info.trackDefinition localString]];
    [MBProgressHUD showMessage:showString ToView:nil];
}

- (void)onPlayerStatusChanged:(AliPlayer *)player oldStatus:(AVPStatus)oldStatus newStatus:(AVPStatus)newStatus {
    [self.controlBottomView updatePlayerState:newStatus];

    if (_pipController) {
        [self.pipController invalidatePlaybackState];
    }
}

- (void)onGetThumbnailSuc:(int64_t)positionMs fromPos:(int64_t)fromPos toPos:(int64_t)toPos image:(id)image {
    [self.thumbnailView updateThumbnail:image time:positionMs durationTime:PLAYER_MANAGER.duration];
    self.thumbnailView.hidden = NO;
}

/**
 @brief 获取缩略图失败回调
 @param positionMs 指定的缩略图位置
 */
- (void)onGetThumbnailFailed:(int64_t)positionMs {
    NSLog(@"缩略图获取失败");
}

/**
 @brief 获取截图回调
 @param player 播放器player指针
 @param image 图像
 @see AVPImage
 */
- (void)onCaptureScreen:(AliPlayer *)player image:(AVPImage *)image {
    if (!image) {
        [MBProgressHUD showMessage:[@"截图为空" localString] ToView:self];
        return;
    }
    [CommonFunc saveImage:image inView:self];
}

#pragma mark - AliPlayerPictureInPictureDelegate
/**
 @brief 画中画即将启动
 @param pictureInPictureController 画中画控制器
 */
- (void)pictureInPictureControllerWillStartPictureInPicture:(AVPictureInPictureController *)pictureInPictureController {
    if (!_pipController) {
        self.pipController = pictureInPictureController;
    }
    self.isPipPaused = !(PLAYER_MANAGER.currentPlayStatus == AVPStatusStarted);
    [pictureInPictureController invalidatePlaybackState];
}

/**
 @brief 画中画准备停止
 @param pictureInPictureController 画中画控制器
 */
- (void)pictureInPictureControllerWillStopPictureInPicture:(AVPictureInPictureController *)pictureInPictureController {
    self.isPipPaused = NO;
    [pictureInPictureController invalidatePlaybackState];
}

/**
 @brief 在画中画停止前告诉代理恢复用户接口
 @param pictureInPictureController 画中画控制器
 @param completionHandler 调用并传值YES以允许系统结束恢复播放器用户接口
 */
- (void)pictureInPictureController:(AVPictureInPictureController *)pictureInPictureController restoreUserInterfaceForPictureInPictureStopWithCompletionHandler:(void (^)(BOOL restored))completionHandler {
    if (_pipController) {
        _pipController = nil;
    }
    completionHandler(YES);
}

/**
 @brief 通知画中画控制器当前可播放的时间范围
 @param pictureInPictureController 画中画控制器
 @return 当前可播放的时间范围
 */
- (CMTimeRange)pictureInPictureControllerTimeRangeForPlayback:(nonnull AVPictureInPictureController *)pictureInPictureController layerTime:(CMTime)layerTime {
    Float64 current64 = CMTimeGetSeconds(layerTime);

    Float64 start;
    Float64 end;

    if (self.currentPosition <= PLAYER_MANAGER.duration) {
        double curPostion = self.currentPosition / 1000.0;
        double duration = PLAYER_MANAGER.duration / 1000.0;
        double interval = duration - curPostion;
        start = current64 - curPostion;
        end = current64 + interval;
        CMTime t1 = CMTimeMakeWithSeconds(start, layerTime.timescale);
        CMTime t2 = CMTimeMakeWithSeconds(end, layerTime.timescale);
        return CMTimeRangeFromTimeToTime(t1, t2);
    } else {
        return CMTimeRangeMake(kCMTimeNegativeInfinity, kCMTimePositiveInfinity);
    }
}

/**
 @brief 将暂停或播放状态反映到UI上
 @param pictureInPictureController 画中画控制器
 @return 暂停或播放
 */
- (BOOL)pictureInPictureControllerIsPlaybackPaused:(nonnull AVPictureInPictureController *)pictureInPictureController {
    return self.isPipPaused;
}

/**
 @brief 点击快进或快退按钮
 @param pictureInPictureController 画中画控制器
 @param skipInterval 快进或快退的事件间隔
 @param completionHandler 一定要调用的闭包，表示跳转操作完成
 */
- (void)pictureInPictureController:(nonnull AVPictureInPictureController *)pictureInPictureController skipByInterval:(CMTime)skipInterval completionHandler:(nonnull void (^)(void))completionHandler {
    int64_t skipTime = skipInterval.value / skipInterval.timescale;
    int64_t skipPosition = self.currentPosition + skipTime * 1000;
    if (skipPosition < 0) {
        skipPosition = 0;
    } else if (skipPosition > PLAYER_MANAGER.duration) {
        skipPosition = PLAYER_MANAGER.duration;
    }
    [PLAYER_MANAGER seekTo:skipPosition];
    [pictureInPictureController invalidatePlaybackState];
}

/**
 @brief 点击画中画暂停按钮
 @param pictureInPictureController 画中画控制器
 @param playing 是否正在播放
 */
- (void)pictureInPictureController:(nonnull AVPictureInPictureController *)pictureInPictureController setPlaying:(BOOL)playing {
    if (!playing) {
        [self pause];
        self.isPipPaused = YES;
    } else {
        // 建议：如果画中画播放完成，需要重新播放，可额外执行下面if语句的代码
        if (PLAYER_MANAGER.currentPlayStatus == AVPStatusCompletion) {
            [PLAYER_MANAGER seekTo:0];
        }

        [self start];
        self.isPipPaused = NO;
    }
    [pictureInPictureController invalidatePlaybackState];
}

#pragma mark - PlayerDetailsControlTopViewDelegate
- (void)onTopViewMoreButtonClicked:(UIButton *)sender topView:(PlayerDetailsControlTopView *)topView {
    if (!self.isPortrait) {
        [self hideControlView];
        [self showSideMoreView];
    } else if (self.delegate && [self.delegate respondsToSelector:@selector(onMoreButtonClickWithPlayerView:)]) {
        [self.delegate onMoreButtonClickWithPlayerView:self];
    }
}

- (void)onTopViewBackButtonClicked:(UIButton *)sender topView:(PlayerDetailsControlTopView *)topView {
    if (!self.isPortrait && self.delegate && [self.delegate respondsToSelector:@selector(onRotationToPortraitInterface:)]) {
        [self.delegate onRotationToPortraitInterface:YES];
    } else if (self.delegate && [self.delegate respondsToSelector:@selector(onBackButtonClickWithPlayerView:)]) {
        [self.delegate onBackButtonClickWithPlayerView:self];
    }
}

#pragma mark - PlayerDetailsControlBottomViewDelegate
- (void)onBottomViewSliderDrag:(UISlider *)sender progress:(float)progress event:(UIControlEvents)event {
    NSInteger durationTime = PLAYER_MANAGER.duration;
    switch (event) {
        case UIControlEventValueChanged:
            self.mProgressCanUpdate = NO;
            //更新UI上的当前时间
            [self.controlBottomView updateProgressWithCurrentTime:progress * durationTime durationTime:durationTime];
//            if (self.trackHasThumbnail == YES) {
            [PLAYER_MANAGER getThumbnail:progress * durationTime];
//            }
            break;
        case UIControlEventTouchUpOutside:
        case UIControlEventTouchUpInside:
        case UIControlEventTouchDownRepeat: {
            [PLAYER_MANAGER seekTo:(progress * durationTime)];
            [self.loadingView show];
            if (PLAYER_MANAGER.currentPlayStatus == AVPStatusPaused) {
                [PLAYER_MANAGER start];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //在播放器回调的方法里，防止sdk异常不进行seekdone的回调，在3秒后增加处理，防止ui一直异常
                self.mProgressCanUpdate = YES;
            });
            break;
        }
        case UIControlEventTouchCancel:
            self.mProgressCanUpdate = YES;
            self.thumbnailView.hidden = YES;
            break;
        default:
            self.mProgressCanUpdate = YES;
            break;
    }
}

- (void)onBottomViewFullScreenButtonClicked:(UIButton *)sender bottomView:(PlayerDetailsControlBottomView *)bottomView {
    if (self.isPortrait && self.delegate && [self.delegate respondsToSelector:@selector(onRotationToPortraitInterface:)]) {
        [self.delegate onRotationToPortraitInterface:NO];
    }
}

- (void)onBottomViewPlayButtonClicked:(UIButton *)sender bottomView:(PlayerDetailsControlBottomView *)bottomView {
    [self playButtonClicked];
}

- (void)playButtonClicked {
    AVPStatus playStatus = PLAYER_MANAGER.currentPlayStatus;
    switch (playStatus) {
        case AVPStatusStarted:
            //如果是直播则stop
            if (PLAYER_MANAGER.duration == 0) {
                _isLive = YES;
                [self stop];
            } else {
                [self pause];
            }
            break;
        case AVPStatusPrepared:
            [self start];
            break;
        case AVPStatusPaused:
            [self resume];
            break;
        case AVPStatusStopped:
            if (_isLive) {
                [self start];
            } else {
                [self start];
            }
            break;
        default:
            break;
    }
}

#pragma mark - PlayerDetailsGestureViewDelegate
- (void)onSingleTapWithGestureView:(PlayerDetailsGestureView *)gestureView {
    if (self.isSideMoreViewShow) {
        [self hidesideMoreView];
        return;
    }

    self.isControlViewShow ? [self hideControlView] : [self showControlView];
}

- (void)onDoubleTapWithGestureView:(PlayerDetailsGestureView *)gestureView {
    if (self.isScreenLocked) {
        return;
    }

    if (self.isSideMoreViewShow) {
        return;
    }

    [self playButtonClicked];
    [self showControlView];
}

- (void)onHorizontalMovingWithGestureView:(PlayerDetailsGestureView *)gestureView offset:(float)moveOffset {
}

- (void)onHorizontalMoveEndWithGestureView:(PlayerDetailsGestureView *)gestureView offset:(float)moveOffset {
    if (self.isScreenLocked) {
        return;
    }
    if (self.isSideMoreViewShow) {
        return;
    }
    NSInteger durationTime = PLAYER_MANAGER.duration;
    NSTimeInterval seekProgress = [self moveValueByOffset:moveOffset];
    
    [self seekTo:(durationTime * seekProgress)];
    [self.controlBottomView setProgress:seekProgress];
    self.thumbnailView.hidden = YES;
}

- (NSTimeInterval)moveValueByOffset:(float)moveOffset {
    CGFloat progress = [self.controlBottomView progress];
    CGFloat width = self.width;
    CGFloat offsetProgress = (moveOffset / width) / 2;
    CGFloat seekProgress = progress + offsetProgress;
    if (seekProgress > 1) {
        seekProgress = 1;
    }
    if (seekProgress < 0) {
        seekProgress = 0;
    }
    return seekProgress;
}

#pragma mark - ScreenLock Actions
- (void)onScreenLockButtonClicked:(UIButton *)sender {
    self.isScreenLocked = !self.isScreenLocked;
    self.screenLockButtonLeft.selected = self.screenLockButtonRight.selected = self.isScreenLocked;
    self.controlTopView.hidden = self.controlBottomView.hidden = self.isScreenLocked;
    self.screenLockButtonRight.centerYPos.equalTo(self.centerYPos).offset(self.isScreenLocked ? 0 : 32);
    self.snapshotButton.visibility = self.isScreenLocked ? MyVisibility_Invisible : MyVisibility_Visible;
    self.screenLockButtonLeft.visibility = self.isScreenLocked ? MyVisibility_Visible : MyVisibility_Invisible;
    UIImpactFeedbackGenerator *impactLight = [[UIImpactFeedbackGenerator alloc]initWithStyle:UIImpactFeedbackStyleLight];
    [impactLight impactOccurred];

    if (self.delegate && [self.delegate respondsToSelector:@selector(onScreenLockButtonClickWithPlayerView:isLocked:)]) {
        [self.delegate onScreenLockButtonClickWithPlayerView:self isLocked:self.isScreenLocked];
    }
}

- (void)onSnapshotButtonClicked:(UIButton *)sender {
    [PLAYER_MANAGER snapShot];
}

#pragma mark - PlayerDetailsSideMoreView
- (BOOL)isHorzViewShow {
    return self.isSideMoreViewShow;
}

- (void)showSideMoreView {
    self.sideMoreView.leftPos.active = NO;
    self.sideMoreView.rightPos.active = YES;

    [self layoutAnimationWithDuration:0.2];
    self.isSideMoreViewShow = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(onHorzViewPopped:)]) {
        [self.delegate onHorzViewPopped:self.isSideMoreViewShow];
    }
}

- (void)hidesideMoreView {
    self.sideMoreView.leftPos.active = YES;
    self.sideMoreView.rightPos.active = NO;

    [self layoutAnimationWithDuration:0.2];
    self.isSideMoreViewShow = NO;

    if (self.delegate && [self.delegate respondsToSelector:@selector(onHorzViewPopped:)]) {
        [self.delegate onHorzViewPopped:self.isSideMoreViewShow];
    }
}

#pragma mark - set And get
- (PlayerDetailsPreviewLogoBtn *)previewLogoBtn {
    if (!_previewLogoBtn) {
        _previewLogoBtn = [[PlayerDetailsPreviewLogoBtn alloc]init];
    }
    return _previewLogoBtn;
}

- (UIView *)playerView {
    if (!_playerView) {
        _playerView = [[UIView alloc]init];
    }
    return _playerView;
}

- (PlayerDetailsPopView *)popLayer {
    if (!_popLayer) {
        _popLayer = [[PlayerDetailsPopView alloc] init];
        _popLayer.frame = self.bounds;
        _popLayer.hidden = YES;
    }
    return _popLayer;
}

- (PlayerDetailsPreviewView *)previewView {
    if (!_previewView) {
        _previewView = [[PlayerDetailsPreviewView alloc]init];
        _previewView.frame = self.bounds;
        _previewView.hidden = YES;
    }
    return _previewView;
}

- (PlayerDetailsLoadingView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[PlayerDetailsLoadingView alloc] init];
    }
    return _loadingView;
}

- (PlayerDetailsLoadingView *)qualityLoadingView {
    if (!_qualityLoadingView) {
        _qualityLoadingView = [[PlayerDetailsLoadingView alloc] init];
    }
    return _qualityLoadingView;
}

- (PlayerDetailsThumbnailView *)thumbnailView {
    if (!_thumbnailView) {
        _thumbnailView = [[PlayerDetailsThumbnailView alloc]init];
        _thumbnailView.hidden = YES;
    }
    return _thumbnailView;
}

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder_img"]];
    }
    return _logoImageView;
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.hidden = NO;
    }
    return _coverImageView;
}

- (PlayerDetailsBulletView *)bulletView {
    if (!_bulletView) {
        _bulletView = [[PlayerDetailsBulletView alloc] init];
    }
    return _bulletView;
}

- (PlayerDetailsControlTopView *)controlTopView {
    if (!_controlTopView) {
        _controlTopView = [[PlayerDetailsControlTopView alloc] init];
        _controlTopView.delegate = self;
    }
    return _controlTopView;
}

- (PlayerDetailsControlBottomView *)controlBottomView {
    if (!_controlBottomView) {
        _controlBottomView = [[PlayerDetailsControlBottomView alloc] init];
        _controlBottomView.delegate = self;
    }
    return _controlBottomView;
}

- (PlayerDetailsGestureView *)gestureView {
    if (!_gestureView) {
        _gestureView = [[PlayerDetailsGestureView alloc] init];
        _gestureView.delegate = self;
    }
    return _gestureView;
}

- (ImageButton *)screenLockButtonRight {
    if (!_screenLockButtonRight) {
        _screenLockButtonRight = [[ImageButton alloc] initWithFrame:CGRectMake(0, 0, kButtonStandardSize, kButtonStandardSize) imageName:@"player_unlock"];
        [_screenLockButtonRight setImage:[UIImage imageNamed:@"player_lock"] forState:UIControlStateSelected];
        [_screenLockButtonRight setImageSize:CGSizeMake(24, 24)];
        _screenLockButtonRight.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        _screenLockButtonRight.layer.cornerRadius = 6;
        _screenLockButtonRight.layer.masksToBounds = YES;
        [_screenLockButtonRight addTarget:self action:@selector(onScreenLockButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _screenLockButtonRight;
}

- (ImageButton *)screenLockButtonLeft {
    if (!_screenLockButtonLeft) {
        _screenLockButtonLeft = [[ImageButton alloc] initWithFrame:CGRectMake(0, 0, kButtonStandardSize, kButtonStandardSize) imageName:@"player_unlock"];
        [_screenLockButtonLeft setImage:[UIImage imageNamed:@"player_lock"] forState:UIControlStateSelected];
        [_screenLockButtonLeft setImageSize:CGSizeMake(24, 24)];
        _screenLockButtonLeft.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        _screenLockButtonLeft.layer.cornerRadius = 6;
        _screenLockButtonLeft.layer.masksToBounds = YES;
        [_screenLockButtonLeft addTarget:self action:@selector(onScreenLockButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _screenLockButtonLeft;
}

- (ImageButton *)snapshotButton {
    if (!_snapshotButton) {
        _snapshotButton = [[ImageButton alloc] initWithFrame:CGRectMake(0, 0, kButtonStandardSize, kButtonStandardSize) imageName:@"player_snapshot"];
        [_snapshotButton setImageSize:CGSizeMake(24, 24)];
        _snapshotButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        _snapshotButton.layer.cornerRadius = 6;
        _snapshotButton.layer.masksToBounds = YES;
        [_snapshotButton addTarget:self action:@selector(onSnapshotButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _snapshotButton;
}

- (PlayerDetailsWatchTimeTips *)watchTimeTips {
    if (!_watchTimeTips) {
        _watchTimeTips = [[PlayerDetailsWatchTimeTips alloc] init];
    }
    return _watchTimeTips;
}

- (PlayerDetailsSideMoreView *)sideMoreView {
    if (!_sideMoreView) {
        _sideMoreView = [[PlayerDetailsSideMoreView alloc] init];
    }
    return _sideMoreView;
}

@end
