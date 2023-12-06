//
//  RcmdItems.h
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/16.
//

#import "BaseRequest.h"
#import "ItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RcmdItemsServcie : BaseRequest

/** 推荐 Item 数组 */
@property (nonatomic, strong) NSMutableArray<ItemModel *> *rcmdItems;

/** 是否没有更多内容 */
@property (nonatomic, assign) BOOL noMore;

/** 总数 */
@property (assign, nonatomic) NSUInteger total;

/** 获取推荐内容 */
- (void)getHomeRcmdItems:(BOOL)isFromBottom completion:(void (^)(NSString *errorMsg, BOOL isHaveNewData))completion;

/** 重置 */
- (void)reset;

@end

NS_ASSUME_NONNULL_END
