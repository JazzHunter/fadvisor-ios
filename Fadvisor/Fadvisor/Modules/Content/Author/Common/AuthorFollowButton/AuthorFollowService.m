//
//  AuthorFollowService.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/24.
//

#import "AuthorFollowService.h"

@interface AuthorFollowService ()

@end

@implementation AuthorFollowService

- (instancetype)init {
    self = [super init];
    if (self) {
        self.loading = NO;
    }
    return self;
}

- (void)toggleAuthorFollow:(BOOL)isFollowed authorId:(NSString *)authorId completion:(void (^)(NSString *errorMsg))completion {
    NSString *toggleAuthorFollowAPI =  @"/knwlact/act/author/follow/toggle";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"authorId"] = authorId.copy;
    params[@"follow"] = isFollowed ? JUDGE_IS : JUDGE_NOT;
    self.loading = YES;

    [self PUT:toggleAuthorFollowAPI parameters:params completion:^(BaseResponse *response) {
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
