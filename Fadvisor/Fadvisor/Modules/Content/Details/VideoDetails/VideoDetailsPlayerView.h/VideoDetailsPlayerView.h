//
//  VideoDetailsPlayerView.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/1/17.
//

#import "VideoDetailsModel.h"

NS_ASSUME_NONNULL_BEGIN

@class VideoDetailsPlayerView;

@protocol VideoDetailsPlayerView <NSObject>
// ----------------------界面-----------------------------------------------
/**
 * 功能：返回按钮事件
 * 参数：playerView ：VideoDetailsPlayerView
 */
- (void)onBackViewClickWithPlayerView:(VideoDetailsPlayerView *)playerView;

/**
 * 功能：下载按钮事件
 * 参数：playerView ：VideoDetailsPlayerView
 */
- (void)onDownloadButtonClickWithPlayerView:(VideoDetailsPlayerView *)playerView;

/**
 * 功能：播放完成事件 ，请区别stop（停止播放）
 * 参数：playerView ： VideoDetailsPlayerView
 */
- (void)onFinishWithdPlayerView:(VideoDetailsPlayerView *)playerView;

@end

@interface VideoDetailsPlayerView : UIView

@property (nonatomic, weak) id<VideoDetailsPlayerView> delegate; //代理

@property (nonatomic, assign) BOOL isScreenLocked;
@property (nonatomic, assign) BOOL fixedPortrait;

@property (nonatomic, assign) BOOL waterMark; // 水印
@property (nonatomic, assign) BOOL isLoopView; // 是否展示loopView

@property (nonatomic, assign) BOOL isPreviewMode; // 是否预览模式
@property (nonatomic, assign) NSUInteger previewTime; // 预览时间

/**
 * 功能：根据 URL 播放视频
 */
- (void)playViewPrepareWithURL:(NSURL *)url isLocal:(BOOL)isLocal;

/**
 * 功能：当前播放视频的打点信息。
 */
@property (nonatomic, strong)NSArray *dotsArray;

@end

NS_ASSUME_NONNULL_END
