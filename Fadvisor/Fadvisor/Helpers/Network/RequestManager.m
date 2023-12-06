//
//  RequestMananger.m
//  FingerAdvisor
//
//  Created by 韩建伟 on 2020/2/21.
//  Copyright © 2020 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//

#import "RequestManager.h"
#import "BaseResponse.h"
#import "LocalDataStorage.h"
#import "KeyCHainHelper.h"

#define ClientIdKey   @"Client_Id"                                        // 平台Key
#define ClientIdValue @"ios"                                              // 平台Value
#define AppVersionKey @"App_Version"                                      // 版本Key

@implementation RequestManager

// Post
- (void)POST:(NSString *)urlString parameters:(id)parameters completion:(void (^)(BaseResponse *))completion {
    [self request:@"POST" URL:urlString parameters:parameters completion:completion];
}

//Get
- (void)GET:(NSString *)urlString parameters:(id)parameters completion:(void (^)(BaseResponse *))completion {
    [self request:@"GET" URL:urlString parameters:parameters completion:completion];
}

#pragma mark - Post & Get
- (void)request:(NSString *)method URL:(NSString *)urlString parameters:(id)parameters completion:(void (^)(BaseResponse *response))completion {
    if (self.isLocal) {
        [self requestLocal:urlString completion:completion];
        return;
    }

    if (self.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        BaseResponse *response = [BaseResponse new];
        response.error = [NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:nil];
        response.errorMsg = @"网络似乎不太理想……";
        completion(response);
        return;
    }

    void (^ success)(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) = ^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        [self wrapperTask:task responseObject:responseObject error:nil completion:completion];
    };

    void (^ failure)(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) = ^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        [self wrapperTask:task responseObject:nil error:error completion:completion];
    };

    if ([method isEqualToString:@"POST"]) {
        [self POST:urlString parameters:parameters progress:nil success:success failure:failure];
    }

    if ([method isEqualToString:@"GET"]) {
        [self GET:urlString parameters:parameters progress:nil success:success failure:failure];
    }
}

#pragma mark - 加载本地数据
static NSString *jsonFileDirectory = @"LocalJsons";
- (void)requestLocal:(NSString *)urlString completion:(void (^)(BaseResponse *response))completion {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSError *jsonError = nil;
        id responseObj = [NSJSONSerialization JSONObjectWithData:[LocalDataStorage cacheForKey:urlString] options:NSJSONReadingMutableContainers error:&jsonError];
        [self wrapperTask:nil responseObject:responseObj error:jsonError completion:completion];
    });
}

#pragma mark - 处理数据
- (void)wrapperTask:(NSURLSessionDataTask *)task responseObject:(id)responseObject error:(NSError *)error completion:(void (^)(BaseResponse *response))completion {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BaseResponse *response = [self convertTask:task responseObject:responseObject error:error];

    #if DEBUG
//        [self LogResponse:task.currentRequest.URL.absoluteString response:response];
    #endif
        dispatch_async(dispatch_get_main_queue(), ^{
            !completion ? : completion(response);
        });
    });
}

#pragma mark - 包装返回的数据
- (BaseResponse *)convertTask:(NSURLSessionDataTask *)task responseObject:(id)responseObject error:(NSError *)error {
    BaseResponse *response = [BaseResponse new];
    
    // ⚠️ 这里看一下，errorMsg 应该更好
    if (error) {
        response.error = error;
        return response;
    }
    response.statusCode = [responseObject[@"code"] integerValue];
    switch (response.statusCode) {
        case RequestManagerStatusCodeOK:
            response.responseObject = responseObject[@"data"];
            break;
        default:
            response.error = [NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:nil];
            response.errorMsg = responseObject[@"message"];
            break;
    }
    if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *HTTPURLResponse = (NSHTTPURLResponse *)task.response;
        response.headers = HTTPURLResponse.allHeaderFields.mutableCopy;
    }

    return response;
}

#pragma mark - 打印返回日志
- (void)LogResponse:(NSString *)urlString response:(BaseResponse *)response {
    NSLog(@"[%@]---%@\n", urlString, response);
}

