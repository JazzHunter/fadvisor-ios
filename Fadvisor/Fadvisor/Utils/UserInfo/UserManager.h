//
//  UserManager.h
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserManager : NSObject

+ (instancetype)sharedManager;

/** 是否登录了 */
@property (assign, nonatomic) BOOL isLogin;

/** token */
@property (nonatomic, copy) NSString *token;

/** 昵称 */
@property (nonatomic, copy) NSString *userId;

/** 用户名 */
@property (nonatomic, copy) NSString *username;

/**是否内部**/
@property (nonatomic, assign) BOOL internal;

@end

NS_ASSUME_NONNULL_END
