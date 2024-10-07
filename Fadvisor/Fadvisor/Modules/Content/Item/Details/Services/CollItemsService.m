//
//  CollItemsService.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/8/15.
//

#import "CollItemsService.h"
#import "AccountManager.h"
#import <MJExtension.h>

@interface CollItemsService ()

@property (assign, nonatomic) NSUInteger current;
@property (assign, nonatomic) NSUInteger size;

@property (nonatomic, strong) ItemModel *collectionModel;

@property (nonatomic, strong) NSDictionary *latestParams;

@end

@implementation CollItemsService

- (void)getItems:(void (^)(NSString *errorMsg, BOOL isHaveNewData))completion {
    if (self.noMore) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"collType"] = [NSString stringWithFormat:@"%lu", (unsigned long)self.collectionModel.itemType];
    params[@"collId"] = self.collectionModel.itemId;
    params[@"current"] = [NSString stringWithFormat:@"%lu", (unsigned long)self.current];
    params[@"size"] = [NSString stringWithFormat:@"%lu", (unsigned long)self.size];

    self.latestParams = params;

    NSString *fetchCollItemsAPI = [NSString stringWithFormat:@"/knwlcnt/coll%@/item/page/valid", ACCOUNT_MANAGER.isLogin ? @"" : @"/anonymous"];

    [self GET:fetchCollItemsAPI parameters:params completion:^(BaseResponse *response) {
        // 用户上拉后有快速下拉, 下拉的数据先回来, 上拉的数据后回来
        if (self.latestParams != params) {
            return;
        }

        // 数据是空的时候不是字典了
        if (![response.responseObject isKindOfClass:[NSDictionary class]] || !response.responseObject || response.error) {
            completion(response.errorMsg, NO);
            return;
        }

        NSUInteger total = [[NSString stringWithFormat:@"%@", response.responseObject[@"total"]] intValue];
        self.total = total;

        if (response.responseObject[@"pages"] == response.responseObject[@"current"]) {
            self.noMore = YES;
        } else {
            self.current++;
        }

        NSMutableArray<ItemModel *> *records = [ItemModel mj_objectArrayWithKeyValuesArray:response.responseObject[@"records"]];
        [self.items addObjectsFromArray:records];
        completion(nil, records.count > 0);
    }];
}

- (void)reset {
    self.items = [NSMutableArray array];
    self.noMore = NO;
    self.total = 0;
    self.current = DEFAULT_PAGE_NO;
    self.size = DEFAULT_PAGE_SIZE;
}

/** 初始化*/
- (void)resetWithCollection:(ItemModel *)collection {
    self.collectionModel = collection;
    [self reset];
}

@end
