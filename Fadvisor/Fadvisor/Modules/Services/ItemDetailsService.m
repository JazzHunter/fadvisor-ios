//
//  ArticleDetailsService.m
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/26.
//

#import "ItemDetailsService.h"

@implementation ItemDetailsService

- (void)getDetails:(NSUInteger)itemType itemId:(NSString *)itemId completion:(void (^)(NSError *error, NSDictionary *detailsDic))completion {
    Weak(self);
    NSString *itemDetailsAPI =  [NSString stringWithFormat:@"/knwlcnt/item%@/details/%lu/%@",   [UserManager sharedManager].isLogin ? @"" : @"/anonymous", (unsigned long)itemType, itemId];
    [self GET:itemDetailsAPI parameters:nil completion:^(BaseResponse *response) {
        // 数据是空的时候不是字典了
        if (![response.responseObject isKindOfClass:[NSDictionary class]]) {
            response.error = [NSError errorWithDomain:NSGlobalDomain code:-1 userInfo:nil];
            completion(response.error, nil);
            return;
        }

        if (!response.responseObject || response.error) {
            completion(response.error, nil);
            return;
        }
        
        weakself.result = [ItemDetailsResultModel mj_objectWithKeyValues:response.responseObject];
        
        completion(nil, response.responseObject[@"details"]);
    }];
}
@end
