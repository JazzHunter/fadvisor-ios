//
//  ColmunDetailsHeaderView.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/9/28.
//

#import <MyLayout/MyLayout.h>
#import "ItemModel.h"
#import "ColumnDetailsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ColumnDetailsHeaderView : MyRelativeLayout

- (instancetype)initWithFrame:(CGRect)frame;

- (void)setModel:(ItemModel *)itemModel details:(ColumnDetailsModel *)detailsModel;

@property (nonatomic, copy) void (^ loadedFinishBlock)(CGFloat);

@end

NS_ASSUME_NONNULL_END
