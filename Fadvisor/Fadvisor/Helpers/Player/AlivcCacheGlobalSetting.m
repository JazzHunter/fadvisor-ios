//
//  AUIVideoCacheGlobalSetting.m
//  AUIVideoList
//
//

#import "AlivcCacheGlobalSetting.h"

#if __has_include(<AliyunPlayer/AliyunPlayer.h>)
#import <AliyunPlayer/AliyunPlayer.h>
#endif

@implementation AlivcCacheGlobalSetting

+ (void)setupCacheConfig {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        [AliPlayerGlobalSettings enableLocalCache:YES maxBufferMemoryKB:10 * 1024 localCacheDir:[docDir stringByAppendingPathComponent:@"alivcCache"]];
        [AliPlayerGlobalSettings setCacheFileClearConfig:30 * 60 * 24 maxCapacityMB:20480 freeStorageMB:0];
    });
}

+ (void)clearCaches {
    [AliPlayerGlobalSettings clearCaches];
}

@end
