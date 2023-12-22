//
//  LoginService.h
//  Fadvisor
//
//  Created by 韩建伟 on 2023/12/19.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginService : BaseRequest

/**根据手机验证码登录 */
- (void)loginBySms:(NSString *)phone code:(NSString *)code completion:(void (^)(NSString *errorMsg, NSDictionary *detailsDic))completion;

@end

NS_ASSUME_NONNULL_END
