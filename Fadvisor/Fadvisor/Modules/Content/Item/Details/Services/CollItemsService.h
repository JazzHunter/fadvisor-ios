//
//  CollItemsService.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/8/15.
//

#import "BaseRequest.h"
#import "ItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CollItemsService : BaseRequest

/** comment 数组*/
@property (nonatomic, strong) NSMutableArray<ItemModel *> *items;

/** 是否没有更多内容 */
@property (nonatomic, assign) BOOL noMore;

/** 总数 */
@property (assign, nonatomic) NSUInteger total;

/** 获取子项 */
- (void)getItems:(void (^)(NSString *errorMsg, BOOL isHaveNewData))completion;

/** 重置 */
- (void)reset;

/** 初始化*/
- (void)resetWithCollection:(ItemModel *)collection;

@end

NS_ASSUME_NONNULL_END