#pragma mark - 上传文件
//  data 图片对应的二进制数据
//  name 服务端需要参数
//  fileName 图片对应名字,一般服务不会使用,因为服务端会直接根据你上传的图片随机产生一个唯一的图片名字
//  mimeType 资源类型
//  不确定参数类型 可以这个 octet-stream 类型, 二进制流
- (void)upload:(NSString *)urlString parameters:(id)parameters formDataBlock:(NSDictionary<NSData *, DataName *> * (^)(id<AFMultipartFormData> formData, NSMutableDictionary<NSData *, DataName *> *needFillDataDict))formDataBlock progress:(void (^)(NSProgress *progress))progress completion:(void (^)(BaseResponse *response))completion {
    static NSString *mineType = @"application/octet-stream";

    [self POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSMutableDictionary *needFillDataDict = [NSMutableDictionary dictionary];
        NSDictionary *datas = !formDataBlock ? nil : formDataBlock(formData, needFillDataDict);

        if (datas) {
            [datas enumerateKeysAndObjectsUsingBlock:^(NSData *_Nonnull data, DataName *_Nonnull name, BOOL *_Nonnull stop) {
                [formData appendPartWithFileData:data name:name fileName:@"random" mimeType:mineType];
            }];
        }
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
                           !progress ? : progress(uploadProgress);
                       });
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        [self wrapperTask:task responseObject:responseObject error:nil completion:completion];
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        [self wrapperTask:task responseObject:nil error:error completion:completion];
    }];
}

#pragma mark - 初始化设置
- (void)configSettings {
    //设置可接收的数据类型
    NSMutableSet *acceptableContentTypes = [NSMutableSet setWithSet:self.responseSerializer.acceptableContentTypes];
    [acceptableContentTypes addObjectsFromArray:@[@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", @"application/xml", @"text/xml", @"*/*", @"application/x-plist"]];
    self.responseSerializer.acceptableContentTypes = [acceptableContentTypes copy];
    [self.requestSerializer setValue:ClientIdValue forHTTPHeaderField:ClientIdKey];

    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    [self.requestSerializer setValue:[infoDictionary objectForKey:@"CFBundleShortVersionString"] forHTTPHeaderField:AppVersionKey];

    [self.requestSerializer setValue:[KeyChainHelper getToken] forHTTPHeaderField:@"Authorization"];

    //记录网络状态
    [self.reachabilityManager startMonitoring];

    //自定义处理数据
    self.responseFormat = ^BaseResponse *(BaseResponse *response) {
        return response;
    };

    AFSecurityPolicy *securityPolicy =  [AFSecurityPolicy defaultPolicy];
    // 客户端是否信任非法证书
    securityPolicy.allowInvalidCertificates = YES;
    // 是否在证书域字段中验证域名
    securityPolicy.validatesDomainName = NO;
    self.securityPolicy = securityPolicy;
}

#pragma mark - 处理返回序列化
- (void)setResponseSerializer:(AFHTTPResponseSerializer<AFURLResponseSerialization> *)responseSerializer
{
    [super setResponseSerializer:responseSerializer];

    if ([responseSerializer isKindOfClass:[AFJSONResponseSerializer class]]) {
        AFJSONResponseSerializer *JSONserializer = (AFJSONResponseSerializer *)responseSerializer;
        JSONserializer.removesKeysWithNullValues = YES;
        /*
        NSJSONReadingMutableContainers = 转换出来的对象是可变数组或者可变字典
        NSJSONReadingMutableLeaves = 转换呼出来的OC对象中的字符串是可变的\注意：iOS7之后无效 bug
        NSJSONReadingAllowFragments = 如果服务器返回的JSON数据，不是标准的JSON，那么就必须使用这个值，否则无法解析
     */
        JSONserializer.readingOptions = NSJSONReadingMutableContainers;
    }
}

#pragma mark - 单例和设置
+ (instancetype)manager {
    RequestManager *manager = [[[self class] alloc] initWithBaseURL:[NSURL URLWithString:BaseURL]];
    [manager configSettings];
    return manager;
}

static RequestManager *_instance = nil;
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [self manager];
    });
    return _instance;
}

@end
