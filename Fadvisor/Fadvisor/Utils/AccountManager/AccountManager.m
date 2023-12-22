//
//  AccountManager.m
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/18.
//

#import "AccountManager.h"
#import "BaseRequest.h"

@implementation AccountManager

static id _instance = nil;
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [NSKeyedUnarchiver unarchiveObjectWithFile:[self archiveFilePath]];
        if (!_instance) {
            _instance = [[self alloc] init];
        }
    });

    return _instance;
}

- (BOOL)isLogin {
    if (!self.token) {
        return NO;
    }
    return YES;
}

+ (NSString *)archiveFilePath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingString:NSStringFromClass(self)];
}

#pragma mark - 单例
- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}
@end
