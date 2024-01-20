//
//  VideoDetailsPlayerView.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/1/17.
//

#import "VideoDetailsPlayerView.h"

#import "Reachability.h"
#import "AlivcPlayerManager.h"
#import "Utils.h"
#import "CommonFunc.h"

//view
#import "PlayerDetailsControlView.h"
#import "PlayerDetailsMoreView.h"
#import "PlayerDetailsFirstStartGuideView.h"
#import "PlayerDetailsWaterMarkView.h"
#import "PlayerDetailsDotView.h"
#import "PlayerDetailsPreviewLogoBtn.h"
#import "PlayerDetailsThumbnailView.h"
#import "PlayerDetailsPreviewView.h"
#import "PlayerDetailsLoadingView.h"

//tipsView
#import "PlayerDetailsPopView.h"

#define FIRST_OPEN_KEY         @"playerDetailsFirstOpen"
#define FIRST_OPEN_TRUE_VALUE  @"playerDetailsDidFirstOpen"
#define FIRST_OPEN_FALSE_VALUE @"playerDetailsDidNotFirstOpen"

@interface VideoDetailsPlayerView ()<AlivcPlayerProtocal, PlayerDetailsPopViewDelegate, PlayerDetailsControlViewDelegate, PlayerDetailsMoreViewDelegate, PlayerDetailsDotViewDelegate>

@property (nonatomic, strong) UIView *playerView;
@property (nonatomic, strong) UIImageView *coverImageView;         //封面
@property (nonatomic, strong) PlayerDetailsControlView *controlView;
@property (nonatomic, strong) PlayerDetailsMoreView *moreView;     //更多界面

@property (nonatomic, strong) PlayerDetailsFirstStartGuideView *guideView;     //导航
@property (nonatomic, strong) PlayerDetailsPopView *popLayer;  //弹出的提示界面
@property (nonatomic, strong) PlayerDetailsLoadingView *loadingView; //loading
@property (nonatomic, strong) PlayerDetailsLoadingView *qualityLoadingView;  //清晰度loading
@property (nonatomic, strong) PlayerDetailsDotView *dotView;
@property (nonatomic, strong) PlayerDetailsPreviewLogoBtn *previewLogoBtn;
@property (nonatomic, strong) PlayerDetailsPreviewView *previewView;
@property (nonatomic, strong) PlayerDetailsThumbnailView *thumbnailView;  //缩略图功能
@property (strong, nonatomic) PlayerDetailsWaterMarkView *waterMarkView; //  水印

#pragma mark - data
@property (nonatomic, strong) Reachability *reachability;       //网络监听
@property (nonatomic, assign) CGRect saveFrame;                    //记录竖屏时尺寸,横屏时为全屏状态。
@property (nonatomic, assign) BOOL mProgressCanUpdate;             //进度条是否更新，默认是NO
@property (strong, nonatomic) AVPTrackInfo *currentTrackInfo; //当前播放视频的清晰度信息

#pragma mark - 播放方式

@property (nonatomic, assign) CGFloat touchDownProgressValue;

@property (nonatomic, assign) NSTimeInterval keyFrameTime;
@property (nonatomic, assign) float saveCurrentTime;               //保存重试之前的播放时间

//标准网络监听状态，保证只有切换网络时才调用reload
@property (nonatomic, assign) BOOL isNetChange;
@property (nonatomic, assign) BOOL isEnterBackground;
@property (nonatomic, assign) BOOL isPauseByBackground;

@end

