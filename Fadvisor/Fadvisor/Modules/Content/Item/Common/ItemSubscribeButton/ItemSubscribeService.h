//
//  ItemSubscribeService.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/9/28.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface ItemSubscribeService : BaseRequest

@property (nonatomic, assign, getter = isSubscribed) BOOL subscribed;

@property (nonatomic, assign, getter = isLoading) BOOL loading;

- (void)toggleItemSubscribe:(BOOL)isSubscribed authorId:(NSString *)itemId completion:(void (^)(NSString *errorMsg))completion;

@end

NS_ASSUME_NONNULL_END
