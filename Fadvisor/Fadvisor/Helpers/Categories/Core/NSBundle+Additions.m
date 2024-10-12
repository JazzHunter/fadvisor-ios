//
//  NSBundle+Additions.m
//  FingerAdvisor
//
//  Created by 韩建伟 on 2020/3/30.
//  Copyright © 2020 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//

#import "NSBundle+Additions.h"

@implementation NSBundle (Additions)

+ (NSBundle *)resourceBundle {
    return [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"resource" ofType:@"bundle"]];
}

@end
