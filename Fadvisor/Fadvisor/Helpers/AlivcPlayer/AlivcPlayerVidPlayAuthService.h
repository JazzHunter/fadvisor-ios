//
//  AlivcPlayerVidPlayAuthService.h
//  Fadvisor
//
//  Created by 韩建伟 on 2023/12/23.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface AlivcPlayerVidPlayAuthService : BaseRequest

- (void)getVidPlayAuth:(NSString *)videoId completion:(void (^)(NSString *errorMsg, NSString *playAuth))completion;

@end

NS_ASSUME_NONNULL_END
