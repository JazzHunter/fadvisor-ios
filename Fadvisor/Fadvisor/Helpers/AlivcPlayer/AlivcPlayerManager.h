//
//  AlivcPlayerManager.h
//  Fadvisor
//
//  Created by 韩建伟 on 2023/12/22.
//

#import <Foundation/Foundation.h>

#import "AlivcPlayerEventCenterProtocol.h"
#import "AlivcPlayerPlayerProtocol.h"
#import "AlivcPlayerListPlayerProtocol.h"
#import "AlivcPlayerPluginManagerProtocol.h"
#import "AUIPlayerPlayViewLayerManagerProtocol.h"
#import "AlivcPlayerVideoHistoryProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface AlivcPlayerManager : NSObject<AlivcPlayerPlayerProtocol, AlivcPlayerListPlayerProtocol, AlivcPlayerPluginManagerProtocol, AUIPlayerPlayViewLayerManagerProtocol, AlivcPlayerEventCenterProtocol, AlivcPlayerVideoHistoryProtocol>

//设备方向
@property (nonatomic, assign) AlivcPlayerEventCenterTypeOrientation currentOrientation;

//是否锁定
@property (nonatomic, assign) BOOL lock;

//是否隐藏工具栏
@property (nonatomic, assign) BOOL controlToolHidden;

//自动选择清晰度
@property (nonatomic, assign) BOOL autoTrack;

//列表视频是否自动播放下一个
@property (nonatomic, assign) BOOL autoPlayInList;

//是否支持后台播放
@property (nonatomic, assign) BOOL backgroudModeEnabled;

//当前场景
@property (nonatomic, assign) ApPlayerScene playScene;

//推荐id
@property (nonatomic, assign) int64_t recomendVodId;

@property (nonatomic, copy) NSArray<NSDictionary<NSString *, NSString *> *> *playerSourceList;//可上下切换的播放列表

//当前Track是否有缩略图，如果没有，不展示缩略图
@property (nonatomic, assign) BOOL trackHasThumbnai;

@property (nonatomic, assign) BOOL shouldFlowOrientation;

@property (nonatomic, assign) BOOL hideAutoOrientation;

@property (nonatomic, assign) BOOL isListening;

@property (nonatomic, assign) AlivcPlayerPageEventFrom pageEventFrom;
@property (nonatomic, assign) AlivcPlayerPageEventJump pageEventJump;

+ (instancetype)manager;
- (void)destroyIncludePlayer:(BOOL)destroyPlayer;

- (void)setCurrentOrientationForceDisPatch:(AlivcPlayerEventCenterTypeOrientation)currentOrientation;

- (BOOL)isHideSpeedTip;
- (void)hideSpeedTip;
- (BOOL)isHideFullScreenSpeedTip;
- (void)hideFullScreenSpeedTip;
- (BOOL)isHideFirstLandsacpeSpeedTip;
- (void)hideFirstLandsacpeSpeedTip;

@end

NS_ASSUME_NONNULL_END