@implementation VideoDetailsPlayerView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(becomeActive)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(resignActive)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(resignActive)
//                                                     name:UIApplicationWillResignActiveNotification
//                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clickHideDotView)
                                                     name:@"GestureViewSingleClick"
                                                   object:nil];

        self.saveFrame = [Utils isInterfaceOrientationPortrait] ? frame : CGRectZero;
        self.mProgressCanUpdate = YES;
        self.isNetChange = NO;

        //设置view
        self.keyFrameTime = 0;
        [self addSubview:self.playerView];
        [self addSubview:self.coverImageView];

        self.controlView.delegate = self;
        [self addSubview:self.controlView];

        self.moreView.delegate = self;
        [self addSubview:self.moreView];

        self.popLayer.delegate = self;
        [self addSubview:self.popLayer];

        [self addSubview:self.previewView];
        [self addSubview:self.loadingView];
        [self addSubview:self.qualityLoadingView];
        [self addSubview:self.dotView];
        [self addSubview:self.thumbnailView];

        //屏幕旋转通知
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleDeviceOrientationDidChange:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];

        //网络状态判定
        self.reachability = [Reachability reachabilityForInternetConnection];
        [self.reachability startNotifier];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged)
                                                     name:SVReachabilityChangedNotification
                                                   object:nil];
        //存储第一次触发saas
        NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:FIRST_OPEN_KEY];
        if (!str) {
            [[NSUserDefaults standardUserDefaults] setValue:FIRST_OPEN_TRUE_VALUE forKey:FIRST_OPEN_KEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    self.playerView.frame = self.bounds;

    PlayerDetailsProgressView *progressView = [self.controlView viewWithTag:1076398];
    if (width > 500) {
        [progressView setDotsHidden:NO];
    } else {
        [progressView setDotsHidden:YES];
    }

    self.previewLogoView.frame = CGRectMake(20, self.bounds.size.height - 60, 150, 40);

    if (self.waterMarkView) {
        self.waterMarkView.frame = CGRectMake(self.bounds.size.width - 60, 15, 40, 20);
    }
    self.coverImageView.frame = self.bounds;
    self.controlView.frame = self.bounds;
    self.moreView.frame = self.bounds;
    self.guideView.frame =  self.bounds;
    self.popLayer.frame = self.bounds;
    self.previewView.frame = self.bounds;
    self.popLayer.center = CGPointMake(width / 2, height / 2);
    self.thumbnailView.frame = CGRectMake(width / 2 - 80, height / 2 - 60, 160, 120);

    float x = (self.bounds.size.width -  AlilyunViewLoadingViewWidth) / 2;
    float y = (self.bounds.size.height - AlilyunViewLoadingViewHeight) / 2;
    self.qualityLoadingView.frame = self.loadingView.frame = CGRectMake(x, y, AlilyunViewLoadingViewWidth, AlilyunViewLoadingViewHeight);
}

- (void)becomeActive {
    _isEnterBackground = NO;
    if ([AlivcPlayerManager manager].currentPlayStatus == AVPStatusPaused && _isPauseByBackground && [self isPresent]) {
        _isPauseByBackground = NO;
        [self resume];
    }
}

- (void)resignActive {
    _isEnterBackground = YES;
    if ([AlivcPlayerManager manager].currentPlayStatus == AVPStatusStarted || [AlivcPlayerManager manager].currentPlayStatus == AVPStatusPrepared) {
        _isPauseByBackground = YES;
        [self pause];
    }
}

- (void)clickHideDotView {
    self.dotView.hidden = YES;
}

#pragma mark - 网络状态改变
- (void)reachabilityChanged {
    if (self.playerViewState != AVPStatusIdle) {
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
        case SVNetworkStatusReachableViaWWAN:{
            [self reloadWhenNetChange];
            if ([AlivcPlayerManager manager].playMethod == AlvcPlayMethodLocal) {
                return NO;
            }
            [self stop];
            [self unlockScreen];
            [self.popLayer showPopViewWithCode:ALYPVPlayerPopCodeUseMobileNetwork popMsg:nil];
            [self.loadingView dismiss];
            [self.qualityLoadingView dismiss];
            NSLog(@"播放器展示4G提醒");
            ret = YES;
        }
        break;
        default:
            break;
    }
    return ret;
}

#pragma mark - 屏幕旋转
- (void)handleDeviceOrientationDidChange:(UIInterfaceOrientation)interfaceOrientation {
    //进后台或者锁定屏幕后不再旋转屏幕
    if (_isEnterBackground || self.isScreenLocked) {
        return;
    }

    UIDevice *device = [UIDevice currentDevice];

    switch (device.orientation) {
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
        case UIDeviceOrientationUnknown:
        case UIDeviceOrientationPortraitUpsideDown:
            break;
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:{
            // 影响X变成全面屏的问题
            NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:FIRST_OPEN_KEY];
            if ([str isEqualToString:FIRST_OPEN_TRUE_VALUE]) {
                [[NSUserDefaults standardUserDefaults] setValue:FIRST_OPEN_FALSE_VALUE forKey:FIRST_OPEN_KEY];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self addSubview:self.guideView];
            }
        }
        break;
        case UIDeviceOrientationPortrait:{
            if (CGRectEqualToRect(CGRectZero, self.saveFrame)) {
                //开始时全屏展示，self.saveFrame = CGRectZero, 旋转竖屏时做以下默认处理
                CGRect tempFrame = self.frame;
                tempFrame.size.width = self.height;
                tempFrame.size.height = self.height * 9 / 16;
                self.frame = tempFrame;
            } else {
                self.frame = self.saveFrame;
            }
            [self.guideView removeFromSuperview];
        }
        break;
        default:
            break;
    }
}

#pragma mark - 播放器开始播放入口
- (void)playViewPrepareWithURL:(NSURL *)url isLocal:(BOOL)isLocal {
    void (^ startPlayVideo)(void) = ^{
        if ([self networkChangedToShowPopView]) {
            return;
        }
        [AlivcPlayerManager manager].playMethod = self.controlView.playMethod = isLocal ? AlvcPlayMethodLocal : AlvcPlayMethodUrl;
        [[AlivcPlayerManager manager] startPlayWithUrl:url];
        if (!isLocal) {
            [self.loadingView show];
        }
        NSLog(@"播放器prepareWithURL");
    };

    [self addAdditionalSettingWithBlock:startPlayVideo];
}

- (void)playViewPrepareWithVid:(NSString *)vid {
    void (^ startPlayVideo)(void) = ^{
        if ([self networkChangedToShowPopView]) {
            return;
        }
        [AlivcPlayerManager manager].playMethod = self.controlView.playMethod = ALYPVPlayMethodPlayAuth;
        [self.loadingView show];
        Weak(self);
        [[AlivcPlayerManager manager] startPlayWithVidAuth:vid errorBlock:^(NSString *errorMsg) {
            AVPErrorModel *errorModel = [AVPErrorModel new];
            errorModel.message = errorMsg;
            [weakself showPopLayerWithErrorModel:errorModel];
        }];
        NSLog(@"播放器playAuth");
    };

    [self addAdditionalSettingWithBlock:startPlayVideo];
}

- (void)addAdditionalSettingWithBlock:(void (^)(void))startPlayVideo {
    AliyunPlayerViewProgressView *progressView = [self.controlView viewWithTag:1076398];
    [progressView setAdsPart:@"0"]; // 设置都没有视频广告
    [self.controlView setButtonEnable:YES];
    Weak(self);

    // 初始化进度条,把上一条播放视频的进度条 设置为0
    [self.controlView updateProgressWithCurrentTime:0 durationTime:[AlivcPlayerManager manager].duration];
    [progressView removeDots];

    if (self.freeTrialView) {
        [self.freeTrialView removeFromSuperview];
        self.freeTrialView = nil;
    }
    if (self.waterMarkView) {
        [self.waterMarkView removeFromSuperview];
        self.waterMarkView = nil;
    }
    if ([self isWaterMark] == YES) {
        // 添加水印
        self.waterMarkView = [[AVCWaterMarkView alloc]initWithFrame:CGRectMake(self.bounds.size.width - 60, 15, 40, 20) image:[UIImage imageNamed:@""]];
        [self addSubview:self.waterMarkView];
    }

    // 试看
    if (self.isPreviewMode && self.previewTime > 0) {
        self.freeTrialView = [[AVCFreeTrialView alloc]initWithFreeTime:self.previewTime freeTrialType:FreeTrialStart inView:self];
        startPlayVideo();
        return;
    }
    startPlayVideo();
}

