//
//  CommentsService.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/29.
//

#import "BaseRequest.h"
#import "CommentModel.h"

#define COMMENTS_ORDER_TYPE_SET @"set"
#define COMMENTS_ORDER_TYPE_TIME @"time"

#define COMMENT_MODE_FEATURE @"1"
#define COMMENT_MODE_FREE @"2"
#define COMMENT_MODE_NONE @"3"

NS_ASSUME_NONNULL_BEGIN

@interface CommentsService : BaseRequest

/** 初始化*/
- (void)resetWithItemType:(NSUInteger)itemType itemId:(NSString *)itemId commentMode:(NSString *)commentMode;

/** comment 数组*/
@property (nonatomic, strong) NSMutableArray<CommentModel *> *comments;

/** 是否没有更多内容 */
@property (nonatomic, assign) BOOL noMore;

/** 总数 */
@property (assign, nonatomic) NSUInteger total;

/** Set 或者 Info */
@property (nonatomic, copy) NSString *orderType;

/** 获取推荐内容 */
- (void)getComments:(BOOL)isFromBottom completion:(void (^)(NSString *errorMsg, BOOL isHaveNewData))completion;

/** 重置 */
- (void)reset;


@end

NS_ASSUME_NONNULL_END
