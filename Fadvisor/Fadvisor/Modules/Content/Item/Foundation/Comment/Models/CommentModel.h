//
//  CommentModel.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/25.
//

#import <Foundation/Foundation.h>
#import "ItemModel.h"
#import "UserModel.h"

@interface CommentModel : NSObject

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

/** 被评论人*/
@property (nonatomic, strong) UserModel *userTo;

/** 被回复的Comment */
@property (nonatomic, strong) CommentModel *repliedComment;

/** 被回复的Comment */
@property (nonatomic, strong) ItemModel *item;

/** 回复列表 */
@property (nonatomic, strong) NSMutableArray<CommentModel *> *replies;

/** 内容是否已经展开*/
@property (nonatomic, assign) BOOL contentExpanded;

@end
