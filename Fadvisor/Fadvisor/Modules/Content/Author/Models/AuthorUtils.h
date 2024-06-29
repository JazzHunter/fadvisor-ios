//
//  AuthorUtils.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/6/25.
//

#import <Foundation/Foundation.h>
#import "AuthorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AuthorUtils : NSObject


+ (NSString *)authorNamesByArray:(NSArray<AuthorModel *> *)authors;

@end

NS_ASSUME_NONNULL_END
