//
//  WebContentFileManager.h
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/24.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ContentImageLoadState) {
    /** 内容图片加载状态 初始 */
    ContentImageLoadStateInitial = 0,
    /** 内容图片加载状态 加载中 */
    ContentImageLoadStateLoading = 1,
    /** 内容图片加载状态 点击加载 */
    ContentImageLoadStateClick   = 2,
    /** 内容图片加载状态 加载失败 */
    ContentImageLoadStateFailure = 3,
    /** 内容图片加载状态 加载完成*/
    ContentImageLoadStateFinish  = 4,
    /** 内容图片加载状态 Gif*/
    ContentImageLoadStateGif     = 5,
};

typedef NS_ENUM(NSInteger, ContentImageLoadMode) {
    
    /** 内容图片加载状态 全部加载 */
    ContentImageLoadModeAll    = 0 ,
    /** 内容图片加载模式 滑动加载 */
    ContentImageLoadModeScroll    = 1,
};


NS_ASSUME_NONNULL_BEGIN

@interface WebContentFileManager : NSObject

/**
 初始化数据
 */
+ (void)initData;

/**
 获取TEMP缓存目录

 @return 缓存路径
 */
+ (NSString *)getCachePath:(nullable NSString *)folder;

+ (NSString *)getCachePath;

/**
 获取TEMP缓存目录下指定文件夹的路径

 @param folder 文件夹名
 @return 缓存路径
 */
+ (NSString *)getStaticCachePath:(NSString *)folder;

/**
 清理缓存

 @param resultBlock 结果回调Block
 */
+ (void)clearCacheWithResultBlock:(void (^)(void))resultBlock;


/** 内容缩放 */

+ (NSInteger)contentZoom;

+ (void)setContentZoom:(NSInteger)contentZoom;

@end

NS_ASSUME_NONNULL_END
