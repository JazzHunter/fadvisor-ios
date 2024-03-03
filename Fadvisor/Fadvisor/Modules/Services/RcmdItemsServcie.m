//
//  RcmdItems.m
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/16.
//

#import "RcmdItemsServcie.h"
#import "AccountManager.h"
#import <MJExtension.h>

@interface RcmdItemsServcie ()

@property (nonatomic, copy) NSString *sortValue1;
@property (nonatomic, copy) NSString *sortValue2;

@property (nonatomic, strong) NSDictionary *latestParams;

@end

@implementation RcmdItemsServcie

- (void)getHomeRcmdItems:(BOOL)isFromBottom completion:(void (^)(NSString *errorMsg, BOOL isHaveNewData))completion {
    if (self.noMore) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sortValue1"] = self.sortValue1 ? @"" : self.sortValue1;
    params[@"sortValue2"] = self.sortValue1 ? @"" : self.sortValue1;

    self.latestParams = params;

    params[@"sortValue1"] = self.sortValue1 ? @"" : self.sortValue1;
    params[@"sortValue2"] = self.sortValue2 ? @"" : self.sortValue2;

    NSString *homeRcmdAPI =  [NSString stringWithFormat:@"/knwlsrch/item%@/home", ACCOUNT_MANAGER.isLogin ? @"" : @"/anonymous" ];

    [self GET:homeRcmdAPI parameters:params completion:^(BaseResponse *response) {
        // 用户上拉后有快速下拉, 下拉的数据先回来, 上拉的数据后回来
        if (self.latestParams != params) {
            return;
        }

        // 数据是空的时候不是字典了
        if (![response.responseObject isKindOfClass:[NSDictionary class]] || !response.responseObject || response.error) {
            completion(response.errorMsg, NO);
            return;
        }

        NSMutableArray<ItemModel *> *records = [ItemModel mj_objectArrayWithKeyValuesArray:response.responseObject[@"records"]];
        NSUInteger total = [[NSString stringWithFormat:@"%@", response.responseObject[@"total"]] intValue];

        self.total = total;

        if (records.count == 0 || total == records.count) {
            self.noMore = YES;
        }

        // 读取更多是插入到最后，否则是插入到最前面
        if (isFromBottom) {
            [self.rcmdItems addObjectsFromArray:records];
        } else {
            NSRange range = NSMakeRange(0, records.count);
            NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
            [self.rcmdItems insertObjects:records atIndexes:set];
        }

        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.maximumFractionDigits = 8;
        self.sortValue1 = [formatter stringFromNumber:response.responseObject[@"sortValues"][0]];
        self.sortValue2 = response.responseObject[@"sortValues"][1];

        completion(nil, records.count > 0);
    }];
}

- (NSMutableArray<ItemModel *> *)rcmdItems {
    if (_rcmdItems == nil) {
        _rcmdItems = [NSMutableArray array];
    }
    return _rcmdItems;
}

- (void)reset {
    _rcmdItems = [NSMutableArray array];
    _noMore = NO;
    _total = 0;
    self.sortValue1 = @"";
    self.sortValue2 = @"";
}

@end
