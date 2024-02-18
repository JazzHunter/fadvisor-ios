//
//  VideoDetailsPlayerView.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/1/17.
//

#import "VideoDetailsModel.h"
#import "ItemModel.h"
#import "VideoDetailsModel.h"
#import <MyLayout/MyLayout.h>

NS_ASSUME_NONNULL_BEGIN

@class VideoDetailsPlayerView;

@protocol VideoDetailsPlayerViewProtocol <NSObject>
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
- (void)onFinishWithPlayerView:(VideoDetailsPlayerView *)playerView;

@end

@interface VideoDetailsPlayerView : MyRelativeLayout;

@property (nonatomic, weak) id<VideoDetailsPlayerViewProtocol> delegate; //代理

@property (nonatomic, assign) BOOL isScreenLocked;
@property (nonatomic, assign) BOOL isPreviewMode; //当前播放视频的清晰度信息

@property (assign, nonatomic) CGRect defaultFrame;

// 设置垂直 / 水平布局
- (void)resetLayout:(BOOL)isPortrait;


- (void)startNewPlayWithItem:(ItemModel *)itemModel details:(VideoDetailsModel *)detailsModel;

@end

NS_ASSUME_NONNULL_END
