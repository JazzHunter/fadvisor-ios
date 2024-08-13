//
//  ItemFloatCoverSkeletonTableViewCell.m
//  FingerAdvisor
//
//  Created by 韩建伟 on 2020/3/26.
//  Copyright © 2020 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//

#define CellHeight           320
#define CoverImgWidth        105    //封面图片的宽度
#define CoverImgHeight       85     //封面图片的高度
#define ContactCoverImgWidth 28         //作者头像大小

#import "ItemFloatCoverSkeletonTableViewCell.h"
#import <MyLayout/MyLayout.h>

@interface ItemFloatCoverSkeletonTableViewCell ()

@property (nonatomic, strong, readonly) MyBaseLayout *rootLayout;

@end

@implementation ItemFloatCoverSkeletonTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        [self createUI];
    }
    return self;
}

- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority {
    return [self.rootLayout sizeThatFits:CGSizeMake(targetSize.width - self.safeAreaInsets.left - self.safeAreaInsets.right, targetSize.height)];
}

- (void)createUI {
    _rootLayout = [MyFloatLayout floatLayoutWithOrientation:MyOrientation_Vert];
    _rootLayout.frame = CGRectMake(0, 0, kScreenWidth, 160);
    _rootLayout.cacheEstimatedRect = YES; //这个属性只局限于在UITableViewCell中使用，用来优化tableviewcell的高度自适应的性能，其他地方请不要使用！！！
    _rootLayout.padding = UIEdgeInsetsMake(ViewVerticalMargin, ViewHorizonlMargin, ViewVerticalMargin, ViewHorizonlMargin);
    [self.contentView addSubview:_rootLayout];

    MyLinearLayout *topLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    topLayout.weight = 1;
    topLayout.gravity = MyGravity_Vert_Center | MyGravity_Horz_Between;
    topLayout.myHeight = MyLayoutSize.wrap;
    topLayout.myHorzMargin = 0;
    topLayout.myBottom = 6;
    [_rootLayout addSubview:topLayout];

    //作者头像
    UIImageView *contactAvatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ContactCoverImgWidth, ContactCoverImgWidth)];
    [contactAvatarImageView setCornerRadius:ContactCoverImgWidth / 2];

    [topLayout addSubview:contactAvatarImageView];

    //栏目标签
    UILabel *channelLabel = [[UILabel alloc] init];
    channelLabel.font = [UIFont systemFontOfSize:ListIntroductionFontSize];
    channelLabel.text = @"财务聚焦";
    channelLabel.myRight = 0;
    [channelLabel sizeToFit];
    [topLayout addSubview:channelLabel];

    UIImageView *coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CoverImgWidth, CoverImgHeight)];
    coverImageView.myLeft = 12;
    coverImageView.reverseFloat = YES;
    [coverImageView setCornerRadius:6];
    [_rootLayout addSubview:coverImageView];

    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:ListTitleFontSize];
    titleLabel.myHeight = MyLayoutSize.wrap;
    titleLabel.weight = 1;
    titleLabel.numberOfLines = 2;
    titleLabel.text = @"普华永道中国內地、香港地區、澳门地區及台湾地區成员机构根据各地适用的法律协作运营。整体而言，员工总数超过20,000人，其中包括超过720名合伙人。";
    [titleLabel sizeToFit];
    [_rootLayout addSubview:titleLabel];

    UILabel *introdcutionLabel = [[UILabel alloc]init];
    introdcutionLabel.font = [UIFont systemFontOfSize:ListTitleFontSize];
    introdcutionLabel.myHeight = MyLayoutSize.wrap;
    introdcutionLabel.weight = 1;
    introdcutionLabel.numberOfLines = 1;
    introdcutionLabel.myTop = 8;
    introdcutionLabel.text = @"普华永道中国內地、香港地區、澳门地區及台湾地區成员机构根据各地适用的法律协作运营。整体而言，员工总数超过20,000人，其中包括超过720名合伙人。";
    [introdcutionLabel sizeToFit];
    [_rootLayout addSubview:introdcutionLabel];

    UILabel *metaLabel = [[UILabel alloc]init];
    metaLabel.font = [UIFont systemFontOfSize:ListMetaFontSize];
    metaLabel.myHeight = MyLayoutSize.wrap;
    metaLabel.weight = 1;
    metaLabel.numberOfLines = 1;
    metaLabel.myTop = 8;
    metaLabel.text = @"普华永道中国內地、香港地區、澳门地區及台湾地區成员机构根据各地适用的法律协作运营。整体而言，员工总数超过20,000人，其中包括超过720名合伙人。";
    [metaLabel sizeToFit];
    [_rootLayout addSubview:metaLabel];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 8)];
    lineView.clearFloat = YES;
    lineView.myTop = 12;
    lineView.myLeft = -ViewHorizonlMargin;
    [_rootLayout addSubview:lineView];
}

@end
