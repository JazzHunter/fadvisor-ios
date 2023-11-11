//
//  BaseResponse.m
//  FingerAdvisor
//
//  Created by 韩建伟 on 2020/2/21.
//  Copyright © 2020 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//

#import "BaseResponse.h"

@implementation BaseResponse

- (NSString *)description {
    return [NSString stringWithFormat:@"\n状态码: %zd,\n错误: %@,\n响应头: %@,\n响应体: %@", self.statusCode, self.error, self.headers, self.responseObject];
}

- (void)setError:(NSError *)error {
    _error = error;
    self.statusCode = error.code;
    self.errorMsg = error.localizedDescription;
}

@end
