//
//  AuthorSection.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/24.
//

#import <MyLayout/MyLayout.h>
#import "AuthorModel.h"

@interface AuthorInList : MyRelativeLayout

- (void)setModel:(AuthorModel *)model;
- (void)setShowCount:(BOOL)isShowCount;

@end
