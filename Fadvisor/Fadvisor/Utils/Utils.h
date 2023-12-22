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

+ (NSString *)isNullToString:(id)string;

+ (NSDictionary *)convertToDictionary:(NSString *)jsonStr;

+ (BOOL)isMobileNumber:(NSString *)mobileNum;

+ (NSString *)getDeviceId;

+ (UIViewController *)currentViewController;

@end

NS_ASSUME_NONNULL_END
