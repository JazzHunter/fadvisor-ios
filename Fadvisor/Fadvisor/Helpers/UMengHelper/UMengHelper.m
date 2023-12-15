//
//  UMengHelper.m
//  FingerAdvisor
//
//  Created by 韩建伟 on 2020/4/3.
//  Copyright © 2020 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//

#import "UMengHelper.h"
#import <UMCommon/UMCommon.h>
#import <UMCommonLog/UMCommonLogHeaders.h>
#import <UMPush/UMessage.h>
#import <UMCommon/MobClick.h>
#import "NotificationView.h"

@implementation UMengHelper

+ (void)UMStart:(NSString *)appKey channel:(NSString *)channel {
    #ifdef DEBUG
    /** 设置是否在console输出sdk的log信息.
    @param bFlag 默认NO(不输出log); 设置为YES, 输出可供调试参考的log信息. 发布产品时必须设置为NO.*/
    [UMConfigure setLogEnabled:YES];//设置打开日志
    //开发者需要显式的调用此函数，日志系统才能工作
    [UMCommonLogManager setUpUMCommonLogManager];
    #endif
    /** 初始化友盟所有组件产品
    @param appKey 开发者在友盟官网申请的appkey.
    @param channel 渠道标识，可设置nil表示"App Store". */
    [UMConfigure initWithAppkey:appKey channel:channel];
}

#pragma mark - 友盟推送
+ (void)UMPushStart:(NSDictionary *)launchOptions delegate:(id<UNUserNotificationCenterDelegate>)delegate {
    // Push's basic setting
    UMessageRegisterEntity *entity = [[UMessageRegisterEntity alloc] init];
    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
    entity.types = UMessageAuthorizationOptionBadge | UMessageAuthorizationOptionAlert;
    [UNUserNotificationCenter currentNotificationCenter].delegate = delegate;
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError *_Nullable error) {
        if (granted) {
        } else {
        }
    }];
}

//获取所有标签
+ (void)getTags:(void (^)(NSSet *responseTags))completion {
    [UMessage getTags:^(NSSet *_Nonnull responseTags, NSInteger remain, NSError *_Nonnull error) {
        !completion ? : completion(responseTags);
    }];
}

//添加标签
+ (void)addTags:(NSString *)tagString {
    [UMessage addTags:tagString response:^(id _Nonnull responseObject, NSInteger remain, NSError *_Nonnull error) {
    }];
}

//删除标签
+ (void)deleteTags:(NSString *)tagString {
    [UMessage deleteTags:@"体育" response:^(id _Nonnull responseObject, NSInteger remain, NSError *_Nonnull error) {
    }];
}

#pragma mark - 友盟统计
+ (void)UMAnalyticStart {
    [MobClick setAutoPageEnabled:NO];
}

+ (void)beginLogPageView:(__unsafe_unretained Class)pageView {
    [MobClick beginLogPageView:NSStringFromClass(pageView)];
}

+ (void)endLogPageView:(__unsafe_unretained Class)pageView {
    [MobClick endLogPageView:NSStringFromClass(pageView)];
}

+ (void)beginLogPageViewName:(NSString *)pageViewName {
    [MobClick beginLogPageView:pageViewName];
}

+ (void)endLogPageViewName:(NSString *)pageViewName {
    [MobClick endLogPageView:pageViewName];
}

#pragma mark - 友盟分享
+ (void)UMSocialStart:(NSString *)qqAppKey wechatAppKey:(NSString *)wechatAppKey wechatAppSecret:(NSString *)wechatAppSecret weiboAppKey:(NSString *)weiboAppKey weiboAppSecret:(NSString *)weiboAppSecret weiboCallback:(NSString *)weiboCallback{
    // 友盟分享
    /*
     * 打开图片水印
     */
    [UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    /*
     可以分享Http的图片
     */
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    //配置微信平台的Universal Links
    //微信和QQ完整版会校验合法的universalLink，不设置会在初始化平台失败
    [UMSocialGlobal shareInstance].universalLinkDic = @{ @(UMSocialPlatformType_WechatSession): @"https://umplus-sdk-download.oss-cn-shanghai.aliyuncs.com/",
                                                         @(UMSocialPlatformType_QQ): [NSString stringWithFormat:@"%@%@", @"https://umplus-sdk-download.oss-cn-shanghai.aliyuncs.com/qq_conn/", qqAppKey] };
    //配置微信平台的Universal Links
    //微信和QQ完整版会校验合法的universalLink，不设置会在初始化平台失败
    [UMSocialGlobal shareInstance].universalLinkDic = @{@(UMSocialPlatformType_WechatSession):@"https://umplus-sdk-download.oss-cn-shanghai.aliyuncs.com/",
                                                        @(UMSocialPlatformType_QQ):@"https://umplus-sdk-download.oss-cn-shanghai.aliyuncs.com/qq_conn/101830139",
                                                        @(UMSocialPlatformType_Sina):@"https://umplus-sdk-download.oss-cn-shanghai.aliyuncs.com/"
                                                        };
    
    
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:wechatAppKey appSecret:wechatAppSecret redirectURL:nil];
    /* 设置分享到QQ互联的appID，
         * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
        */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:qqAppKey/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置sina */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:weiboAppKey appSecret:weiboAppSecret redirectURL:weiboCallback];
}

