//
//  Utils.h
//  FingerAdvisor
//
//  Created by 韩建伟 on 2019/11/27.
//  Copyright © 2019 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Utils : NSObject

//获取当前时间
+ (NSString *)currentDateStrWithFormat:(NSString *)format;

//获取当前的时间戳
+ (NSString *)currentTimeStr;

// 发布时间字符串的格式化
+ (NSString *)formatBackendTimeString:(NSString *)timeString;

+ (NSString *)deviceModelName;

+ (NSString *)formatFloat:(double)f;

+ (void)dispatchAsyncBlock:(void (^)(void))block;

+ (NSString *)shortedNumberPrice:(double)number;

//主线程 执行
+ (void)dispatchMainQueueBlock:(void (^)(void))block;

//延时执行
+ (void)dispatchQueueDelayTime:(float)delayTime block:(void (^)(void))block;

+ (NSString *)shortedNumberDesc:(long)number;

+ (NSString *)countStringHandle:(NSInteger)count;

+ (NSString *)formatNumberDecimalValue:(double)value;

+ (NSDictionary *)convertToDictionary:(NSString *)jsonStr;

+ (BOOL)isMobileNumber:(NSString *)mobileNum;

+ (UIViewController *)currentViewController;

+ (UINavigationController *)currentNavigationController;

+ (UIViewController *)findSuperViewController:(UIView *)view;

//根据s-》hh:mm:ss
+ (NSString *)timeFormatFromSeconds:(NSInteger)seconds;

//根据s-》多少小时多少分钟
+ (NSString *)durationFormatFromSeconds:(NSInteger)seconds;

//根据byte-》速度
+ (NSString *)formatFromBytes:(int64_t)seconds;

//绘制
+ (void)drawFillRoundRect:(CGRect)rect radius:(CGFloat)radius color:(UIColor *)color context:(CGContextRef)context;

//是否手机状态条处于竖屏状态
+ (BOOL)isInterfaceOrientationPortrait;

@end

NS_ASSUME_NONNULL_END