#pragma mark - 一般方法
- (void)reloadWhenNetChange {
    if (_isNetChange) {
        [[AlivcPlayerManager manager] reload];
    }
}

- (void)start {
    [[AlivcPlayerManager manager] start];
}

- (void)pause {
    [[AlivcPlayerManager manager] pause];
}

- (void)resume {
    [[AlivcPlayerManager manager] start];
}

- (void)seekTo:(NSTimeInterval)seekTime {
    [[AlivcPlayerManager manager] seekTo:seekTime];
    [self.loadingView show];
}

- (void)stop {
    [[AlivcPlayerManager manager] stop];
    NSLog(@"播放器stop");
}

#pragma mark - AlivcPlayerProtocal
- (void)onPlayerEvent:(AliPlayer *)player eventType:(AVPEventType)eventType {
    switch (eventType) {
        case AVPEventPrepareDone: {
            [self.loadingView dismiss];
            self.popLayer.hidden = YES;
            AVPTrackInfo *info = [player getCurrentTrack:AVPTRACK_TYPE_SAAS_VOD];
            self.currentTrackInfo = info;
//            self.videoTrackInfo = [player getMediaInfo].tracks;
            [self.controlView setBottomViewTrackInfo:info];

            [self updateControlLayerDataWithMediaInfo:[AlivcPlayerManager manager].playMethod == AlvcPlayMethodUrl ? nil : [player getMediaInfo]];

            // 加密视频不支持投屏 非mp4 mov视频不支持airplay
            AVPMediaInfo *mediaInfo = [[AlivcPlayerManager manager] getMediaInfo];
            for (AVPTrackInfo *info in mediaInfo.tracks) {
                NSLog(@"url:::::::%@", info.vodPlayUrl);
            }

            // 添加打点view
            AliyunPlayerViewProgressView *progressView = [self.controlView viewWithTag:1076398];
            progressView.playSlider.isSupportDot = YES;
            progressView.duration = [AlivcPlayerManager manager].duration;
            NSMutableArray *timeArray = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in self.dotsArray) {
                NSNumber *time = @([[dic objectForKey:@"time"]integerValue]);
                if ([[dic objectForKey:@"time"]integerValue] < [AlivcPlayerManager manager].duration / 1000) {
                    [timeArray addObject:time];
                }
            }
            [progressView setDotWithTimeArray:timeArray];
        }
        break;
        case AVPEventFirstRenderedStart: {
            [self.loadingView dismiss];
            self.popLayer.hidden = YES;
            [self.controlView setEnableGesture:YES];
            //开启常亮状态
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
            //隐藏封面
            if (self.coverImageView) {
                self.coverImageView.hidden = YES;
                NSLog(@"播放器:首帧加载完成封面隐藏");
            }
            NSLog(@"AVPEventFirstRenderedStart--首帧回调");
        }
        break;
        case AVPEventCompletion: {
            if (self.isPreviewMode && self.previewTime > 0) {
                [self.popLayer showPopViewWithCode:ALYPVPlayerPopCodeUnreachableNetwork popMsg:[@"试看结束" localString]];
            } else {
                if (self.delegate && [self.delegate respondsToSelector:@selector(onFinishWithdPlayerView:)]) {
                    [self.delegate onFinishWithdPlayerView:self];
                }
            }
            [self unlockScreen];
        }
        break;
        case AVPEventLoadingStart: {
            [self.loadingView show];
        }
        break;
        case AVPEventLoadingEnd: {
            [self.loadingView setHidden:YES];
        }
        break;
        case AVPEventSeekEnd:{
            self.mProgressCanUpdate = YES;
            [self.loadingView dismiss];
            NSLog(@"seekDone");
        }
        break;
        case AVPEventLoopingStart:
            break;
        default:
            break;
    }
}

/**
 @brief 播放器事件回调
 @param player 播放器player指针
 @param eventWithString 播放器事件类型
 @param description 播放器事件说明
 @see AVPEventType
 */
- (void)onPlayerEvent:(AliPlayer *)player eventWithString:(AVPEventWithString)eventWithString description:(NSString *)description {
    //过滤EVENT_PLAYER_DIRECT_COMPONENT_MSG 打印信息
    if (eventWithString != EVENT_PLAYER_DIRECT_COMPONENT_MSG) {
        [MBProgressHUD showMessage:description ToView:self];
    }
}

- (void)onError:(AliPlayer *)player errorModel:(AVPErrorModel *)errorModel {
    //取消屏幕锁定旋转状态
    [self unlockScreen];
    //关闭loading动画
    [self.loadingView dismiss];

    //根据播放器状态处理seek时thumb是否可以拖动
    // [self.controlView updateViewWithPlayerState:self.aliPlayer.playerState isScreenLocked:self.isScreenLocked fixedPortrait:self.isProtrait];
    //根据错误信息，展示popLayer界面
    [self showPopLayerWithErrorModel:errorModel];
    NSLog(@"errorCode:%lu errorMessage:%@", (unsigned long)errorModel.code, errorModel.message);
}

- (void)onCurrentPositionUpdate:(AliPlayer *)player position:(int64_t)position {
    NSTimeInterval currentTime = position;
    NSTimeInterval durationTime = [AlivcPlayerManager manager].duration;
    self.saveCurrentTime = currentTime / 1000;

    if (self.isPreviewMode && self.previewTime > 0 && position >= self.previewTime * 1000) {
        [self.controlView updateProgressWithCurrentTime:self.previewTime * 1000 durationTime:durationTime];
        [self stop];
        if (self.freeTrialView) {
            [self.freeTrialView removeFromSuperview];
            self.freeTrialView = nil;
        }
        self.freeTrialView = [[AVCFreeTrialView alloc]initWithFreeTime:300 freeTrialType:FreeTrialEnd inView:self];
        [self.controlView setButtonEnable:NO];
    }

    if (self.mProgressCanUpdate == YES) {
        if (self.keyFrameTime > 0 && position < self.keyFrameTime) {
            // 屏蔽关键帧问题
            return;
        }
        [self.controlView updateProgressWithCurrentTime:currentTime durationTime:durationTime];
        self.keyFrameTime = 0;
    }
}

