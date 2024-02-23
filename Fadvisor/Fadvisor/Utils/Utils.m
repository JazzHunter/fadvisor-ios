//
//  Utils.m
//  FingerAdvisor
//
//  Created by 韩建伟 on 2019/11/27.
//  Copyright © 2019 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//

#import "Utils.h"
#import <sys/utsname.h>

@implementation Utils

+ (void)dispatchAsyncBlock:(void (^)(void))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), [block copy]);
}

//主线程 执行
+ (void)dispatchMainQueueBlock:(void (^)(void))block
{
    dispatch_async(dispatch_get_main_queue(), block);
}

//延时执行
+ (void)dispatchQueueDelayTime:(float)delayTime block:(void (^)(void))block
{
    double delayInSeconds = delayTime;
    //创建一个调度时间,相对于默认时钟或修改现有的调度时间。
    dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    //推迟两纳秒执行
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_after(delayInNanoSeconds, concurrentQueue, ^{
        [Utils dispatchMainQueueBlock:block];
    });
}

+ (NSString *)currentDateStrWithFormat:(NSString *)format {
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:format];//设定时间格式,这里可以设置成自己需要的格式
    NSString *dateString = [dateFormatter stringFromDate:currentDate];//将时间转化成字符串
    return dateString;
}

//获取当前时间戳
+ (NSString *)currentTimeStr {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time = [date timeIntervalSince1970] * 1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

+ (NSString *)formatFloat:(double)f
{
    if (fmod(f, 1) == 0) {//如果有一位小数点
        return [NSString stringWithFormat:@"%.0f", f];
    } else if (fmodf(f * 10, 1) == 0) {//如果有两位小数点
        return [NSString stringWithFormat:@"%.1f", f];
    } else {
        return [NSString stringWithFormat:@"%.2f", f];
    }
}

+ (NSString *)deviceModelName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];

    //iPhone 系列
    if ([deviceModel isEqualToString:@"iPhone1,1"]) return @"iPhone 1G";
    if ([deviceModel isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([deviceModel isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([deviceModel isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"]) return @"Verizon iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,3"]) return @"iPhone 5C";
    if ([deviceModel isEqualToString:@"iPhone5,4"]) return @"iPhone 5C";
    if ([deviceModel isEqualToString:@"iPhone6,1"]) return @"iPhone 5S";
    if ([deviceModel isEqualToString:@"iPhone6,2"]) return @"iPhone 5S";
    if ([deviceModel isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([deviceModel isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    if ([deviceModel isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    if ([deviceModel isEqualToString:@"iPhone10,3"]) return @"iPhone X";

    //iPod 系列
    if ([deviceModel isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    if ([deviceModel isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    if ([deviceModel isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    if ([deviceModel isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    if ([deviceModel isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";

    //iPad 系列
    if ([deviceModel isEqualToString:@"iPad1,1"]) return @"iPad";
    if ([deviceModel isEqualToString:@"iPad2,1"]) return @"iPad 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,2"]) return @"iPad 2 (GSM)";
    if ([deviceModel isEqualToString:@"iPad2,3"]) return @"iPad 2 (CDMA)";
    if ([deviceModel isEqualToString:@"iPad2,4"]) return @"iPad 2 (32nm)";
    if ([deviceModel isEqualToString:@"iPad2,5"]) return @"iPad mini (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,6"]) return @"iPad mini (GSM)";
    if ([deviceModel isEqualToString:@"iPad2,7"]) return @"iPad mini (CDMA)";

    if ([deviceModel isEqualToString:@"iPad3,1"]) return @"iPad 3(WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,2"]) return @"iPad 3(CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,3"]) return @"iPad 3(4G)";
    if ([deviceModel isEqualToString:@"iPad3,4"]) return @"iPad 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,5"]) return @"iPad 4 (4G)";
    if ([deviceModel isEqualToString:@"iPad3,6"]) return @"iPad 4 (CDMA)";

    if ([deviceModel isEqualToString:@"iPad4,1"]) return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,2"]) return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,3"]) return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad5,3"]) return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"]) return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"i386"]) return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"]) return @"Simulator";

    if ([deviceModel isEqualToString:@"iPad4,4"]
        || [deviceModel isEqualToString:@"iPad4,5"]
        || [deviceModel isEqualToString:@"iPad4,6"]) return @"iPad mini 2";

    if ([deviceModel isEqualToString:@"iPad4,7"]
        || [deviceModel isEqualToString:@"iPad4,8"]
        || [deviceModel isEqualToString:@"iPad4,9"]) return @"iPad mini 3";

    return deviceModel;
}

+ (NSString *)shortedNumberDesc:(long)number {
    // should be localized
    if (number < 0) return @"0";
    if (number <= 999) return [NSString stringWithFormat:@"%d", (int)number];
    if (number <= 999999) return [NSString stringWithFormat:@"%dk+", (int)(number / 1000)];
    return @"100w+";
}

+ (NSString *)shortedNumberPrice:(double)number {
    // should be localized
    if (number >= 1000000) {
        double showNum = number / 1000000;
        return [NSString stringWithFormat:@"%@m", [Utils formatFloat:showNum]];
    }

    if (number >= 10000) {
        double showNum = number / 1000;
        return [NSString stringWithFormat:@"%@k", [Utils formatFloat:showNum]];
    }
    return [NSString stringWithFormat:@"%@", [Utils formatFloat:number]];
}

+ (NSString *)countStringHandle:(NSInteger)count {
    NSString *countString = nil;
    // 超限处理
    if (count > 9999) {
        NSInteger wan = count / 10000;
        NSInteger qian = (count - wan * 10000) / 1000;
        if (qian && wan < 100) {
            countString = [NSString stringWithFormat:@"%ld.%ld万", wan, qian];
        } else {
            countString = [NSString stringWithFormat:@"%ld万", wan];
        }
    } else {
        countString = [NSString stringWithFormat:@"%ld", count];
    }
    return countString;
}

+ (NSString *)formatNumberDecimalValue:(double)value {
    NSString *string = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithLongLong:value]
                                                        numberStyle:NSNumberFormatterDecimalStyle];
    return string;
}

+ (NSDictionary *)convertToDictionary:(NSString *)jsonStr {
    NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return tempDic;
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum {
//    电信号段:133/153/180/181/189/177
//    联通号段:130/131/132/155/156/185/186/145/176
//    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
//    虚拟运营商:170

    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:mobileNum];
}

+ (UIViewController *)currentViewController {
    UIViewController *vc = [UIApplication sharedApplication].delegate.window.rootViewController;

    while (1) {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController *)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController *)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        } else {
            break;
        }
    }

    return vc;
}

