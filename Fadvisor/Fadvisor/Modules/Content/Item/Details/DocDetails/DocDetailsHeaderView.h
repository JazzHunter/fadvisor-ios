//
//  DocDetailsHeaderView.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/3/23.
//

#import <Foundation/Foundation.h>
#import <MyLayout/MyLayout.h>
#import "ItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DocDetailsHeaderView : MyRelativeLayout

- (instancetype)initWithFrame:(CGRect)frame;

- (void)setModel:(ItemModel *)itemModel;

@property (nonatomic, copy) void (^ loadedFinishBlock)(CGFloat);

@end

NS_ASSUME_NONNULL_END
