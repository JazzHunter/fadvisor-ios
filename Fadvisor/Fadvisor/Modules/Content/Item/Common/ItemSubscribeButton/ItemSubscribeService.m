//
//  ItemSubscribeService.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/9/28.
//

#import "ItemSubscribeService.h"

@implementation ItemSubscribeService

- (instancetype)init {
    self = [super init];
    if (self) {
        self.loading = NO;
    }
    return self;
}

- (void)toggleItemSubscribe:(BOOL)isSubscribed authorId:(NSString *)itemId completion:(void (^)(NSString *errorMsg))completion {
    NSString *toggleItemSubscribeAPI =  @"/knwlact/act/item/subscribe/toggle";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"itemId"] = itemId.copy;
    params[@"subscribe"] = isSubscribed ? JUDGE_IS : JUDGE_NOT;
    self.loading = YES;

    [self PUT:toggleItemSubscribeAPI parameters:params completion:^(BaseResponse *response) {
        self.loading = NO;
        // 数据是空的时候不是字典了
        if (![response.responseObject isKindOfClass:[NSDictionary class]] || !response.responseObject || response.error) {
            completion(response.errorMsg);
            return;
        }
        completion(nil);
    }];
}


@end
