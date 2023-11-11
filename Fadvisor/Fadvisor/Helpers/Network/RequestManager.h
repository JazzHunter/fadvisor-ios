//
//  RequestMananger.h
//  FingerAdvisor
//
//  Created by 韩建伟 on 2020/2/21.
//  Copyright © 2020 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "BaseResponse.h"

typedef NSString DataName;

typedef enum : NSInteger {
    // 自定义错误码
    RequestManagerStatusCodeOK = 1000,
//    RequestManagerUserInfoExpired = 123123;
} RequestManagerStatusCode;

typedef BaseResponse *(^ResponseFormat)(BaseResponse *response);

@interface RequestManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

//本地数据模式
@property (assign, nonatomic) BOOL isLocal;

//预处理返回的数据
@property (copy, nonatomic) ResponseFormat responseFormat;

- (void)POST:(NSString *)urlString parameters:(id)parameters completion:(void (^)(BaseResponse *response))completion;

- (void)GET:(NSString *)urlString parameters:(id)parameters completion:(void (^)(BaseResponse *response))completion;

/*
  上传
   data 数据对应的二进制数据
   LMJDataName data对应的参数
 */
- (void)upload:(NSString *)urlString parameters:(id)parameters formDataBlock:(NSDictionary<NSData *, DataName *> *(^)(id<AFMultipartFormData> formData, NSMutableDictionary<NSData *, DataName *> *needFillDataDict))formDataBlock progress:(void (^)(NSProgress *progress))progress completion:(void (^)(BaseResponse *response))completion;

@end
