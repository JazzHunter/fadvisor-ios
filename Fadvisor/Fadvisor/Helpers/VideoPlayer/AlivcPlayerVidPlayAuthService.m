//
//  AlivcPlayerVidPlayAuth.m
//  Fadvisor
//
//  Created by 韩建伟 on 2023/12/23.
//

#import "AlivcPlayerVidPlayAuthService.h"

@implementation AlivcPlayerVidPlayAuthService

- (void)getVidPlayAuth:(NSString *)videoId completion:(void (^)(NSString *errorMsg, NSString *playAuth))completion {
    NSString *vidPlayAuthAPI =  [NSString stringWithFormat:@"/knwlres/media/play-auth/%@", videoId];
    [self GET:vidPlayAuthAPI parameters:nil completion:^(BaseResponse *response) {
        // 数据是空的时候不是字典了
        if (![response.responseObject isKindOfClass:[NSDictionary class]] || !response.responseObject || response.error || !response.responseObject[@"playAuth"]) {
            completion(response.errorMsg, nil);
            return;
        }

        completion(nil, response.responseObject[@"playAuth"]);
    }];
}

@end
