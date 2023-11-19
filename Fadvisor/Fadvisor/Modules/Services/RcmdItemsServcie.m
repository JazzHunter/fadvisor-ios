//
//  RcmdItems.m
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/16.
//

#import "RcmdItemsServcie.h"
#import "UserManager.h"

@interface RcmdItemsServcie ()

@property (nonatomic, copy) NSString *sortValue1;
@property (nonatomic, copy) NSString *sortValue2;
@property (nonatomic, assign) BOOL noMore;

@property (nonatomic, strong) NSDictionary *latestParams;

@end

@implementation RcmdItemsServcie

- (void)getHomeRcmdItems:(BOOL)isMore completion:(void (^)(NSError *error, BOOL isHaveNextPage))completion {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sortValue1"] = self.sortValue1 ? @"" : self.sortValue1;
    params[@"sortValue2"] = self.sortValue1 ? @"" : self.sortValue1;

    self.latestParams = params;
    // 加载热评贴的确认参数
    if (isMore) {
        params[@"sortValue1"] = self.sortValue1 ? @"" : self.sortValue1;
        params[@"sortValue2"] = self.sortValue1 ? @"" : self.sortValue1;
    }

    NSString *homeRcmdAPI =  [NSString stringWithFormat:@"/knwlsrch/item%@/home",   [UserManager sharedManager].isLogin ? @"" : @"/anonymous" ];

    [self GET:homeRcmdAPI parameters:params completion:^(BaseResponse *response) {
        // 用户上拉后有快速下拉, 下拉的数据先回来, 上拉的数据后回来
        if (self.latestParams != params) {
            return;
        }

        // 数据是空的时候不是字典了
        if (![response.responseObject isKindOfClass:[NSDictionary class]]) {
            response.error = [NSError errorWithDomain:NSGlobalDomain code:-1 userInfo:nil];
            completion(response.error, YES);
            return;
        }

        if (!response.responseObject || response.error) {
            completion(response.error, YES);
            return;
        }

        [self.rcmdItems addObjectsFromArray:[Item mj_objectArrayWithKeyValuesArray:response.responseObject[@"records"]]];

        completion(nil, true);
    }];
}

@end
