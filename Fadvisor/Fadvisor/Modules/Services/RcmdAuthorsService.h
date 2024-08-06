//
//  RcmdAuthorsService.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/8/3.
//

#import "BaseRequest.h"
#import "AuthorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RcmdAuthorsService : BaseRequest

/** 推荐 Authors 数组 */
@property (nonatomic, assign) BOOL inited;

/** 推荐 Authors 数组 */
@property (nonatomic, strong) NSMutableArray<AuthorModel *> *rcmdAuthors;

/** 获取推荐作者 */
- (void)getRcmdAuthors:(void (^)(NSString *errorMsg))completion;

/** 重置 */
- (void)reset;

@end

NS_ASSUME_NONNULL_END
