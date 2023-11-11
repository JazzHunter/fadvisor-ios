//
//  FAConstants.h
//  FingerAdvisor
//
//  Created by 韩建伟 on 2019/11/27.
//  Copyright © 2019 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//
#import "AppDelegate.h"

#ifndef Constants_h
#define Constants_h
//APP名称
#define AppName                           @"FingerAdvisor"
#define BundleId                          @"com.pwccn.fadvisor"
#define AppSlogan                         @"工作要用的App"
#define AppSubSlogan                      @"Adapt · Connect · Empower"
#define APPID                             @"1271998307"

#define DefaultContactEmail               @"kc@cn.pwc.com"
#define BaseURL                           @"http://a3d2146881.zicp.vip/"

// 友盟
#define ThirdSDKUMConfigInstanceAppKey    @"5ea912a0167eddb71800005a"
#define ThirdSDKUMConfigInstanceChannelId @"App Store"
#define ThirdSDKWeChatAppKey              @"wx82be436160f16043"
#define ThirdSDKWeChatAppSecret           @"25938692c05a5ef471b59e1f01b83ae4"
#define ThirdSDKQQAppKey                  @"101826811"

#define ThirdSDKWeiboAppKey               @"1136310752"
#define ThirdSDKWeiboAppSecret            @"04b48b094faeb16683c32669824ebdad"
#define ThirdSDKWeiboCallback             @"https://api.weibo.com/oauth2/default.html"

#define DEFAULT_PAGE_NO                   1
#define DEFAULT_PAGE_SIZE                 20

/**
 需要加载的数据类型
 */
typedef enum : NSUInteger {
    ModuleTypeAll = 1,
    ModuleTypeWeb = 2,
    ModuleTypeItem = 3,
    ModuleTypeAuthor = 4,
    ModuleTypeArticle = 11,
    ModuleTypePublication = 12,
    ModuleTypeVideo = 13,
    ModuleTypeTopic = 14,
    ModuleTypeColumn = 15,
    ModuleTypeContact = 16,
    ModuleTypeTeam = 17,
    ModuleTypeAudio = 31,
    ModuleTypeImage = 32
} ModuleType;

typedef enum : NSUInteger {
    PageLoadStateNotInited = 1, //初次进入，尚未初始化
    PageLoadStateInited4LoadMore = 2, //初始化成功，后续是获取更多
    PageLoadStateInited4Refresh = 3,  //初始化成功，后续是重新刷新数据
    PageLoadStateInitedError = 9
} PageLoadState;

typedef NS_ENUM (NSInteger, ItemTableViewCellShowType) {
    /** 未知模式*/
    ItemTableViewCellShowTypeUnknown          = 0,
    /** 正常模式*/
    ItemTableViewCellShowTypeNormal           = 1,
    /** 作者关注状态 */
    ItemTableViewCellShowTypeAuthorSubscribed = 2,
    /** 专题关注状态  */
    ItemTableViewCellShowTypeTopicSubscribed  = 3
};

#endif
