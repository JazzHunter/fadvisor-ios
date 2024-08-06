//
//  AuthorDetailsResultModel.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/7/2.
//

#import "AuthorDetailsResultModel.h"

@implementation AuthorDetailsResultModel

/**
 *  将属性名换为其他key去字典中取值
 *
 *  @return 字典中的key是属性名，value是从字典中取值用的key
 */
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"authorModel": @"info",
    };
}

@end
