//
//  RcmdAuthorsService.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/8/3.
//

#import "RcmdAuthorsService.h"
#import "AccountManager.h"
#import <MJExtension.h>

@implementation RcmdAuthorsService


- (void)getRcmdAuthors:(void (^)(NSString *errorMsg))completion {
    if (self.inited) {
        return completion(nil);
    }
    
    NSString *rcmdAuthorsAPI =  [NSString stringWithFormat:@"/knwlsrch/author%@/rcmd", ACCOUNT_MANAGER.isLogin ? @"" : @"/anonymous" ];

    [self GET:rcmdAuthorsAPI parameters:nil completion:^(BaseResponse *response) {
        // 数据是空的时候不是字典了
        if (!response.responseObject || response.error) {
            completion(response.errorMsg);
            return;
        }

        NSMutableArray<AuthorModel *> *records = [AuthorModel mj_objectArrayWithKeyValuesArray:response.responseObject];
        if (records.count > 0 && !self.inited) {
            self.inited = YES;
        }

        [self.rcmdAuthors addObjectsFromArray:records];
        
        completion(nil);
    }];
}

- (NSMutableArray<AuthorModel *> *)rcmdAuthors {
    if (_rcmdAuthors == nil) {
        _rcmdAuthors = [NSMutableArray array];
    }
    return _rcmdAuthors;
}

- (void)reset {
    _rcmdAuthors = [NSMutableArray array];
    _inited = NO;
}


@end
