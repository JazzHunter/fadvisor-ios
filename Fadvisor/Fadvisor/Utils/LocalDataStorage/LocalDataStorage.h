//
//  LoacalDataStorage.h
//  FingerAdvisor
//
//  Created by 韩建伟 on 2020/2/21.
//  Copyright © 2020 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LocalDataStorage : NSObject

+ (id)cacheForKey:(NSString *)key;

+ (void)setCache:(id)model forKey:(NSString *)key;

+ (void)cacheSizeWithBlock:(void (^)(NSInteger bytes))block;

+ (void)removeCacheForKey:(NSString *)key;

+ (void)clearAllCacheWithBlock:(void (^)(void))block;

+ (void)clearAllCache;

@end
