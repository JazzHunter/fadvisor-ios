//
//  AuthorUtils.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/6/25.
//

#import "AuthorUtils.h"

@implementation AuthorUtils

+ (NSString *)authorNamesByArray:(NSArray<AuthorModel *> *)authors {
    if (!authors || authors.count == 0) {
        return @"";
    }
    
    
    NSMutableArray *authorNames = [NSMutableArray array];
     
    for (AuthorModel *author in authors) {
        [authorNames addObject:author.name];
    }
     
    return [authorNames componentsJoinedByString:@"、"];

}


@end
