//
//  main.m
//  FingerAdvisor
//
//  Created by 韩建伟 on 2019/11/26.
//  Remake on 2023/11/11.
//  Copyright © 2023 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//
/*

く__,.ヘヽ.　　　　/　,ー､ 〉
　　　　　＼ ', !-─‐-i　/　/´
　　　 　 ／｀ｰ'　　　 L/／｀ヽ､
　　 　 /　 ／,　 /|　 ,　 ,　　 ',
　 　　ｲ 　/ /-‐/　ｉ　L_ ﾊ ヽ!　 i
　　　 ﾚ ﾍ 7ｲ｀ﾄ　 ﾚ'ｧ-ﾄ､!ハ|　 |
　　　　 !,/7 '0'　　 ´0iソ| 　 |
　　　　 |.从"　　_　　 ,,,, / |./ 　 |
　　　　 ﾚ'| i＞.､,,__　_,.イ / 　.i 　|
　　　　　 ﾚ'| | / k_７_/ﾚ'ヽ,　ﾊ.　|
　　　　　　 | |/i 〈|/　 i　,.ﾍ |　i　|
　　　　　　.|/ /　ｉ： 　 ﾍ!　　＼　|
　　　 　 　 kヽ>､ﾊ 　 _,.ﾍ､ 　 /､!
　　　　　　 !'〈//｀Ｔ´', ＼ ｀'7'ｰr'
　　　　　　 ﾚ'ヽL__|___i,___,ンﾚ|ノ
　　　　　 　　　ﾄ-,/　|___./
　　　　　 　　　'ｰ'　　!_,.:
 
 🚀 All You Need Is Love. 🔥
By Jianwei.Han@PricewaterhouseCoopers Zhong Tian LLP on 2020
*********************************************************************************/
#import <UIKit/UIKit.h>

void UncaughtExceptionHandler(NSException *exception);

int main(int argc, char * argv[]) {
    @try {
        return UIApplicationMain(argc, argv, @"UIApplication", @"AppDelegate");
    } @catch (NSException *exception) {
        UncaughtExceptionHandler(exception);
    } @finally {
    }
}

// 设置一个C函数，用来接收崩溃信息
void UncaughtExceptionHandler(NSException *exception) {
    // 可以通过exception对象获取一些崩溃信息，我们就是通过这些崩溃信息来进行解析的，例如下面的symbols数组就是我们的崩溃堆栈。
    NSArray *symbols = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *caches = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithContentsOfFile:[caches stringByAppendingPathComponent:@"app_crash.plist"]];
    
    if (!dictM) {
        dictM = [NSMutableDictionary dictionary];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmssSSS";
    NSString *timestamp = [formatter stringFromDate:[NSDate date]];
    
    
    NSDictionary *dict = @{
                           timestamp : @{
                                   [timestamp stringByAppendingString:@"name"] : name,
                                   [timestamp stringByAppendingString:@"_reason"] : reason,
                                   [timestamp stringByAppendingString:@"__symbols"] : symbols
                                   }
                           };
    [dictM setValuesForKeysWithDictionary:dict];
    [dictM writeToFile:[caches stringByAppendingPathComponent:@"app_crash.plist"] atomically:YES];
}
