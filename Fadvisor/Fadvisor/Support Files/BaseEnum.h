//
//  BaseEnum.h
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/19.
//

#ifndef BaseEnum_h
#define BaseEnum_h

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

#endif /* BaseEnum_h */
