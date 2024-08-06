//
//  AuthorDetailsHeaderView.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/7/3.
//

#import <MyLayout/MyLayout.h>

#import "AuthorModel.h"
#import "AuthorDetailsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AuthorDetailsHeaderView : MyRelativeLayout

- (instancetype)initWithFrame:(CGRect)frame;

- (void)setModel:(AuthorModel *)authorModel details:(AuthorDetailsModel *)detailsModel;

@property (nonatomic, copy) void (^ loadedFinishBlock)(CGFloat);

@end

NS_ASSUME_NONNULL_END
