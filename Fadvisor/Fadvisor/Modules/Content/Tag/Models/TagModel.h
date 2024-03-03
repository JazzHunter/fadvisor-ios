//
//  Tag.h
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TagModel : NSObject

/** id */
@property (nonatomic, copy) NSString *tagId;

/** 修改时间 */
@property (nonatomic, copy) NSString *updateTime;

/** 名称 */
@property (nonatomic, copy) NSString *name;

/** 介绍 */
@property (nonatomic, copy) NSString *introduction;

/** 正文节选 */
@property (nonatomic, copy) NSString *contentText;

/** 全称 */
@property (nonatomic, copy) NSString *fullName;

/** 封面图 */
@property (nonatomic, strong) NSURL *coverUrl;

/**图标图 */
@property (nonatomic, strong) NSURL *iconUrl;

/** 标签订阅用户数量 */
@property (assign, nonatomic) NSUInteger subscriberCount;

/** 内容数量 */
@property (assign, nonatomic) NSUInteger itemCount;

/** 是否订阅 */
@property (nonatomic, assign) BOOL subscribed;

/** 动作时间 */
@property (nonatomic, copy) NSString *actionTime;

/**子标签数组*/
@property (nonatomic, strong) NSMutableArray<TagModel *> *children;

@end

NS_ASSUME_NONNULL_END
