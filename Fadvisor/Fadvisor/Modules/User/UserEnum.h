//
//  UserEnum.h
//  Fadvisor
//
//  Created by 韩建伟 on 2023/12/19.
//

#ifndef UserEnum_h
#define UserEnum_h

/**
 需要加载的数据类型
 */
typedef enum : NSInteger {
    UserStatusInactive = 0,
    UserStatusNormal = 1,
    UserStatusSuspend = 8
} UserStatus;


#endif /* UserEnum_h */
