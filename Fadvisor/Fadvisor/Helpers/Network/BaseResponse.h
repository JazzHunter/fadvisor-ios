//
//  BaseResponse.h
//  FingerAdvisor
//
//  Created by 韩建伟 on 2020/2/21.
//  Copyright © 2020 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseResponse : NSObject

/** 错误 */
@property (nonatomic, strong) NSError *error;

/** 错误提示 */
@property (nonatomic, copy) NSString *errorMsg;

/** 错误码 */
@property (assign, nonatomic) NSInteger statusCode;

/** 响应头 */
@property (nonatomic, strong) NSMutableDictionary *headers;

/** 响应体 */
@property (nonatomic, strong) id responseObject;

@end

NS_ASSUME_NONNULL_END
