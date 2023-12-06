//
//  ArticleDetailsService.h
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/26.
//

#import "ItemDetailsResultModel.h"
#import "ArticleDetailsModel.h"
#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface ItemDetailsService : BaseRequest

/**Result 结果 */
@property (nonatomic, strong) ItemDetailsResultModel *result;

/**获取相关 Details 信息 */
- (void)getDetails:(NSUInteger)itemType itemId:(NSString *)itemId completion:(void (^)(NSString *errorMsg, NSDictionary *detailsDic))completion;

@end

NS_ASSUME_NONNULL_END
