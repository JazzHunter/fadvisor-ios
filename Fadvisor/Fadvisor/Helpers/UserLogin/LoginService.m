//
//  LoginService.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/10/14.
//

#import "LoginService.h"
#import "RequestManager.h"

@implementation LoginService

- (void)sendLoginPhoneSms:(NSString *)phone completion:(void (^)(NSString *errorMsg))completion {
    NSString *urlString =  [NSString stringWithFormat:@"/upms/sms/phone/%@", phone];
    Weak(self);
    [[RequestManager sharedManager] request:@"GET" URL:urlString parameters:nil isToken:YES completion:^(BaseResponse *response) {
        if (!weakself) {
            return;
        }
        // 数据是空的时候不是字典了
        if (![response.responseObject isKindOfClass:[NSDictionary class]] || !response.responseObject || response.error) {
            completion(response.errorMsg);
            return;
        }

        NSLog(@"%@", response.responseObject);

        !completion ? : completion(nil);
    }];
}

- (void)loginBySms:(NSString *)phone code:(NSString *)code completion:(void (^)(NSString *errorMsg))completion {
    NSString *urlString = @"/auth/oauth/token";

//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"mobile"] = phone;
//    params[@"code"] = code;
//    params[@"grant_type"] = @"mobile";
    
    NSMutableDictionary<NSString *, NSString *> *params = @{}.mutableCopy;
    [params setValue:phone forKey:@"mobile"];
    [params setValue:code forKey:@"code"];
    [params setValue:@"mobile" forKey:@"grant_type"];
    
    Weak(self);
    [[RequestManager sharedManager] request:@"POST" URL:urlString parameters:params isToken:YES completion:^(BaseResponse *response) {
        if (!weakself) {
            return;
        }

        // 数据是空的时候不是字典了
        if (![response.responseObject isKindOfClass:[NSDictionary class]] || !response.responseObject || response.error) {
            completion(response.errorMsg);
            return;
        }

        NSLog(@"%@", response.responseObject);
        !completion ? : completion(nil);
    }];
}

+ (instancetype)sharedInstance {
    static LoginService *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

@end
