//
//  AuthorDetailsModel.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/7/2.
//

#import "AuthorDetailsModel.h"

@implementation AuthorDetailsModel

/**
 *  将属性名换为其他key去字典中取值
 *
 *  @return 字典中的key是属性名，value是从字典中取值用的key
 */
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"authorId": @"id",
    };
}

/**
 *  数组中需要转换的模型类
 *
 *  @return 字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）
 */
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"contacts": [UserModel class],
        @"relatedAuthors": [AuthorModel class],
        @"tags": [TagModel class]
    };
}

@end