/**
 @brief 视频缓存位置回调
 @param player 播放器player指针
 @param position 视频当前缓存位置
 */
- (void)onBufferedPositionUpdate:(AliPlayer *)player position:(int64_t)position {
    self.controlView.loadTimeProgress = (float)position / player.duration;
}

/**
 @brief 获取track信息回调
 @param player 播放器player指针
 @param info track流信息数组
 @see AVPTrackInfo
 */
- (void)onTrackReady:(AliPlayer *)player info:(NSArray<AVPTrackInfo *> *)info {
    AVPMediaInfo *mediaInfo = [player getMediaInfo];
    if ((nil != mediaInfo.thumbnails) && (0 < [mediaInfo.thumbnails count])) {
        [player setThumbnailUrl:[mediaInfo.thumbnails objectAtIndex:0].URL];
        self.trackHasThumbnai = YES;
    } else {
        self.trackHasThumbnai = NO;
    }
    self.controlView.info = info;
}

/**
 @brief track切换完成回调
 @param player 播放器player指针
 @param info 切换后的信息 参考AVPTrackInfo
 @see AVPTrackInfo
 */
- (void)onTrackChanged:(AliPlayer *)player info:(AVPTrackInfo *)info {
    //选中切换
    NSLog(@"%@", info.trackDefinition);
    self.currentTrackInfo = info;
    [self.loadingView dismiss];
    [self.controlView setBottomViewTrackInfo:info];
    NSString *showString = [NSString stringWithFormat:@"%@%@", [@"已为你切换至" localString], [info.trackDefinition localString]];
    [MBProgressHUD showMessage:showString ToView:nil];
}

/**
 @brief 播放器状态改变回调
 @param player 播放器player指针
 @param oldStatus 老的播放器状态 参考AVPStatus
 @param newStatus 新的播放器状态 参考AVPStatus
 @see AVPStatus
 */
- (void)onPlayerStatusChanged:(AliPlayer *)player oldStatus:(AVPStatus)oldStatus newStatus:(AVPStatus)newStatus {
    self.currentPlayStatus = newStatus;
    NSLog(@"播放器状态更新：%lu", (unsigned long)newStatus);
    if (_isEnterBackground) {
        if (self.currentPlayStatus == AVPStatusStarted || self.currentPlayStatus == AVPStatusPrepared) {
            [self pause];
        }
    }
    //更新UI状态
    [self.controlView updateViewWithPlayerState:self.currentPlayStatus isScreenLocked:self.isScreenLocked fixedPortrait:self.isProtrait];
}

- (void)onGetThumbnailSuc:(int64_t)positionMs fromPos:(int64_t)fromPos toPos:(int64_t)toPos image:(id)image {
    self.thumbnailView.time = positionMs;
    self.thumbnailView.thumbnailImage = (UIImage *)image;
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
        [MBProgressHUD showMessage:[@"截图为空" localString]  inView:self];
        return;
    }
    [CommonFunc saveImage:image inView:self];
}

/**
@brief SEI回调
@param type 类型
@param data 数据
@see AVPImage
*/
- (void)onSEIData:(AliPlayer *)player type:(int)type data:(NSData *)data {
    NSString *str = [NSString stringWithUTF8String:data.bytes];
    NSLog(@"SEI: %@ %@", data, str);
}

#pragma mark dotDelegate

- (void)alivcLongVideoDotViewClickToseek:(NSTimeInterval)time {
    [self seekTo:time];
    self.dotView.hidden = YES;
}

#pragma mark - popdelegate
- (void)showPopViewWithType:(PlayerErrorType)type {
    self.popLayer.hidden = YES;
    switch (type) {
        case PlayerErrorTypeReplay: {
            //重播
            [self seekTo:0];
            [self.aliPlayer prepare];
            [self.aliPlayer start];
        }
        break;
        case PlayerErrorTypeRetry: {
            if ([self.delegate respondsToSelector:@selector(onRetryButtonClickWithAliyunVodPlayerView:)]) {
                [self.delegate onRetryButtonClickWithAliyunVodPlayerView:self];
            } else {
                [self retry];
            }
        }
        break;
        case PlayerErrorTypePause: {
            [self updatePlayDataReplayWithPlayMethod:self.playMethod];
        }
        break;
        case PlayerErrorTypeStsExpired: {
            if ([self.delegate respondsToSelector:@selector(onSecurityTokenExpiredWithAliyunVodPlayerView:)]) {
                [self.delegate onSecurityTokenExpiredWithAliyunVodPlayerView:self];
            } else {
                [self retry];
            }
        }
        break;
        default:
            break;
    }
}

- (void)retry {
    [self stop];
    //重试播放
    if ([self networkChangedToShowPopView]) {
        return;
    }
    [self.loadingView show];
    [self.aliPlayer prepare];
    if (self.saveCurrentTime > 0) {
        [self seekTo:self.saveCurrentTime * 1000];
    }
    [self.aliPlayer start];
}

/*
 * 功能 ：播放器
 * 参数 ：playMethod 播放方式
 */
