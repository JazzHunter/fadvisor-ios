//
//  LoacalDataStorage.m
//  FingerAdvisor
//
//  Created by 韩建伟 on 2020/2/21.
//  Copyright © 2020 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//

#import "LocalDataStorage.h"
#import "YYCache.h"
#import "YYDiskCache.h"

//YYCache
#define LocalStorageDataCahceKey @"CacheData"
//是否是空对象
#define IsEmpty(_object) (_object == nil \
                          || [_object isKindOfClass:[NSNull class]] \
                          || ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
                          || ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

@implementation LocalDataStorage

+ (id)cacheForKey:(NSString *)key {
    if (!key) return nil;
    YYCache *cache = [YYCache cacheWithName:LocalStorageDataCahceKey];
    return [cache objectForKey:key];
}

+ (void)setCache:(id)model forKey:(NSString *)key {
    if (IsEmpty(model) || !key) return;
    YYCache *cache = [YYCache cacheWithName:LocalStorageDataCahceKey];
    [cache setObject:model forKey:key];
}

+ (void)cacheSizeWithBlock:(void (^)(NSInteger bytes))block {
    YYCache *cache = [YYCache cacheWithName:LocalStorageDataCahceKey];
    [cache.diskCache totalCostWithBlock:^(NSInteger totalCost) {
        !block ? : block(totalCost);
    }];
}

+ (void)removeCacheForKey:(NSString *)key {
    YYCache *cache = [YYCache cacheWithName:LocalStorageDataCahceKey];
    [cache removeObjectForKey:key];
}

+ (void)clearAllCacheWithBlock:(void (^)(void))block {
    YYCache *cache = [YYCache cacheWithName:LocalStorageDataCahceKey];
    [cache removeAllObjectsWithBlock:block];
}

+ (void)clearAllCache {
    YYCache *cache = [YYCache cacheWithName:LocalStorageDataCahceKey];
    [cache removeAllObjects];
}

@end
