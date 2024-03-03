//
//  UserModel.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : NSObject

/** id */
@property (nonatomic, copy) NSString *userId;

/** 昵称 */
@property (nonatomic, copy) NSString *nickname;

/** 头像 */
@property (nonatomic, strong) NSURL *avatar;

/** 简介 */
@property (nonatomic, copy) NSString *introduction;

/** 背景图 */
@property (nonatomic, strong) NSURL *bgUrl;

/** 邮箱 */
@property (nonatomic, copy) NSString *email;

/** 手机号 */
@property (nonatomic, copy) NSString *phone;

/** 账户状态 */
@property (nonatomic, copy) NSString *status;

/** 用户名 */
@property (nonatomic, copy) NSString *username;

/** 内部员工 */
@property (nonatomic, assign) BOOL internal;

/** 上次登陆时间 */
@property (nonatomic, copy) NSString *lastLoginTime;

/** 上次登陆位置 */
@property (nonatomic, copy) NSString *lastLoginRegion;

/** 上次登陆客户端 */
@property (nonatomic, copy) NSString *lastLoginClient;

/** 创建 */
@property (nonatomic, copy) NSString *createTime;

/** 用户激活时间 */
@property (nonatomic, copy) NSString *activeTime;

@end

NS_ASSUME_NONNULL_END