- (void)updatePlayDataReplayWithPlayMethod:(AlvcPlayMethod)playMethod {
    if (self.playerConfig && (self.playerConfig.sourceType != SourceTypeNull)) {
        switch (self.playerConfig.sourceType) {
            case SourceTypeUrl: {
                //artc默认参数设置
                if ([self.playerConfig.urlSource.playerUrl.absoluteString containsString:@"artc"]) {
                    AVPConfig *defaultConfig = [[AVPConfig alloc] init];
                    if (self.playerConfig.config.startBufferDuration == defaultConfig.startBufferDuration) {
                        defaultConfig.startBufferDuration = 10;
                    } else {
                        defaultConfig.startBufferDuration = self.playerConfig.config.startBufferDuration;
                    }
                    if (self.playerConfig.config.highBufferDuration == defaultConfig.highBufferDuration) {
                        defaultConfig.highBufferDuration = 10;
                    } else {
                        defaultConfig.highBufferDuration = self.playerConfig.config.highBufferDuration;
                    }
//                    if (self.playerConfig.config.maxBufferDuration == defaultConfig.maxBufferDuration) {
//                        defaultConfig.maxBufferDuration = 150;
//                    }else {
//                        defaultConfig.maxBufferDuration = self.playerConfig.config.maxBufferDuration;
//                    }
                    if (self.playerConfig.config.maxDelayTime == defaultConfig.maxDelayTime) {
                        defaultConfig.maxDelayTime = 1000;
                    } else {
                        defaultConfig.maxDelayTime = self.playerConfig.config.maxDelayTime;
                    }
                    defaultConfig.networkTimeout = self.playerConfig.config.networkTimeout;
                    defaultConfig.networkRetryCount = self.playerConfig.config.networkRetryCount;
                    defaultConfig.maxProbeSize = self.playerConfig.config.maxProbeSize;
                    defaultConfig.referer = self.playerConfig.config.referer;
                    defaultConfig.userAgent = self.playerConfig.config.userAgent;
                    defaultConfig.httpProxy = self.playerConfig.config.httpProxy;
                    defaultConfig.clearShowWhenStop = self.playerConfig.config.clearShowWhenStop;
                    defaultConfig.httpHeaders = self.playerConfig.config.httpHeaders;
                    defaultConfig.enableSEI = self.playerConfig.config.enableSEI;
                    [self.aliPlayer setConfig:defaultConfig];
                }
                [self.aliPlayer setUrlSource:self.playerConfig.urlSource];
            }
            break;
            case SourceTypeSts: {
                [self.aliPlayer setStsSource:self.playerConfig.vidStsSource];
            }
            break;
            case SourceTypeMps: {
                [self.aliPlayer setMpsSource:self.playerConfig.vidMpsSource];
            }
            break;
            case SourceTypeAuth: {
                [self.aliPlayer setAuthSource:self.playerConfig.vidAuthSource];
            }
            break;
            case SourceTypeLiveSts: {
                [self.aliPlayer setLiveStsSource:self.playerConfig.liveStsSource];
                __weak typeof(self) weakSelf = self;
                [self.aliPlayer setVerifyStsCallback:^AVPStsStatus (AVPStsInfo info) {
                    NSDate *now = [NSDate new];
                    NSTimeInterval diff = weakSelf.playerConfig.liveStsExpireTime - now.timeIntervalSince1970;
                    if (diff > 300) {
                        return Valid;
                    }

                    if ([weakSelf.delegate respondsToSelector:@selector(onUpdateLiveStsWithAliyunVodPlayerView:)]) {
                        [weakSelf.delegate onUpdateLiveStsWithAliyunVodPlayerView:weakSelf];
                    }
                    return Pending;
                }];
            }
            break;
            default:
                break;
        }
        [self.loadingView show];
        [self.aliPlayer prepare];
        if (self.saveCurrentTime > 0) {
            [self seekTo:self.saveCurrentTime * 1000];
        }
        [self.aliPlayer start];
    } else {
        self.urlSource = [[AVPUrlSource alloc]init];
        self.urlSource.playerUrl = self.localSource.url;

        self.stsSource = [[AVPVidStsSource alloc]initWithVid:self.stsModel.videoId accessKeyId:self.stsModel.accessKeyId accessKeySecret:self.stsModel.accessSecret securityToken:self.stsModel.ststoken region:@""];
        // 再次配置试看
        BOOL isVip = [[AlivcLongVideoCommonFunc getUDSetWithIndex:5]boolValue];
        if (isVip == NO && self.currentLongVideoModel.isVip && [self.currentLongVideoModel.isVip isEqualToString:@"true"]) {
            VidPlayerConfigGenerator *vp = [[VidPlayerConfigGenerator alloc] init];
            [vp addVidPlayerConfigByStringValue:@"PlayDomain" value:@"alivc-demo-vod-player.aliyuncs.com"];
            [vp setPreviewTime:300];
            self.stsSource.playConfig = [vp generatePlayerConfig];
        }

        [self.controlView updateProgressWithCurrentTime:0 durationTime:self.aliPlayer.duration];

        self.mpsSource = [[AVPVidMpsSource alloc]initWithVid:self.mpsModel.videoId accId:self.mpsModel.accessKey accSecret:self.mpsModel.accessSecret stsToken:self.mpsModel.stsToken authInfo:self.mpsModel.stsToken region:self.mpsModel.region playDomain:self.mpsModel.playDomain mtsHlsUriToken:self.mpsModel.hlsUriToken];

        self.authSource = [[AVPVidAuthSource alloc]initWithVid:self.playAuthModel.videoId playAuth:self.playAuthModel.playAuth region:@""];

        switch (playMethod) {
            case ALYPVPlayMethodUrl: {
                [self.aliPlayer setUrlSource:self.urlSource];
            }
            break;
            case ALYPVPlayMethodMPS: {
                [self.aliPlayer setMpsSource:self.mpsSource];
            }
            break;
            case ALYPVPlayMethodPlayAuth: {
                [self.aliPlayer setAuthSource:self.authSource];
            }
            break;
            case ALYPVPlayMethodSTS: {
                [self.aliPlayer setStsSource:self.stsSource];
            }
            break;
            default:
                break;
        }
        [self.loadingView show];
        [self.aliPlayer prepare];
        if (self.saveCurrentTime > 0) {
            [self seekTo:self.saveCurrentTime * 1000];
        }
        [self.aliPlayer start];
    }
}

