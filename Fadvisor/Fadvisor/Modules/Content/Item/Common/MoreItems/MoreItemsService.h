//
//  MoreItemsService.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/8/14.
//

#import "BaseRequest.h"
#import "ItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MoreItemsService : BaseRequest

/** 更多的 Item 数组 */
@property (nonatomic, strong) NSArray<ItemModel *> *moreItems;

/** 获取推荐作者 */
- (void)getMoreItems:(NSUInteger)itemType itemId:(NSString *)itemId completion:(void (^)(NSString *errorMsg))completion;

@end

NS_ASSUME_NONNULL_END
