//
//  AlivcPlayerManager.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/1/16.
//

#import "AlivcPlayerManager.h"
#import "AlivcPlayerVideoDBManager.h"
#import "AccountManager.h"
#import "AlivcPlayerVidPlayAuthService.h"
#import "AlivcCacheGlobalSetting.h"

@interface AlivcPlayerManager ()<AVPDelegate, AliPlayerPictureInPictureDelegate>

@property (nonatomic, assign) BOOL isEnterBackground;
@property (nonatomic, assign) AVPEventType playerEventType;
@property (nonatomic, strong) AlivcPlayerVidPlayAuthService *playAuthService;

#pragma mark - 画中画
//https://help.aliyun.com/zh/vod/developer-reference/advanced-features-1#p-93m-izq-1p7
@property (nonatomic, assign) BOOL isPipPaused; // 监听画中画当前是否是暂停状态
@property (nonatomic, weak) AVPictureInPictureController *pipController; // 设置画中画控制器，在画中画即将启动的回调方法中设置，并需要在页面准备销毁时主动将其设置为nil，建议设置
@property (nonatomic, assign) int64_t currentPosition; // 监听播放器当前播放进度，currentPosition设置为监听视频当前播放位置回调中的position参数值

@end

@implementation AlivcPlayerManager

static AlivcPlayerManager *manager = nil;
static dispatch_once_t onceToken;
+ (instancetype)manager
{
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _playAuthService = [[AlivcPlayerVidPlayAuthService alloc] init];
        [self setupPlayer];
    }
    return self;
}

- (void)setupPlayer
{
    _player = [[AliListPlayer alloc] init];
    _player.scalingMode = AVP_SCALINGMODE_SCALEASPECTFIT;
    _player.delegate = self;
    _player.autoPlay = YES;
    // _player.preloadCount = 5;

    //防止乱跳
    self.seekMode = AVP_SEEKMODE_ACCURATE;
    //https://help.aliyun.com/zh/vod/developer-reference/faq-about-apsaravideo-player-sdk-for-ios?spm=a2c4g.11186623.0.i18#task-2233874
//    _player.stsPreloadDefinition = @"SD";//720p
    [_player setMaxAccurateSeekDelta:10000];

    AVPConfig *config = [[AVPConfig alloc] init];
    config.clearShowWhenStop = YES;
    [_player setConfig:config];
    
    [AlivcCacheGlobalSetting setupCacheConfig];
    [AliPlayerGlobalSettings enableHttpDns:YES];;
}

- (void)pause {
    [self.player pause];
    self.currentPlayStatus = AVPStatusPaused; // 快速的前后台切换时，播放器状态的变化不能及时传过来
    [self saveToLocal:self.currentVideoId];
    NSLog(@"播放器pause");
}

- (void)start {
    [self.player start];
    self.currentPlayStatus = AVPStatusStarted;
    NSLog(@"播放器Start");
}

- (void)seekTo:(NSTimeInterval)seekTime {
    if (self.player.duration > 0) {
        [self.player seekToTime:seekTime seekMode:self.seekMode];
    }
    [self saveToLocal:self.currentVideoId];
}

- (void)stop {
    [self.player stop];
    self.currentPlayStatus = AVPStatusStopped;
    [self saveToLocal:self.currentVideoId];
    NSLog(@"播放器stop");
}

- (void)reload {
    [self.player reload];
    NSLog(@"播放器reload");
}

- (void)replay {
    [self.player start];
    self.currentPlayStatus = AVPStatusStarted;
    NSLog(@"播放器replay");
}

//- (void)reset {
//    [self.player reset];
//    NSLog(@"播放器reset");
//}

- (void)snapShot {
    [self.player snapShot];
}

- (AVPMediaInfo *)getMediaInfo {
    return [self.player getMediaInfo];
}

- (void)setPlayerView:(UIView *)playerView {
    self.player.playerView = playerView;
}

- (void)setRate:(float)rate
{
    self.player.rate = rate;
}

- (float)rate
{
    return self.player.rate;
}

- (void)setVolume:(float)volume
{
    [self.player setVolume:volume];
}

- (float)volume
{
    return self.player.volume;
}

#pragma mark - AVPDelegate
- (void)onPlayerEvent:(AliPlayer *)player eventType:(AVPEventType)eventType
{
    NSLog(@"AliPlayereventType:%ld", eventType);
    self.playerEventType = eventType;

    switch (eventType) {
        case AVPEventPrepareDone:{
            [self.player setPictureInPictureEnable:YES];
            [self.player setPictureinPictureDelegate:self];
        } break;
        case AVPEventCompletion:{
            [self saveToLocal:self.currentVideoId];

            if (_pipController) {
                self.isPipPaused = YES;    // 播放结束后，将画中画状态变更为暂停
                [self.pipController invalidatePlaybackState];
            }
        } break;
        case AVPEventSeekEnd:{
            if (_pipController) {
                [self.pipController invalidatePlaybackState];
            }
        } break;
        default:
            break;
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(onPlayerEvent:eventType:)]) {
        [self.delegate onPlayerEvent:self.player eventType:eventType];
    }
}

