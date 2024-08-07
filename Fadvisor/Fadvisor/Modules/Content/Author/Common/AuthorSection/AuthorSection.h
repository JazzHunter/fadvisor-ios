//
//  AuthorSection.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/8/7.
//

#import <MyLayout/MyLayout.h>
#import "AuthorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AuthorSection : MyRelativeLayout

- (void)setModels:(NSArray< AuthorModel *> *)models;

@end

NS_ASSUME_NONNULL_END
