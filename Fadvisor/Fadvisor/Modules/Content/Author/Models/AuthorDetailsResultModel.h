//
//  AuthorDetailsResultModel.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/7/2.
//

#import <Foundation/Foundation.h>
#import "AuthorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AuthorDetailsResultModel : NSObject

/** 返回的是什么结果 */
@property (assign, nonatomic) NSInteger resultMode;

/** 获取方式 */
@property (assign, nonatomic) NSInteger acquisitionAction;

/** Info信息 */
@property (nonatomic, strong) AuthorModel *authorModel;

@end

NS_ASSUME_NONNULL_END
