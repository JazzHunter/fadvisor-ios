//
//  LoginService.m
//  Fadvisor
//
//  Created by 韩建伟 on 2023/12/19.
//

#import "LoginService.h"

@implementation LoginService

- (void)loginBySms:(NSString *)phone code:(NSString *)code completion:(void (^)(NSString *errorMsg, NSDictionary *detailsDic))completion {
    Weak(self);
    NSString *tokenUrl = @"/auth/oauth/token";
    NSMutableDictionary<NSString *, NSString *> *params = @{}.mutableCopy;
    [params setValue:phone forKey:@"mobile"];
    [params setValue:code forKey:@"code"];
    [params setValue:@"mobile" forKey:@"grant_type"];
    [self request:@"POST" URL:tokenUrl parameters:params isToken:YES completion:^(BaseResponse *response) {
        // 数据是空的时候不是字典了
        if (![response.responseObject isKindOfClass:[NSDictionary class]] || !response.responseObject || response.error) {
            completion(response.errorMsg, nil);
            return;
        }
//        weakself.result = [ItemDetailsResultModel mj_objectWithKeyValues:response.responseObject];
//        
//        completion(nil, response.responseObject[@"details"]);
    }];
}

@end
