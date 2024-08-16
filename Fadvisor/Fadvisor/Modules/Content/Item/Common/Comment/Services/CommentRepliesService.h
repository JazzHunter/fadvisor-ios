//
//  CommentRepliesServices.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/3/4.
//

#import "BaseRequest.h"
#import "CommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentRepliesService : BaseRequest

/** comment 数组*/
@property (nonatomic, strong) NSMutableArray<CommentModel *> *replies;

/** 是否没有更多内容 */
@property (nonatomic, assign) BOOL noMore;

/** 总数 */
@property (assign, nonatomic) NSUInteger total;

/** 获取回复内容 */
- (void)getReplies:(BOOL)isFromBottom completion:(void (^)(NSString *errorMsg, BOOL isHaveNewData))completion;

/** 重置 */
- (void)reset;

- (void)resetWithMasterComment:(CommentModel *)masterComment;

@end

NS_ASSUME_NONNULL_END