//分享链接
+ (void)shareLinkToPlatform:(UMSocialPlatformType)platformType title:(NSString *)title introduction:(NSString *)introduction thumbURL:(NSString *)thumbURL shareURL:(NSString *)shareURL {
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:introduction thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = shareURL;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            [NotificationView showNotificaiton:@"分享失败" type:NotificationDanger];
            UMSocialLogInfo(@"************Share fail with error %@*********", error);
        } else {
            [NotificationView showNotificaiton:@"分享成功" type:NotificationSuccess];
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@", resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@", resp.originalResponse);
            } else {
                UMSocialLogInfo(@"response data is %@", data);
            }
        }
    }];
}

//分享文本
+ (void)shareTextToPlatform:(UMSocialPlatformType)platformType text:(NSString *)text {
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //设置文本
    messageObject.text = text;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            [NotificationView showNotificaiton:@"分享失败" type:NotificationDanger];
            NSLog(@"************Share fail with error %@*********", error);
        } else {
            [NotificationView showNotificaiton:@"分享成功" type:NotificationSuccess];
            NSLog(@"response data is %@", data);
        }
    }];
}

//分享图片
+ (void)shareImageToPlatform:(UMSocialPlatformType)platformType imageURL:(NSString *)imageURL {
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    shareObject.thumbImage = [UIImage imageNamed:@"app_icon_thumb"];
    [shareObject setShareImage:imageURL];
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            [NotificationView showNotificaiton:@"分享失败" type:NotificationDanger];
            NSLog(@"************Share fail with error %@*********", error);
        } else {
            [NotificationView showNotificaiton:@"分享成功" type:NotificationSuccess];
            NSLog(@"response data is %@", data);
        }
    }];
}

//分享音乐
+ (void)shareMusicToPlatform:(UMSocialPlatformType)platformType title:(NSString *)title introduction:(NSString *)introduction musicURL:(NSString *)musicURL {
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建音乐内容对象
    UMShareMusicObject *shareObject = [UMShareMusicObject shareObjectWithTitle:@"分享标题" descr:@"分享内容描述" thumImage:[UIImage imageNamed:@"app_icon_thumb"]];
    //设置音乐网页播放地址
    shareObject.musicUrl = musicURL;
    //            shareObject.musicDataUrl = @"这里设置音乐数据流地址（如果有的话，而且也要看所分享的平台支不支持）";
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            [NotificationView showNotificaiton:@"分享失败" type:NotificationDanger];
            NSLog(@"************Share fail with error %@*********", error);
        } else {
            [NotificationView showNotificaiton:@"分享成功" type:NotificationSuccess];
            NSLog(@"response data is %@", data);
        }
    }];
}

//分享视频
+ (void)shareVideoToPlatform:(UMSocialPlatformType)platformType title:(NSString *)title introduction:(NSString *)introduction videoURL:(NSString *)videoURL {
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建视频内容对象
    UMShareVideoObject *shareObject = [UMShareVideoObject shareObjectWithTitle:title descr:introduction thumImage:[UIImage imageNamed:@"app_icon_thumb"]];
    //设置视频网页播放地址
    shareObject.videoUrl = videoURL;
    //            shareObject.videoStreamUrl = @"这里设置视频数据流地址（如果有的话，而且也要看所分享的平台支不支持）";
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            [NotificationView showNotificaiton:@"分享失败" type:NotificationDanger];
            NSLog(@"************Share fail with error %@*********", error);
        } else {
            [NotificationView showNotificaiton:@"分享成功" type:NotificationSuccess];
            NSLog(@"response data is %@", data);
        }
    }];
}

#pragma mark - 第三方登录
+ (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType completion:(void (^)(UMSocialUserInfoResponse *result, NSError *error))completion {
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:nil completion:^(id result, NSError *error) {
        UMSocialUserInfoResponse *resp = result;

        // 第三方登录数据(为空表示平台未提供)
        // 授权数据
        NSLog(@" uid: %@", resp.uid);
        NSLog(@" openid: %@", resp.openid);
        NSLog(@" accessToken: %@", resp.accessToken);
        NSLog(@" refreshToken: %@", resp.refreshToken);
        NSLog(@" expiration: %@", resp.expiration);

        // 用户数据
        NSLog(@" name: %@", resp.name);
        NSLog(@" iconurl: %@", resp.iconurl);
        NSLog(@" gender: %@", resp.gender);

        // 第三方平台SDK原始数据
        NSLog(@" originalResponse: %@", resp.originalResponse);
        if (error) {
            [NotificationView showNotificaiton:@"登录失败" type:NotificationDanger];
        }

        completion(resp, error);
    }];
}

@end