- (void)onBackClickedWithPopView:(PlayerDetailsPopView *)popView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onBackViewClickWithPlayerView:)]) {
        [self.delegate onBackViewClickWithPlayerView:self];
    } else {
        [self stop];
    }
}

#pragma mark - loading动画
- (void)loadAnimation {
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.5;
    [self.layer addAnimation:animation forKey:nil];
}

//取消屏幕锁定旋转状态
- (void)unlockScreen {
    //弹出错误窗口时 取消锁屏。
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliyunVodPlayerView:lockScreen:)]) {
        if (self.isScreenLocked == YES || self.fixedPortrait) {
            [self.delegate aliyunVodPlayerView:self lockScreen:NO];
            //弹出错误窗口时 取消锁屏。
            [self.controlView cancelLockScreenWithIsScreenLocked:self.isScreenLocked fixedPortrait:self.fixedPortrait];
            self.isScreenLocked = NO;
        }
    }
}

/**
 * 功能：声音调节
 */
- (void)setVolume:(float)volume {
    [self.aliPlayer setVolume:volume];
}

#pragma mark - public method

//更新封面图片
- (void)updateCoverWithCoverUrl:(NSString *)coverUrl {
    //以用户设置的为先，标题和封面,用户在控制台设置coverurl地址
    if (self.coverImageView) {
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.coverImageView.clipsToBounds = YES;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:coverUrl]];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.coverImageView.image = [UIImage imageWithData:data];
                if (!self.coverImageView.hidden) {
                    if ([self isVideoAds]) {
                        self.coverImageView.hidden = YES;
                    } else {
                        self.coverImageView.hidden = NO;
                    }
                    NSLog(@"播放器:展示封面");
                }
            });
        });
    }
}

//更新controlLayer界面ui数据
- (void)updateControlLayerDataWithMediaInfo:(AVPMediaInfo *)mediaInfo {
    //以用户设置的为先，标题和封面,用户在控制台设置coverurl地址
    if (!self.coverUrl && mediaInfo.coverURL && mediaInfo.coverURL.length > 0) {
        [self updateCoverWithCoverUrl:mediaInfo.coverURL];
    }
    //设置数据
    self.controlView.videoInfo = mediaInfo;
    //标题, 未播放URL 做备用判定
    if (!self.currentMediaTitle) {
        if (mediaInfo.title && mediaInfo.title.length > 0) {
            self.controlView.title = mediaInfo.title;
        } else if (self.localSource.url) {
            NSArray *ary = [[self.localSource.url absoluteString] componentsSeparatedByString:@"/"];
            self.controlView.title = ary.lastObject;
        }
    } else {
        self.controlView.title = self.currentMediaTitle;
    }
}

//根据错误信息，展示popLayer界面
- (void)showPopLayerWithErrorModel:(AVPErrorModel *)errorModel {
    NSString *errorShowMsg = [NSString stringWithFormat:@"%@\n errorCode:%d", errorModel.message, (int)errorModel.code];

    //点击重试后，重新获取信息
    if (self.playerConfig && (self.playerConfig.sourceType == SourceTypeNull) && errorModel.code == ERROR_SERVER_POP_UNKNOWN) {
        [self.popLayer showPopViewWithCode:ALYPVPlayerPopCodeSecurityTokenExpired popMsg:errorShowMsg];
    } else {
        [self.popLayer showPopViewWithCode:ALYPVPlayerPopCodeServerError popMsg:errorShowMsg];
    }
    [self unlockScreen];
}

#pragma mark - AliyunControlViewDelegate
- (void)onBackViewClickWithControlView:(PlayerDetailsControlView *)controlView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onBackViewClickWithAliyunVodPlayerView:)]) {
        [self.delegate onBackViewClickWithAliyunVodPlayerView:self];
    } else {
        [self stop];
    }
}

- (void)onDownloadButtonClickWithControlView:(PlayerDetailsControlView *)controlViewP {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onDownloadButtonClickWithPlayerView:)]) {
        [self.delegate onDownloadButtonClickWithPlayerView:self];
    }
}

- (void)onClickedPlayButtonWithControlView:(PlayerDetailsControlView *)controlView {
    AVPStatus state = [self playerViewState];
    if (state == AVPStatusStarted) {
        //如果是直播则stop
        if (self.aliPlayer.duration == 0) {
            _isLive = YES;
            [self stop];
        } else {
            [self pause];
        }
    } else if (state == AVPStatusPrepared) {
        [self.aliPlayer start];
    } else if (state == AVPStatusPaused) {
        [self resume];
    } else if (state == AVPStatusStopped) {
        if (self.playerConfig) {
            [self.aliPlayer prepare];
            //如果是直播
            if (_isLive) {
                [self start];
            }
        } else {
            [self resume];
        }
    }
}

- (void)onClickedfullScreenButtonWithControlView:(PlayerDetailsControlView *)controlView {
    if (self.fixedPortrait) {
        controlView.lockButton.hidden = self.isProtrait;
        if (!self.isProtrait) {
            self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            self.isProtrait = YES;
        } else {
            self.frame = self.saveFrame;
            self.isProtrait = NO;
        }

        if (self.delegate && [self.delegate respondsToSelector:@selector(aliyunVodPlayerView:fullScreen:)]) {
            [self.delegate aliyunVodPlayerView:self fullScreen:self.isProtrait];
        }
    } else {
        if (self.isScreenLocked) {
            return;
        }

        if (self.delegate && [self.delegate respondsToSelector:@selector(aliyunVodPlayerView:fullScreen:)]) {
            [self.delegate aliyunVodPlayerView:self fullScreen:self.isProtrait];
        }
        [Utils setFullOrHalfScreen];
    }
    controlView.isProtrait = self.isProtrait;
    [self setNeedsLayout];
}

