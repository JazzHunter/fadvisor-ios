//
//  CommentsService.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/29.
//

#import "CommentsService.h"
#import "AccountManager.h"
#import <MJExtension.h>

@interface CommentsService ()

@property (assign, nonatomic) NSUInteger current;
@property (assign, nonatomic) NSUInteger size;

@property (nonatomic, assign) NSUInteger itemType;
@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *commentMode;

@property (nonatomic, strong) NSDictionary *latestParams;

@end

@implementation CommentsService

- (instancetype)initWithItemType:(NSUInteger)itemType itemId:(NSString *)itemId commentMode:(NSString *)commentMode {
    self = [super init];
    if (self) {
        self.itemType = itemType;
        self.itemId = itemId;
        self.commentMode = commentMode;
        self.orderType = COMMENTS_ORDER_TYPE_SET;
        [self reset];
    }
    return self;
}

- (void)getComments:(BOOL)isFromBottom completion:(void (^)(NSString *errorMsg, BOOL isHaveNewData))completion {
    if (self.noMore) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"current"] = [NSString stringWithFormat:@"%lu", (unsigned long)self.current];
    params[@"size"] = [NSString stringWithFormat:@"%lu", (unsigned long)self.size];

    params[@"descs"] = @[@"top", @"top_time", @"create_time"];

    if ([self.commentMode isEqualToString:COMMENT_MODE_FREE]) {
        params[@"order"] = self.orderType;
    } else if ([self.commentMode isEqualToString:COMMENT_MODE_FEATURE]) {
        params[@"feature"] = JUDGE_IS;
    }

    self.latestParams = params;

    NSString *fetchCommentPageAPI = [NSString stringWithFormat:@"/knwlact/comment%@/page/%lu/%@", ACCOUNT_MANAGER.isLogin ? @"" : @"/anonymous", self.itemType, self.itemId];

    [self GET:fetchCommentPageAPI parameters:params completion:^(BaseResponse *response) {
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
//        if (records.count == 0 || total == records.count) {
//            self.noMore = YES;
//        }
        // 读取更多是插入到最后，否则是插入到最前面
        if (isFromBottom) {
            [self.comments addObjectsFromArray:records];
        } else {
            NSRange range = NSMakeRange(0, records.count);
            NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
            [self.comments insertObjects:records atIndexes:set];
        }
        completion(nil, records.count > 0);
    }];
}

- (void)reset {
    self.comments = [NSMutableArray array];
    self.noMore = NO;
    self.total = 0;
    self.current = DEFAULT_PAGE_NO;
    self.size = DEFAULT_PAGE_SIZE;
}

@end
