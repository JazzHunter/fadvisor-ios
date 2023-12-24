//
//  AlivcPlayerListPlayerProtocol.h
//  Fadvisor
//
//  Created by 韩建伟 on 2023/12/22.
//

@protocol AlivcPlayerListPlayerProtocol <NSObject>

/**
 @brief 将播放源添加进播放列表 uid播放的唯一标识 uuid
 */
- (void)addVidSource:(NSString *)vid uuid:(NSString *)uuid;

/**
 @brief 从播放列表移除
 */
- (void)removeSource:(NSString*)uuid;

/**
 @brief 清空全部播放列表
 */
- (void)clear;

/**
 @brief 当前播放的uuid
 */
- (NSString *)currentUuid;

- (BOOL)containVideoId:(NSString *)videoId uuid:(NSString *)uuid;


/**
 播放指定的uuid
 */
- (void)moveToVideoId:(NSString *)videoId uuid:(NSString *)uuid;


- (void)playNext;

- (void)playPre;

- (BOOL)canPlayNext;

- (BOOL)canPlayPre;

- (void)forceRePlaymoveToVideoId:(NSString *)videoId uuid:(NSString *)uuid;


@end

