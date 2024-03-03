//
//  Author.m
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/18.
//

#import "AuthorModel.h"

@implementation AuthorModel

/**
 *  将属性名换为其他key去字典中取值
 *
 *  @return 字典中的key是属性名，value是从字典中取值用的key
 */
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"authorId" : @"id",
    };
}

@end
