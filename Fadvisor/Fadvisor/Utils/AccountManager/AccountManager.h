//
//  AccountManager.h
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/18.
//

#import <Foundation/Foundation.h>
#import "UserProfileModel.h"

#define ACCOUNT_MANAGER [AccountManager sharedManager]

NS_ASSUME_NONNULL_BEGIN

@interface AccountManager : NSObject

+ (instancetype)sharedManager;

/** 是否登录了 */
@property (assign, nonatomic) BOOL isLogin;

/** token */
@property (nonatomic, copy) NSString *token;

/** token */
@property (nonatomic, copy) NSString *refreshToken;

/** 昵称 */
@property (nonatomic, copy) NSString *userId;

/** 用户名 */
@property (nonatomic, copy) NSString *username;

/**是否内部**/
@property (nonatomic, assign) BOOL isInternal;

/** Profile */
@property (nonatomic, strong) UserProfileModel *profile;

@end

NS_ASSUME_NONNULL_END