- (void)onPlayerEvent:(AliPlayer *)player eventWithString:(AVPEventWithString)eventWithString description:(NSString *)description
{
    NSLog(@"description:%@", description);

    if (self.delegate && [self.delegate respondsToSelector:@selector(onPlayerEvent:eventWithString:description:)]) {
        [self.delegate onPlayerEvent:self.player eventWithString:eventWithString description:description];
    }
}

- (void)onError:(AliPlayer *)player errorModel:(AVPErrorModel *)errorModel
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onError:errorModel:)]) {
        [self.delegate onError:self.player errorModel:errorModel];
    }
}

- (void)onVideoSizeChanged:(AliPlayer *)player width:(int)width height:(int)height rotation:(int)rotation
{
}

- (void)onCurrentPositionUpdate:(AliPlayer *)player position:(int64_t)position
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onCurrentPositionUpdate:position:)]) {
        [self.delegate onCurrentPositionUpdate:self.player position:position];
    }
}

- (void)onBufferedPositionUpdate:(AliPlayer *)player position:(int64_t)position
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onBufferedPositionUpdate:position:)]) {
        [self.delegate onBufferedPositionUpdate:self.player position:position];
    }
}

- (void)onTrackReady:(AliPlayer *)player info:(NSArray<AVPTrackInfo *> *)info
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onTrackReady:info:)]) {
        [self.delegate onTrackReady:self.player info:info];
    }
}

- (void)onTrackChanged:(AliPlayer *)player info:(AVPTrackInfo *)info {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onTrackChanged:info:)]) {
        [self.delegate onTrackChanged:self.player info:info];
    }
}

- (void)onSubtitleShow:(AliPlayer *)player trackIndex:(int)trackIndex subtitleID:(long)subtitleID subtitle:(NSString *)subtitle {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSubtitleShow:trackIndex:subtitleID:subtitle:)]) {
        [self.delegate onSubtitleShow:self.player trackIndex:trackIndex subtitleID:subtitleID subtitle:subtitle];
    }
}

- (void)onPlayerStatusChanged:(AliPlayer *)player oldStatus:(AVPStatus)oldStatus newStatus:(AVPStatus)newStatus {
    self.currentPlayStatus = newStatus;
    if (_isEnterBackground) {
        if (self.currentPlayStatus == AVPStatusStarted || self.currentPlayStatus == AVPStatusPrepared) {
            [self pause];
        }
    }
    if (_pipController) {
        [self.pipController invalidatePlaybackState];
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(onPlayerStatusChanged:oldStatus:newStatus:)]) {
        [self.delegate onPlayerStatusChanged:self.player oldStatus:oldStatus newStatus:newStatus];
    }
}

- (void)onGetThumbnailSuc:(int64_t)positionMs fromPos:(int64_t)fromPos toPos:(int64_t)toPos image:(id)image {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onGetThumbnailSuc:fromPos:toPos:image:)]) {
        [self.delegate onGetThumbnailSuc:positionMs fromPos:fromPos toPos:toPos image:image];
    }
}

- (void)onGetThumbnailFailed:(int64_t)positionMs {
    NSLog(@"缩略图获取失败");
}

- (void)onCaptureScreen:(AliPlayer *)player image:(AVPImage *)image {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onCaptureScreen:image:)]) {
        [self.delegate onCaptureScreen:self.player image:image];
    }
}

- (void)onCurrentDownloadSpeed:(AliPlayer *)player speed:(int64_t)speed {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onCurrentDownloadSpeed:speed:)]) {
        [self.delegate onCurrentDownloadSpeed:self.player speed:speed];
    }
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

#pragma mark - 播放

- (void)startPlayWithVidAuth:(NSString *)vid errorBlock:(void (^)(NSString *errorMsg))errorBlock
{
    [self startPlayWithVidAuth:vid errorBlock:errorBlock previewTime:0];
}

- (void)startPlayWithVidAuth:(NSString *)vid errorBlock:(void (^)(NSString *errorMsg))errorBlock previewTime:(int)previewTime {
    if (![vid isKindOfClass:NSString.class]) {
        return;
    }

    // 当前播放的 Vid 和新添加的 Vid相等
    if ([self.currentVideoId isEqualToString:vid]) {
        // 播放完成的话，需要重新启用播放，其他状态都返回
        if (self.currentPlayStatus != AVPStatusCompletion) {
            return;
        }
    }

    //切换的时候保存进度
    if (self.currentVideoId) {
        [self saveToLocal:self.currentVideoId];
    }

    self.currentVideoId = vid;

    self.playMethod = AlivcPlayMethodPlayAuth;
    [self.playAuthService getVidPlayAuth:vid completion:^(NSString *errorMsg, NSString *playAuth) {
        // 错误处理
        if (errorMsg) {
            !errorBlock ? : errorBlock(errorMsg);
            return;
        }
        AVPVidAuthSource *authSource = [[AVPVidAuthSource alloc] init];
        authSource.vid = vid; // 视频ID（VideoId）
        authSource.playAuth = playAuth; // 播放凭证
        authSource.region = @"cn-beijing"; // 点播服务的接入地域，默认为cn-shanghai
        authSource.definitions = @"AUTO";
        if (previewTime > 0) {
            VidPlayerConfigGenerator *vp = [[VidPlayerConfigGenerator alloc] init];
            [vp setPreviewTime:previewTime];//试看时间
            authSource.playConfig = [vp generatePlayerConfig];//设置给播放源
        }

        [self.player setAuthSource:authSource];
        [self.player prepare];
    }];
}