- (void)controlView:(PlayerDetailsControlView *)controlView dragProgressSliderValue:(float)progressValue event:(UIControlEvents)event {
    NSInteger totalTime = 0;
    if ([self isVideoAds]) {
        totalTime = self.aliPlayer.duration + _adsPlayerView.seconds * 3 * 1000;
    } else {
        totalTime = self.aliPlayer.duration;
    }
    AliyunPlayerViewProgressView *progressView = [self.controlView viewWithTag:1076398];

    if (totalTime == 0) {
        [progressView.playSlider setEnabled:NO];
        return;
    }

    switch (event) {
        case UIControlEventTouchDown: {
            if (progressView.playSlider.isSupportDot == YES) {
                NSInteger dotTime = [self.dotView checkIsTouchOntheDot:totalTime * progressValue inScope:totalTime * 0.05];
                if (dotTime > 0) {
                    if (self.dotView.hidden == YES) {
                        self.dotView.hidden = NO;
                        CGFloat x = progressView.frame.origin.x;
                        CGFloat progressWidth = progressView.frame.size.width;
                        self.dotView.frame = CGRectMake(x + progressWidth * progressValue, 280, 150, 30);
                        [self.dotView showViewWithTime:dotTime];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            self.dotView.hidden = YES;
                        });
                    }
                }
            }
        }
        break;
        case UIControlEventValueChanged: {
            self.mProgressCanUpdate = NO;
            //更新UI上的当前时间
            [self.controlView updateCurrentTime:progressValue * totalTime durationTime:totalTime];
            if (self.trackHasThumbnai == YES) {
                [self.aliPlayer getThumbnail:totalTime * progressValue];
            }
        }
        break;
//        case UIControlEventTouchCancel:
        case UIControlEventTouchUpOutside:
        case UIControlEventTouchUpInside: {
            self.thumbnailView.hidden = YES;
            if (self.stsSource.playConfig  && progressValue * self.aliPlayer.duration > 300 * 1000) {
                self.previewView.hidden = NO;
                [self.adsPlayerView releaseAdsPlayer];
                [self.adsPlayerView removeFromSuperview];
                self.adsPlayerView = nil;
                [self.aliPlayer stop];
            } else if ([self isVideoAds]) {
                CGFloat seek = [_adsPlayerView allowSeek:progressValue];
                if (seek == 0) {
                    //  在广告播放期间不能seek
                    return;
                } else if (seek == 1.0) {
                    // 正常seek
                    NSTimeInterval seekTime = [_adsPlayerView seekWithProgressValue:progressValue];
                    [self seekTo:seekTime];
                } else if (seek == 2) {
                    // 跳跃广告的seek，直接播放广告
                    self.mProgressCanUpdate = YES;
                    return;
                }
            } else {
                [self seekTo:progressValue * self.aliPlayer.duration];
            }
            NSLog(@"t播放器测试：TouchUpInside 跳转到%.1f", progressValue * self.aliPlayer.duration);
            AVPStatus state = [self playerViewState];
            if (state == AVPStatusPaused) {
                [self.aliPlayer start];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //在播放器回调的方法里，防止sdk异常不进行seekdone的回调，在3秒后增加处理，防止ui一直异常
                self.mProgressCanUpdate = YES;
            });
        }
        break;
        //点击事件
        case UIControlEventTouchDownRepeat:{
            self.mProgressCanUpdate = NO;
            if ([self isVideoAds]) {
                NSTimeInterval seekTime = [_adsPlayerView seekWithProgressValue:progressValue];
                [self seekTo:seekTime];
            } else {
                NSLog(@"UIControlEventTouchDownRepeat::%f", progressValue);
                [self seekTo:progressValue * self.aliPlayer.duration];
            }
            NSLog(@"t播放器测试：DownRepeat跳转到%.1f", progressValue * self.aliPlayer.duration);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //在播放器回调的方法里，防止sdk异常不进行seekdone的回调，在3秒后增加处理，防止ui一直异常
                self.mProgressCanUpdate = YES;
            });
        }
        break;

        case UIControlEventTouchCancel:
            self.mProgressCanUpdate = YES;
            self.thumbnailView.hidden = YES;
            break;

        default:
            self.mProgressCanUpdate = YES;
            break;
    }
}

- (void)controlView:(PlayerDetailsControlView *)controlView qualityListViewOnItemClick:(int)index {
    //切换清晰度
    if (self.currentTrackInfo.trackIndex == index) {
        NSString *showString = [NSString stringWithFormat:@"%@%@", [@"当前清晰度为" localString], [_currentTrackInfo.trackDefinition localString]];
        [MBProgressHUD showMessage:showString ToView:nil];
        return;
    }
    [self.loadingView show];
    [self.aliPlayer selectTrack:index];
    if (self.currentPlayStatus == AVPStatusPaused) {
        [self resume];
    }
}

- (void)onLockButtonClickedWithAliyunControlView:(PlayerDetailsControlView *)controlView {
    controlView.lockButton.selected = !controlView.lockButton.isSelected;
    self.isScreenLocked = controlView.lockButton.selected;
    //锁屏判定
    [controlView lockScreenWithIsScreenLocked:self.isScreenLocked fixedPortrait:self.fixedPortrait];
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliyunVodPlayerView:lockScreen:)]) {
        BOOL lScreen = self.isScreenLocked;
        if (self.isProtrait) {
            lScreen = YES;
        }
        [self.delegate aliyunVodPlayerView:self lockScreen:lScreen];
    }
}

- (void)onSnapshopButtonClickedWithAliyunControlView:(PlayerDetailsControlView *)controlView {
    NSLog(@"截图");

    [self.aliPlayer snapShot];
}

- (void)onSpeedViewClickedWithControlView:(PlayerDetailsControlView *)controlView {
    [self.moreView showSpeedViewMoveInAnimate];
}

- (void)controlView:(PlayerDetailsControlView *)controlView selectTrackIndex:(NSInteger)trackIndex {
    [self.aliPlayer selectTrack:(int)trackIndex];
}

