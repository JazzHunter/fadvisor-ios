//
//  LoginService.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/10/14.
//


NS_ASSUME_NONNULL_BEGIN

@interface LoginService : NSObject

/**
 发送手机验证码
 */
- (void)sendLoginPhoneSms:(NSString *)phone completion:(void (^)(NSString *errorMsg))completion;

/**
 验证码登录
 */
- (void)loginBySms:(NSString *)phone code:(NSString *)code completion:(void (^)(NSString *errorMsg))completion;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
