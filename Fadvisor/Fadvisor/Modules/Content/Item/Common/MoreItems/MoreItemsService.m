//
//  MoreItemsService.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/8/14.
//

#import "MoreItemsService.h"
#import "AccountManager.h"
#import <MJExtension.h>

@implementation MoreItemsService

- (void)getMoreItems:(NSUInteger)itemType itemId:(NSString *)itemId completion:(void (^)(NSString *errorMsg))completion {
    Weak(self);
    NSString *moreItemAPI = [NSString stringWithFormat:@"/knwlsrch/item%@/more/%lu/%@", ACCOUNT_MANAGER.isLogin ? @"" : @"/anonymous", (unsigned long)itemType, itemId];
    [self GET:moreItemAPI parameters:nil completion:^(BaseResponse *response) {
        // 数据是空的时候不是字典了
        if (![response.responseObject isKindOfClass:[NSArray class]] || !response.responseObject || response.error) {
            completion(response.errorMsg);
            return;
        }

        weakself.moreItems = [ItemModel mj_objectArrayWithKeyValuesArray:response.responseObject];
        // 截取前 10 个
        NSUInteger count = MIN(10, weakself.moreItems.count); // 确保不超过数组的实际元素数量
        NSRange range = NSMakeRange(0, count); // 截取范围
        weakself.moreItems = [weakself.moreItems subarrayWithRange:range]; // 截取前10个元素

        completion(nil);
    }];
}

@end
