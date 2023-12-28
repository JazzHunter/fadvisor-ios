//
//  ArticleDetailsService.m
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/26.
//

#import "ItemDetailsService.h"
#import "AccountManager.h"
#import <MJExtension.h>

@implementation ItemDetailsService

- (void)getDetails:(NSUInteger)itemType itemId:(NSString *)itemId completion:(void (^)(NSString *errorMsg, NSDictionary *detailsDic))completion {
    Weak(self);
    NSString *itemDetailsAPI =  [NSString stringWithFormat:@"/knwlcnt/item%@/details/%lu/%@",   [AccountManager sharedManager].isLogin ? @"" : @"/anonymous", (unsigned long)itemType, itemId];
    [self GET:itemDetailsAPI parameters:nil completion:^(BaseResponse *response) {
        // 数据是空的时候不是字典了
        if (![response.responseObject isKindOfClass:[NSDictionary class]] || !response.responseObject || response.error) {
            completion(response.errorMsg, nil);
            return;
        }

        weakself.result = [ItemDetailsResultModel mj_objectWithKeyValues:response.responseObject];
        
        completion(nil, response.responseObject[@"details"]);
    }];
}
@end
