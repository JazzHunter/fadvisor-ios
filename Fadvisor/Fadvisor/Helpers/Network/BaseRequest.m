//
//  BaseRequest.m
//  FingerAdvisor
//
//  Created by 韩建伟 on 2020/2/21.
//  Copyright © 2020 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//

#import "BaseRequest.h"
#import "RequestManager.h"

@implementation BaseRequest

- (void)POST:(NSString *)URLString parameters:(id)parameters completion:(void (^)(BaseResponse *response))completion {
    Weak(self);
    [[RequestManager sharedManager] POST:URLString parameters:parameters completion:^(BaseResponse *response) {
        if (!weakself) {
            return;
        }
        !completion ? : completion(response);
    }];
}

- (void)GET:(NSString *)URLString parameters:(id)parameters completion:(void (^)(BaseResponse *response))completion {
    Weak(self);
    [[RequestManager sharedManager] GET:URLString parameters:parameters completion:^(BaseResponse *response) {
        if (!weakself) {
            return;
        }
        !completion ? : completion(response);
    }];
}

@end