#pragma mark PlayerMoreViewDelegate
- (void)moreView:(PlayerDetailsMoreView *)moreView clickedDownloadBtn:(UIButton *)downloadBtn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onDownloadButtonClickWithPlayerView:)]) {
        [self.delegate onDownloadButtonClickWithPlayerView:self];
    }
}

- (void)moreView:(PlayerDetailsMoreView *)moreView speedChanged:(float)speedValue {
    [self.aliPlayer setRate:speedValue];
}

- (void)moreView:(PlayerDetailsMoreView *)moreView scalingIndexChanged:(NSInteger)index {
    switch (index) {
        case 0:
            self.aliPlayer.scalingMode = AVP_SCALINGMODE_SCALEASPECTFIT;
            break;
        case 1:
            self.aliPlayer.scalingMode = AVP_SCALINGMODE_SCALETOFILL;
            break;
        case 2:
            self.aliPlayer.scalingMode = AVP_SCALINGMODE_SCALEASPECTFILL;
            break;
        default:
            break;
    }
    NSLog(@"选择了画面比例模式 %ld", (long)index);
}

- (void)moreView:(PlayerDetailsMoreView *)moreView loopIndexChanged:(NSInteger)index {
    switch (index) {
        case 0:
            self.aliPlayer.loop = YES;
            break;
        case 1:
            self.aliPlayer.loop = NO;
            break;
        default:
            break;
    }
}

#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    if (self.aliPlayer) {
        [self releasePlayer];
    }
}

- (void)releasePlayer {
    [self.aliPlayer stop];
    [self.aliPlayer destroy];
    if (self.imageAdsView) {
        [self.imageAdsView releaseTimer];
        [self.imageAdsView removeFromSuperview];
        self.imageAdsView = nil;
    }

    if (self.adsPlayerView) {
        [self.adsPlayerView releaseAdsPlayer];
        [self.adsPlayerView removeFromSuperview];
        self.adsPlayerView = nil;
    }
}

#pragma mark - set And get
- (PlayerDetailsDotView *)dotView {
    if (!_dotView) {
        _dotView = [[PlayerDetailsDotView alloc]init];
        _dotView.delegate = self;
        _dotView.hidden = YES;
    }
    return _dotView;
}

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

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.backgroundColor = [UIColor colorWithRed:0.12f green:0.13f blue:0.18f alpha:1.00f];
        _coverImageView.contentMode =  UIViewContentModeScaleAspectFill;
        _coverImageView.clipsToBounds = YES;
    }
    return _coverImageView;
}

- (PlayerDetailsControlView *)controlView {
    if (!_controlView) {
        _controlView = [[PlayerDetailsControlView alloc] init];
        [_controlView.topView.downloadButton removeFromSuperview];
    }
    return _controlView;
}

- (PlayerDetailsMoreView *)moreView {
    if (!_moreView) {
        _moreView = [[PlayerDetailsMoreView alloc] init];
    }
    return _moreView;
}

- (PlayerDetailsFirstStartGuideView *)guideView {
    if (!_guideView) {
        _guideView = [[PlayerDetailsFirstStartGuideView alloc] init];
    }
    return _guideView;
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

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    //指记录竖屏时界面尺寸
    if ([Utils isInterfaceOrientationPortrait]) {
        if (!self.fixedPortrait) {
            self.saveFrame = frame;
        }
    }
}

- (void)setDotsArray:(NSArray *)dotsArray {
    _dotsArray = dotsArray;
    self.dotView.dotsArray = dotsArray;
}


- (void)setCoverUrl:(NSURL *)coverUrl {
    _coverUrl = coverUrl;
    if (coverUrl) {
        if (self.coverImageView) {
            self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
            self.coverImageView.clipsToBounds = YES;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSData *data = [NSData dataWithContentsOfURL:coverUrl];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.coverImageView.image = [UIImage imageWithData:data];
                    if ([self isVideoAds]) {
                        self.coverImageView.hidden = YES;
                    } else {
                        self.coverImageView.hidden = NO;
                    }
                    NSLog(@"播放器:展示封面");
                });
            });
        }
    }
}

- (void)setCirclePlay:(BOOL)circlePlay {
    self.aliPlayer.loop = circlePlay;
}

- (BOOL)circlePlay {
    return self.aliPlayer.loop;
}

- (void)setFixedPortrait:(BOOL)fixedPortrait {
    _fixedPortrait = fixedPortrait;
    if (fixedPortrait) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    } else {
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleDeviceOrientationDidChange:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil
        ];
    }
}

- (BOOL)isPresent {
    return [Utils currentViewController] == [Utils findSuperViewController:self]
}

- (void)loopViewStartAnimation {
    [self.controlView loopViewStartAnimation];
}

- (void)cleanLastFrame:(BOOL)show {
    AVPConfig *config = [self.aliPlayer getConfig];
    config.clearShowWhenStop = show;
    [self.aliPlayer setConfig:config];
}

- (void)hardwareDecoder:(BOOL)decoder {
    self.aliPlayer.enableHardwareDecoder = decoder;
}

- (void)controlViewEnable:(BOOL)enable {
    if (enable == NO) {
        [self.controlView showViewWithOutDelayHide];
    } else {
        [self.controlView showView];
    }
}

//- (void)setPlayerAllConfig:(AlivcVideoPlayPlayerConfig *)playerConfig {
//    _playerConfig = playerConfig;
//    self.aliPlayer.enableHardwareDecoder = playerConfig.enableHardwareDecoder;
//    self.aliPlayer.mirrorMode = playerConfig.mirrorMode;
//    self.aliPlayer.rotateMode = playerConfig.rotateMode;
//    if (playerConfig.config) {
//        [self.aliPlayer setConfig:playerConfig.config];
//    }
//    if (playerConfig.cacheConfig) {
//        [self.aliPlayer setCacheConfig:playerConfig.cacheConfig];
//    }
//    self.noneAdvertisement = YES;
//    self.currentLongVideoModel.authorityType = AlivcPlayVideoNoneAdsType;
//}

@end
