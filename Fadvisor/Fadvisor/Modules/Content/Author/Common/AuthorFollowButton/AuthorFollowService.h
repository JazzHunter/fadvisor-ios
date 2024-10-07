//
//  AuthorFollowService.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/24.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface AuthorFollowService : BaseRequest

@property (nonatomic, assign, getter = isFollowed) BOOL followed;

@property (nonatomic, assign, getter = isLoading) BOOL loading;

- (void)toggleAuthorFollow:(BOOL)isFollowed authorId:(NSString *)authorId completion:(void (^)(NSString *errorMsg))completion;

@end

NS_ASSUME_NONNULL_END
