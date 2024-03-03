//
//  BaseCommentModel.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/25.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseCommentModel : NSObject

/** id */
@property (nonatomic, copy) NSString *commentId;

/** 创建时间 */
@property (nonatomic, copy) NSString *createTime;

/** 修改时间 */
@property (nonatomic, copy) NSString *updateTime;

/** 修改人*/
@property (nonatomic, strong) UserModel *updateUser;

/** 评论内容 */
@property (nonatomic, copy) NSString *content;

/** 评论人*/
@property (nonatomic, strong) UserModel *userFrom;

/** 是否点赞**/
@property (nonatomic, assign) BOOL voted;

/** 点赞数量 */
@property (assign, nonatomic) NSUInteger voteCount;

/**是否是作者回复**/
@property (nonatomic, assign) BOOL fromAuthor;

/** 是否精选**/
@property (nonatomic, assign) BOOL feature;

/** 是否置顶**/
@property (nonatomic, assign) BOOL top;

/** 父评论 */
@property (nonatomic, copy) NSString *parentId;

/** 回复数量 */
@property (assign, nonatomic) NSUInteger replyCount;

/** 内容是否已经展开*/
@property (nonatomic, assign) BOOL contentExpanded;

@end

NS_ASSUME_NONNULL_END
