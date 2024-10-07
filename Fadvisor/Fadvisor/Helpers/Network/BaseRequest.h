//
//  BaseRequest.h
//  FingerAdvisor
//
//  Created by 韩建伟 on 2020/2/21.
//  Copyright © 2020 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//

#import "BaseResponse.h"

@interface BaseRequest : NSObject

- (void)POST:(NSString *)URLString parameters:(id)parameters completion:(void (^)(BaseResponse *response))completion;

- (void)GET:(NSString *)URLString parameters:(id)parameters completion:(void (^)(BaseResponse *response))completion;

- (void)PUT:(NSString *)URLString parameters:(id)parameters completion:(void (^)(BaseResponse *response))completion;

- (void)DELETE:(NSString *)URLString parameters:(id)parameters completion:(void (^)(BaseResponse *response))completion;

- (void)request:(NSString *)method URL:(NSString *)urlString parameters:(id)parameters isToken:(BOOL)isToken completion:(void (^)(BaseResponse *response))completion;

@end
