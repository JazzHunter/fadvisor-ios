//
//  AlivcPlayerManager.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/1/16.
//

#import <AliyunPlayer/AliyunPlayer.h>
#import "AlivcPlayerDefine.h"

#define PLAYER_MANAGER [AlivcPlayerManager manager]

NS_ASSUME_NONNULL_BEGIN

@protocol AlivcPlayerProtocal <NSObject>

@optional
/**
 @brief 播放器事件回调
 @param player 播放器player指针
 @param eventType 播放器事件类型
 @see AVPEventType
 */
- (void)onPlayerEvent:(AliPlayer *)player eventType:(AVPEventType)eventType;

/**
 @brief 播放器事件回调
 @param player 播放器player指针
 @param eventWithString 播放器事件类型
 @param description 播放器事件说明
 @see AVPEventType
 */
- (void)onPlayerEvent:(AliPlayer *)player eventWithString:(AVPEventWithString)eventWithString description:(NSString *)description;

/**
 @brief 错误代理回调
 @param player 播放器player指针
 @param errorModel 播放器错误描述，参考AVPErrorModel
 @see AVPErrorModel
 */
- (void)onError:(AliPlayer *)player errorModel:(AVPErrorModel *)errorModel;

/**
 @brief 视频当前播放位置回调
 @param player 播放器player指针
 @param position 视频当前播放位置
 */
- (void)onCurrentPositionUpdate:(AliPlayer *)player position:(int64_t)position;

/**
 @brief 视频缓存位置回调
 @param player 播放器player指针
 @param position 视频当前缓存位置
 */
- (void)onBufferedPositionUpdate:(AliPlayer *)player position:(int64_t)position;

/**
 @brief 获取track信息回调
 @param player 播放器player指针
 @param info track流信息数组
 @see AVPTrackInfo
 */
- (void)onTrackReady:(AliPlayer *)player info:(NSArray<AVPTrackInfo *> *)info;

/**
 @brief track切换完成回调
 @param player 播放器player指针
 @param info 切换后的信息 参考AVPTrackInfo
 @see AVPTrackInfo
 */
- (void)onTrackChanged:(AliPlayer *)player info:(AVPTrackInfo *)info;

/**
 @brief 字幕显示回调
 @param player 播放器player指针
 @param trackIndex 字幕流索引.
 @param subtitleID  字幕ID.
 @param subtitle 字幕显示的字符串
 */
- (void)onSubtitleShow:(AliPlayer *)player trackIndex:(int)trackIndex subtitleID:(long)subtitleID subtitle:(NSString *)subtitle;

/**
 @brief 播放器状态改变回调
 @param player 播放器player指针
 @param oldStatus 老的播放器状态 参考AVPStatus
 @param newStatus 新的播放器状态 参考AVPStatus
 @see AVPStatus
 */
- (void)onPlayerStatusChanged:(AliPlayer *)player oldStatus:(AVPStatus)oldStatus newStatus:(AVPStatus)newStatus;

/**
 @brief 获取缩略图成功回调
 @param positionMs 指定的缩略图位置
 @param fromPos 此缩略图的开始位置
 @param toPos 此缩略图的结束位置
 @param image 缩图略图像指针,对于mac是NSImage，iOS平台是UIImage指针
 */
- (void)onGetThumbnailSuc:(int64_t)positionMs fromPos:(int64_t)fromPos toPos:(int64_t)toPos image:(id)image;

/**
 @brief 获取截图回调
 @param player 播放器player指针
 @param image 图像
 @see AVPImage
 */
- (void)onCaptureScreen:(AliPlayer *)player image:(AVPImage *)image;

@end

@interface AlivcPlayerManager : NSObject

+ (instancetype)manager;

@property (nonatomic, weak) id<AlivcPlayerProtocal> delegate; //代理
@property (nonatomic, strong) AliListPlayer *player;
@property (nonatomic, copy) NSString *currentVideoId;
@property (nonatomic, assign) AVPStatus currentPlayStatus;
@property (nonatomic, assign) AVPSeekMode seekMode;
@property (nonatomic, assign) AlivcPlayMethod playMethod;
@property (nonatomic, readonly) int64_t duration;
/**
 @brief 播放器暂停
 */
- (void)pause;

/**
 @brief 播放器播放
 */
- (void)start;

/**
 @brief 播放器跳转时间
 @param seekTime 时间
 */
- (void)seekTo:(NSTimeInterval)seekTime;

/**
 @brief 播放器停止
 */
- (void)stop;

/**
 @brief 播放器reload
 */
- (void)reload;

/**
 @brief 播放器重新播放
 */
- (void)replay;

/**
 @brief 播放器 reset
 */
- (void)reset;

/**
 @brief 播放器的 playerView
 */
- (void)setPlayerView:(UIView *)playerView;

/**
 @brief 播放器截图
 */
- (void)snapShot;

/**
 @brief PlayAuth 播放
 */
- (void)startPlayWithVidAuth:(NSString *)vid errorBlock:(void (^)(NSString *errorMsg))errorBlock;

- (void)startPlayWithVidAuth:(NSString *)vid errorBlock:(void (^)(NSString *errorMsg))errorBlock previewTime:(int)previewTime;

/**
 @brief 当前 Vid 的时间
 */
- (int64_t)localWatchTime;
/**
 @brief Url 播放
 */
- (void)startPlayWithUrl:(NSURL *)url;

/**
 @brief 获取信息
 */
- (AVPMediaInfo *)getMediaInfo;

/**
 @brief 获取指定位置的缩略图
 @param positionMs 代表在哪个指定位置的缩略图
 */
- (void)getThumbnail:(int64_t)positionMs;

@property (nonatomic) float rate;

@property (nonatomic, assign) float volume;

/**
 @brief 开启画中画 ，同时设置画中画代理代理
 @param pictureInPictureDelegate 画中画代理
 */
- (void)enablePictureInPictureWithDelegate:(id<AliPlayerPictureInPictureDelegate>)pictureInPictureDelegate;

/**
 @brief 关闭画中画
 */
- (void)disablePictureInPicture;

@end

NS_ASSUME_NONNULL_END
