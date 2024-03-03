//
//  CommentSet.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/25.
//

#import "CommentSetModel.h"

@implementation CommentSetModel

/**
 *  数组中需要转换的模型类
 *
 *  @return 字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）
 */
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"replies": [CommentModel class],
    };
}


@end
