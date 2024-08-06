//
//  AuthorDetailsService.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/7/2.
//

#import "AuthorDetailsService.h"
#import "AccountManager.h"
#import <MJExtension.h>

@implementation AuthorDetailsService

- (void)getDetails:(NSString *)authorId completion:(void (^)(NSString *errorMsg, NSDictionary *detailsDic))completion {
    Weak(self);
    NSString *authorDetailsAPI =  [NSString stringWithFormat:@"/knwlcnt/author%@/details/%@", ACCOUNT_MANAGER.isLogin ? @"" : @"/anonymous", authorId];
    [self GET:authorDetailsAPI parameters:nil completion:^(BaseResponse *response) {
        // 数据是空的时候不是字典了
        if (![response.responseObject isKindOfClass:[NSDictionary class]] || !response.responseObject || response.error) {
            completion(response.errorMsg, nil);
            return;
        }

        weakself.result = [AuthorDetailsResultModel mj_objectWithKeyValues:response.responseObject];

        completion(nil, response.responseObject[@"details"]);
    }];
}

@end