+ (UIViewController *)findSuperViewController:(UIView *)view
{
    UIResponder *responder = view;
    // 循环获取下一个响应者,直到响应者是一个UIViewController类的一个对象为止,然后返回该对象.
    while ((responder = [responder nextResponder])) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
    }
    return nil;
}

+ (NSString *)timeformatFromSeconds:(NSInteger)seconds {
    //format of hour
    seconds = seconds / 1000;
    NSString *str_hour = [NSString stringWithFormat:@"%02ld", (long)seconds / 3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld", (long)(seconds % 3600) / 60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld", (long)seconds % 60];

    return seconds / 3600 <= 0 ? [NSString stringWithFormat:@"%@:%@", str_minute, str_second] : [NSString stringWithFormat:@"%@:%@:%@", str_hour, str_minute, str_second];
}

+ (NSString *)speedformatFromBytes:(int64_t)speed {
    if (speed < 1048576) {
        return [NSString stringWithFormat:@"%.2fKB", (double)speed / 1024];
    }
    if (speed >= 1048576 && speed < 1073741824) {
        return [NSString stringWithFormat:@"%.2fMB", (double)speed / (1024 * 1024)];
    }
    if (speed >= 1073741824 && speed < 1099511627776) {
        return [NSString stringWithFormat:@"%.2fGB", (double)speed / (1024 * 1024 * 1024)];
    }
    return @">1TB";
}

+ (void)drawFillRoundRect:(CGRect)rect radius:(CGFloat)radius color:(UIColor *)color context:(CGContextRef)context {
    CGContextSetAllowsAntialiasing(context, TRUE);
    CGContextSetFillColor(context, CGColorGetComponents(color.CGColor));
    //    CGContextSetRGBFillColor(context, red, green, blue, alpha);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect));
    CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMidX(rect), CGRectGetMinY(rect), radius);
    CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMidY(rect), radius);
    CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMidX(rect), CGRectGetMaxY(rect), radius);
    CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMidY(rect), radius);
    CGContextClosePath(context);
    CGContextFillPath(context);
}

+ (BOOL)isInterfaceOrientationPortrait {
    UIInterfaceOrientation o = [[UIApplication sharedApplication] statusBarOrientation];
    return o == UIInterfaceOrientationPortrait;
}

@end
