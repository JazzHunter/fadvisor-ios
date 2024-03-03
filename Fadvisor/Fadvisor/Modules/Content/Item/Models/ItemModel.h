//
//  Item.h
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/18.
//

#import <Foundation/Foundation.h>
#import "AuthorModel.h"
#import "TagModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ItemModel : NSObject

/** id */
@property (nonatomic, copy) NSString *itemId;

/** item类型 */
@property (assign, nonatomic) NSUInteger itemType;

/** 发布时间 */
@property (nonatomic, copy) NSString *pubTime;

/** 动作时间 */
@property (nonatomic, copy) NSString *actionTime;

/** 修改时间 */
@property (nonatomic, copy) NSString *updateTime;

/** 点赞数量 */
@property (assign, nonatomic) NSUInteger voteCount;

/** 查看数量 */
@property (assign, nonatomic) NSUInteger viewCount;

/** 收藏数量 */
@property (assign, nonatomic) NSUInteger favCount;

/** 评论数量 */
@property (assign, nonatomic) NSUInteger commentCount;

/** 状态 */
@property (nonatomic, copy) NSString *status;

/** 标题 */
@property (nonatomic, copy) NSString *title;

/** 简介 */
@property (nonatomic, copy) NSString *introduction;

/** 封面图地址 */
@property (nonatomic, strong) NSURL *coverUrl;

/** 背景图地址 */
@property (nonatomic, strong) NSURL *bgUrl;

/** 是否点赞 */
@property (nonatomic, assign) BOOL voted;

/** 是否收藏 */
@property (nonatomic, assign) BOOL faved;

/** 是否精选 */
@property (nonatomic, assign) BOOL featured;

/** 正文节选 */
@property (nonatomic, copy) NSString *contentText;

/** 作者列表 */
@property (nonatomic, strong) NSMutableArray<AuthorModel *> *authors;

/** 主要容器 */
@property (nonatomic, strong) ItemModel *primaryColl;

/** 发布模式 */
@property (nonatomic, assign) NSString *pubMode;

/** 访问模式 */
@property (nonatomic, assign) NSString *accessType;

/** 评论模式*/
@property (nonatomic, copy) NSString *commentMode;

/** 文章字数*/
@property (assign, nonatomic) NSUInteger totalWords;

/** 阅读时间*/
@property (assign, nonatomic) NSUInteger readingTime;

/** 媒体文件时长*/
@property (assign, nonatomic) NSTimeInterval duration;

/**是否订阅**/
@property (nonatomic, assign) BOOL subscribed;

/** 订阅数量 */
@property (assign, nonatomic) NSUInteger subscriberCount;

/** 内容数量 */
@property (assign, nonatomic) NSUInteger itemCount;

/** 子项 */
@property (nonatomic, strong) NSMutableArray<ItemModel *> *items;

/** 该Item所属的关注的作者列表 */
@property (nonatomic, strong) NSMutableArray<AuthorModel *> *followedAuthorList;

/** 该Item所属的订阅的合集的列表 */
@property (nonatomic, strong) NSMutableArray<ItemModel *> *subscribedCollList;

/**该Item所属的订阅的Tag的列表 */
@property (nonatomic, strong) NSMutableArray<TagModel *> *subscribedTagList;

// 文件部分
/** 文件大小*/
@property (assign, nonatomic) NSInteger size;

/** 页数*/
@property (assign, nonatomic) NSInteger pageSize;

/** 格式 */
@property (nonatomic, copy) NSString *fmt;

/** 文档格式类型 */
@property (nonatomic, copy) NSString *formatType;

/** 下载次数 */
@property (assign, nonatomic) NSInteger downloadCount;

/** 同后台的 VideoId */
@property (nonatomic, copy) NSString *mediaId;

/** 媒体文件的 uuid */
@property (nonatomic, strong) NSUUID *uuid;

@end

NS_ASSUME_NONNULL_END
