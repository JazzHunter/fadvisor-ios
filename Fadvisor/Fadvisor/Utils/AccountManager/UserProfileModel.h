//
//  UserProfile.h
//  Fadvisor
//
//  Created by 韩建伟 on 2023/12/19.
//

#import <Foundation/Foundation.h>
#import "UserEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserProfileModel : NSObject

/** id */
@property (nonatomic, copy) NSString *userId;

/** 用户名 */
@property (nonatomic, copy) NSString *nickname;

/** 头像 */
@property (nonatomic, strong) NSURL *avatar;

/** 简介 */
@property (nonatomic, copy) NSString *introduction;

/** 背景图 */
@property (nonatomic, strong) NSURL *bgUrl;

/** 邮箱 */
@property (nonatomic, copy) NSString *email;

/** 状态 */
@property (nonatomic, assign) UserStatus *status;

/** ⚠️上次登陆时间 */
@property (assign, nonatomic) NSTimeInterval *lastLoginTime;

/** 上次登陆位置 */
@property (nonatomic, copy) NSString *lastLoginRegion;

/** ⚠️上次登陆客户端 */
@property (nonatomic, copy) NSString *lastLoginClient;

/** ⚠️创建时间 */
@property (assign, nonatomic) NSTimeInterval *createTime;

/** 微信unionId */
@property (nonatomic, copy) NSString *wxUnionid;

/** 微信头像 */
@property (nonatomic, strong) NSURL *wxAvatar;

/** 微信昵称 */
@property (nonatomic, copy) NSString *wxNickname;

/** 微信小程序openid */
@property (nonatomic, copy) NSString *miniOpenid;

/** QQ openid */
@property (nonatomic, copy) NSString *qqOpenid;

/** QQ头像 */
@property (nonatomic, strong) NSURL *qqAvatar;

/** QQ昵称 */
@property (nonatomic, copy) NSString *qqNickname;

/** Weibo openid */
@property (nonatomic, copy) NSString *wbOpenid;

/** 微博头像 */
@property (nonatomic, strong) NSURL *wbAvatar;

/** 微博昵称 */
@property (nonatomic, copy) NSString *wbNickname;

/** 腾讯的unionid */
@property (nonatomic, copy) NSString *unionid;

/** 姓名 */
@property (nonatomic, copy) NSString *name;

/** 组织 */
@property (nonatomic, copy) NSString *organization;

/** 职位 */
@property (nonatomic, copy) NSString *title;

/** 职位 */
@property (assign, nonatomic) BOOL hasPassword;

@end

NS_ASSUME_NONNULL_END
