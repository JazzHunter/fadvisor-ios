//
//  ItemDetailsResultModel.m
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/24.
//

#import "ItemDetailsResultModel.h"

@implementation ItemDetailsResultModel

/**
 *  将属性名换为其他key去字典中取值
 *
 *  @return 字典中的key是属性名，value是从字典中取值用的key
 */
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"itemModel": @"info",
    };
}

/**
 *  数组中需要转换的模型类
 *
 *  @return 字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）
 */
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"relatedItems": [ItemModel class],
        @"attachments": [ItemModel class],
        @"tags": [TagModel class],
        @"collections": [ItemModel class],
        @"authors": [AuthorModel class]
    };
}

@end
