//
//  KeyChainHelper.h
//  FadvisorUtils
//
//  Created by 韩建伟 on 2021/3/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyChainHelper : NSObject


+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service;

+ (void)save:(NSString *)service data:(id)data;

+ (id)load:(NSString *)service;

+ (void)delete:(NSString *)service;

+ (NSString *)getToken;

+ (void)saveToken:(NSString *)token;

+ (void)deleteToken;

@end

NS_ASSUME_NONNULL_END
