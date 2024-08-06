//
//  AuthorSection.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/24.
//

#import <MyLayout/MyLayout.h>
#import "AuthorModel.h"


@interface AuthorSection : MyLinearLayout

- (void)setModels:(NSArray<AuthorModel *> *)models;
- (void)setShowCount:(BOOL)isShowCount;

@end
