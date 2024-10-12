//
//  UMengHelper.h
//  FingerAdvisor
//
//  Created by 韩建伟 on 2020/4/3.
//  Copyright © 2020 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMShare/UMShare.h>
#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN

@interface UMengHelper : NSObject
/*!
 * Common初始化
 */
+ (void)UMStart:(NSString *)appKey channel:(NSString *)channel;
/**
 初始化一键登录
 */
+ (void)UMVerifyStart;
/**
 初始化推送
 */
+ (void)UMPushStart:(NSDictionary *)launchOptions delegate:(id<UNUserNotificationCenterDelegate>)delegate;
/*!
 * 启动友盟统计功能
 */
+ (void)UMAnalyticStart;
/**
 初始化第三方登录和分享
 */
+ (void)UMSocialStart:(NSString *)qqAppKey wechatAppKey:(NSString *)wechatAppKey wechatAppSecret:(NSString *)wechatAppSecret weiboAppKey:(NSString *)weiboAppKey weiboAppSecret:(NSString *)weiboAppSecret weiboCallback:(NSString *)weiboCallback;

#pragma mark - UM推送
+ (void)getTags:(void (^)(NSSet *responseTags))completion;
+ (void)addTags:(NSString *)tagString;
+ (void)deleteTags:(NSString *)tagString;

//分享链接
+ (void)shareLinkToPlatform:(UMSocialPlatformType)platformType title:(NSString *)title introduction:(NSString *)introduction thumbURL:(NSString *)thumbURL shareURL:(NSString *)shareURL;
//分享文本
+ (void)shareTextToPlatform:(UMSocialPlatformType)platformType text:(NSString *)text;
//分享图片
+ (void)shareImageToPlatform:(UMSocialPlatformType)platformType imageURL:(NSString *)imageURL;
//分享音乐
+ (void)shareMusicToPlatform:(UMSocialPlatformType)platformType title:(NSString *)title introduction:(NSString *)introduction musicURL:(NSString *)musicURL;
//分享视频
+ (void)shareVideoToPlatform:(UMSocialPlatformType)platformType title:(NSString *)title introduction:(NSString *)introduction videoURL:(NSString *)videoURL;

#pragma mark - UM第三方登录
+ (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType completion:(void (^)(UMSocialUserInfoResponse *result, NSError *error))completion;

#pragma mark - UM统计
/// 在viewWillAppear调用,才能够获取正确的页面访问路径、访问深度（PV）的数据
+ (void)beginLogPageView:(__unsafe_unretained Class)pageView;

/// 在viewDidDisappeary调用，才能够获取正确的页面访问路径、访问深度（PV）的数据
+ (void)endLogPageView:(__unsafe_unretained Class)pageView;
/*!
 * 自定义名称
 */
/// 在viewWillAppear调用,才能够获取正确的页面访问路径、访问深度（PV）的数据
+ (void)beginLogPageViewName:(NSString *)pageViewName;

/// 在viewDidDisappeary调用，才能够获取正确的页面访问路径、访问深度（PV）的数据
+ (void)endLogPageViewName:(NSString *)pageViewName;
@end

NS_ASSUME_NONNULL_END