- (void)startPlayWithUrl:(NSURL *)url {
    AVPUrlSource *urlSource = [[AVPUrlSource alloc]urlWithString:url.absoluteString];
    urlSource.definitions = @"AUTO";
    [self.player setUrlSource:urlSource];
    [self.player prepare];
}

- (int64_t)duration {
    return self.player.duration;
}

- (void)getThumbnail:(int64_t)positionMs {
    [self.player getThumbnail:positionMs];
}

- (void)enablePictureInPictureWithDelegate:(id<AliPlayerPictureInPictureDelegate>)pictureInPictureDelegate {
    [self.player setPictureInPictureEnable:YES];
    [self.player setPictureinPictureDelegate:pictureInPictureDelegate];
}

- (void)disablePictureInPicture {
    [self.player setPictureInPictureEnable:NO];
}

#pragma mark - AlivcPlayerVideoHistory

- (void)saveToLocal:(NSString *)videoId
{
    if (!videoId) {
        return;
    }

    int64_t watchTime = self.playerEventType == AVPEventCompletion ? self.player.duration : self.player.currentPosition;

    if (watchTime <= 0) {
        return;
    }

    NSString *userId = ACCOUNT_MANAGER.userId;
    AlivcPlayerVideoDBModel *model = [AlivcPlayerVideoDBModel new];
    model.userId = userId;
    model.videoId = videoId;
    model.watchTime = [NSString stringWithFormat:@"%lld", watchTime];
    [VIDEO_HISTORY_DB addHistoryModel:model];
}

- (int64_t)localWatchTime
{
    if (!self.currentVideoId) {
        return 0;
    }
    NSString *userId = ACCOUNT_MANAGER.userId;
    AlivcPlayerVideoDBModel *model = [VIDEO_HISTORY_DB getHistoryModelFromVideoId:self.currentVideoId userId:userId];
    return model.watchTime.longLongValue;
}

- (void)startPip {
    NSLog(@"点击开启画中画功能");
    [self.pipController startPictureInPicture];
    if (self.pipController.pictureInPicturePossible) {
        NSLog(@"允许开启画中画功能");
        [self.pipController startPictureInPicture];
    } else {
        NSLog(@"不允许开启画中画功能");
    }
}

//#pragma mark - AVPictureInPictureControllerDelegate
//- (void)pictureInPictureControllerWillStartPictureInPicture:(AVPictureInPictureController *)pictureInPictureController {
//    NSLog(@"即将开启画中画功能");
//}
//
//- (void)pictureInPictureControllerDidStartPictureInPicture:(AVPictureInPictureController *)pictureInPictureController {
//    NSLog(@"已经开启画中画功能");
//}
//
//- (void)pictureInPictureControllerWillStopPictureInPicture:(AVPictureInPictureController *)pictureInPictureController {
//    NSLog(@"即将停止画中画功能");
//}
//
//- (void)pictureInPictureControllerDidStopPictureInPicture:(AVPictureInPictureController *)pictureInPictureController {
//    NSLog(@"已经停止画中画功能");
//}
//
//- (void)pictureInPictureController:(AVPictureInPictureController *)pictureInPictureController failedToStartPictureInPictureWithError:(NSError *)error {
//    NSLog(@"开启画中画功能失败，原因是%@", error);
//}

#pragma mark - AliPlayerPictureInPictureDelegate
/**
 @brief 画中画即将启动
 @param pictureInPictureController 画中画控制器
 */
- (void)pictureInPictureControllerWillStartPictureInPicture:(AVPictureInPictureController *)pictureInPictureController {
    if (!_pipController) {
        self.pipController = pictureInPictureController;
    }
    self.isPipPaused = !(self.currentPlayStatus == AVPStatusStarted);
    [pictureInPictureController invalidatePlaybackState];

    NSLog(@"点击开启画中画功能");
    [self.pipController startPictureInPicture];
    if (self.pipController.pictureInPicturePossible) {
        NSLog(@"允许开启画中画功能");
        [self.pipController startPictureInPicture];
    } else {
        NSLog(@"不允许开启画中画功能");
    }
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

    if (self.currentPosition <= self.duration) {
        double curPostion = self.currentPosition / 1000.0;
        double duration = self.duration / 1000.0;
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
    } else if (skipPosition > self.duration) {
        skipPosition = self.duration;
    }
    [self seekTo:skipPosition];
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
        if (self.currentPlayStatus == AVPStatusCompletion) {
            [self seekTo:0];
        }

        [self start];
        self.isPipPaused = NO;
    }
    [pictureInPictureController invalidatePlaybackState];
}

@end
