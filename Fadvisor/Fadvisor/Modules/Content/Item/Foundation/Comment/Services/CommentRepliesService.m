//
//  CommentRepliesServices.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/3/4.
//

#import "CommentRepliesService.h"
#import "AccountManager.h"
#import <MJExtension.h>

@interface CommentRepliesService ()

@property (assign, nonatomic) NSUInteger current;
@property (assign, nonatomic) NSUInteger size;

@property (nonatomic, strong) CommentModel *masterCommentModel;

@property (nonatomic, strong) NSDictionary *latestParams;

@end

@implementation CommentRepliesService

- (instancetype)initWithMasterComment:(CommentModel *)masterComment {
    self = [super init];
    if (self) {
        [self resetWithMasterComment:masterComment];

    }
    return self;
}

- (void)getReplies:(BOOL)isFromBottom completion:(void (^)(NSString *errorMsg, BOOL isHaveNewData))completion {
    if (self.noMore) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"current"] = [NSString stringWithFormat:@"%lu", (unsigned long)self.current];
    params[@"size"] = [NSString stringWithFormat:@"%lu", (unsigned long)self.size];

    params[@"descs"] = @[@"create_time"];

    self.latestParams = params;

    NSString *fetchReplyPageAPI = [NSString stringWithFormat:@"/knwlact/comment%@/reply/page/%@", ACCOUNT_MANAGER.isLogin ? @"" : @"/anonymous", self.masterCommentModel.commentId];

    [self GET:fetchReplyPageAPI parameters:params completion:^(BaseResponse *response) {
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

        NSMutableArray<CommentModel *> *records = [CommentModel mj_objectArrayWithKeyValuesArray:response.responseObject[@"records"]];
        // 读取更多是插入到最后，否则是插入到最前面
        if (isFromBottom) {
            [self.replies addObjectsFromArray:records];
        } else {
            NSRange range = NSMakeRange(0, records.count);
            NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
            [self.replies insertObjects:records atIndexes:set];
        }
        completion(nil, records.count > 0);
    }];
}

- (void)reset {
    self.replies = [NSMutableArray array];
    self.noMore = NO;
    self.total = 0;
    self.current = DEFAULT_PAGE_NO;
    self.size = DEFAULT_PAGE_SIZE;
}

- (void)resetWithMasterComment:(CommentModel *)masterComment {
    [self reset];
    self.masterCommentModel = masterComment;
}

@end
