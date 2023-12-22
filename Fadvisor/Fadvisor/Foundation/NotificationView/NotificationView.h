//
//  NotificationView.h
//  FingerAdvisor
//
//  Created by 韩建伟 on 2020/3/1.
//  Copyright © 2020 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 背景颜色值的类型, 默认NotificationViewTypeInfo */
typedef enum : NSUInteger {
    NotificationSuccess, //成功
    NotificationDanger, //错误
    NotificationWarning, //警告
    NotificationInfo, //信息
} NotificationType;

@interface NotificationView : UIView
/**
 显示通知
 @param message 通知文字
 */
+ (NotificationView *)showNotificaiton:(NSString *)message;
+ (NotificationView *)showNotificaiton:(NSString *)message type:(NotificationType)type;

@end

@interface NotificationLargeView : UIView
/**
 显示通知
 @param message 通知文字
 */
+ (NotificationLargeView *)showNotificaiton:(NSString *)message;
+ (NotificationLargeView *)showNotificaiton:(NSString *)message type:(NotificationType)type;

@end
