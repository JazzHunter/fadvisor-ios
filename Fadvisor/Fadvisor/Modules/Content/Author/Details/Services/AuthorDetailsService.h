//
//  AuthorDetailsService.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/7/2.
//

#import <Foundation/Foundation.h>
#import "AuthorDetailsResultModel.h"
#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface AuthorDetailsService : BaseRequest

/**Result 结果 */
@property (nonatomic, strong) AuthorDetailsResultModel *result;

/**获取相关 Details 信息 */
- (void)getDetails:(NSString *)authorId completion:(void (^)(NSString *errorMsg, NSDictionary *detailsDic))completion;

@end

NS_ASSUME_NONNULL_END
