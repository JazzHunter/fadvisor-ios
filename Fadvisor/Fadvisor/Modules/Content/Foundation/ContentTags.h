//
//  ContentTags.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/8/11.
//

#import <MyLayout/MyLayout.h>
#import "TagModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContentTags : MyFlowLayout

-(void)setModels:(NSArray <TagModel *> *)models;

@end

NS_ASSUME_NONNULL_END
