//
//  MediaModel.h
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MediaModel : NSObject

/** id，与阿里云一致*/
@property (nonatomic, copy) NSString *videoId;

/** 文件名*/
@property (nonatomic, copy) NSString *filename;

/** coverUrl*/
@property (nonatomic, strong) NSURL *coverUrl;

/** 媒体文件时长*/
@property (assign, nonatomic) NSTimeInterval duration;

/**  大小*/
@property (assign, nonatomic) NSUInteger size;

/**  截图*/
@property (nonatomic, copy) NSString *snapshots;

/**  宽度*/
@property (assign, nonatomic) NSUInteger width;

/**  高度*/
@property (assign, nonatomic) NSUInteger height;

@end

NS_ASSUME_NONNULL_END
