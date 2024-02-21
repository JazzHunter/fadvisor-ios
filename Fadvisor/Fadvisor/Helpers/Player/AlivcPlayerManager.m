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

@interface AlivcPlayerManager ()<AVPDelegate>

@property (nonatomic, assign) BOOL isEnterBackground;
@property (nonatomic, assign) AVPEventType playerEventType;
@property (nonatomic, strong) AlivcPlayerVidPlayAuthService *playAuthService;

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
    _player.stsPreloadDefinition = @"SD";//720p
    [_player setMaxAccurateSeekDelta:30];

    AVPConfig *config = [[AVPConfig alloc] init];
    config.clearShowWhenStop = YES;
    [_player setConfig:config];
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
        [self.player seekToTime:seekTime seekMode:AVP_SEEKMODE_ACCURATE];
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

- (void)reset {
    [self.player reset];
    NSLog(@"播放器reset");
}

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
    
    if (eventType == AVPEventCompletion) {
        [self saveToLocal:self.currentVideoId];
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

    if (self.delegate && [self.delegate respondsToSelector:@selector(onPlayerStatusChanged:oldStatus:newStatus:)]) {
        [self.delegate onPlayerStatusChanged:self.player oldStatus:oldStatus newStatus:newStatus];
    }
}

- (void)onGetThumbnailSuc:(int64_t)positionMs fromPos:(int64_t)fromPos toPos:(int64_t)toPos image:(id)image {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onGetThumbnailSuc:fromPos:toPos:image:)]) {
        [self.delegate onGetThumbnailSuc:positionMs fromPos:fromPos toPos:toPos image:image];
    }
}

/**
 @brief 获取缩略图失败回调
 @param positionMs 指定的缩略图位置
 */
- (void)onGetThumbnailFailed:(int64_t)positionMs {
    NSLog(@"缩略图获取失败");
}

- (void)onCaptureScreen:(AliPlayer *)player image:(AVPImage *)image {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onCaptureScreen:image:)]) {
        [self.delegate onCaptureScreen:self.player image:image];
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
        if (self.playerEventType != AVPEventCompletion) {
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

- (void)enablePictureInPictureWithDelegate:(id<AliPlayerPictureInPictureDelegate>)pictureInPictureDelegate{
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

    NSString *userId = [AccountManager sharedManager].userId;
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
    NSString *userId = [AccountManager sharedManager].userId;
    AlivcPlayerVideoDBModel *model = [VIDEO_HISTORY_DB getHistoryModelFromVideoId:self.currentVideoId userId:userId];
    return model.watchTime.longLongValue;
}

@end
