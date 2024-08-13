//
//  RelatedItems.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/8/11.
//
#define CoverImgHeight 44           //封面图片的高度

#import "RelatedItems.h"
#import "ContentUtils.h"
#import "Utils.h"

@interface RelatedItems ()

@property (nonatomic, strong) NSArray <ItemModel *> *itemModels;

@end

@implementation RelatedItems

- (instancetype)init {
    self = [super init];
    if (self) {
        self.myHorzMargin = 0;
        self.myHeight = MyLayoutSize.wrap;
        self.orientation = MyOrientation_Vert;
    }
    return self;
}

- (void)setModels:(NSArray<ItemModel *> *)models {
    self.itemModels = [NSArray arrayWithArray:models];
    [self removeAllSubviews];

    UILabel *sectionTitleLabel = [UILabel new];
    sectionTitleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    sectionTitleLabel.textColor = [UIColor titleTextColor];
    sectionTitleLabel.myBottom = 6;
    sectionTitleLabel.text = @"相关内容";
    sectionTitleLabel.myHorzMargin = ViewHorizonlMargin;
    sectionTitleLabel.myHeight = MyLayoutSize.wrap;

    [self addSubview:sectionTitleLabel];

    for (int i = 0; i < models.count; i++) {
        MyRelativeLayout *itemLayout = [self createItemLayout:models[i] withIndex:i];
        [self addSubview:itemLayout];
    }
}

- (MyRelativeLayout *)createItemLayout:(ItemModel *)model withIndex:(NSInteger)index {
    MyRelativeLayout *itemLayout = [MyRelativeLayout new];
    itemLayout.myHorzMargin = 0;
    itemLayout.myHeight = MyLayoutSize.wrap;
    itemLayout.tag = index;
    itemLayout.highlightedBackgroundColor = [UIColor backgroundColorGray]; //可以设置高亮的背景色用于单击事件
    [itemLayout setTarget:self action:@selector(handleTapped:)];
    itemLayout.topBorderline = [[MyBorderline alloc]initWithColor:[UIColor borderColor] thick:2];
    itemLayout.padding = UIEdgeInsetsMake(12, ViewHorizonlMargin, 12, ViewHorizonlMargin);

    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    titleLabel.textColor = [UIColor titleTextColor];
    titleLabel.text = model.title;
    [titleLabel sizeToFit];
    titleLabel.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
    [itemLayout addSubview:titleLabel];

    UILabel *introLabel = [UILabel new];
    introLabel.font = [UIFont systemFontOfSize:ListMetaFontSize];
    introLabel.textColor = [UIColor descriptionTextColor];
    introLabel.text = [model.introduction isNotBlank] ? model.introduction : @"暂无介绍";
    introLabel.numberOfLines = 1;
    [introLabel sizeToFit];
    introLabel.leftPos.equalTo(itemLayout.leftPos);
    introLabel.rightPos.equalTo(titleLabel.rightPos);
    introLabel.topPos.equalTo(titleLabel.bottomPos).offset(5);
    [itemLayout addSubview:introLabel];

    if (model.itemType != ItemTypeDoc) {
        UILabel *itemTypeLabel = [UILabel new];
        itemTypeLabel.widthSize.equalTo(@(MyLayoutSize.wrap)).add(16).min(40);
        itemTypeLabel.heightSize.equalTo(@(MyLayoutSize.wrap)).add(6);
        itemTypeLabel.textColor = [UIColor systemGrayColor];
        itemTypeLabel.text = [ContentUtils itemTypeDescByItemType:model.itemType];
        itemTypeLabel.font = [UIFont systemFontOfSize:12];
        itemTypeLabel.textAlignment = NSTextAlignmentCenter;

        itemTypeLabel.layer.cornerRadius = 4;
        itemTypeLabel.layer.masksToBounds = YES;
        itemTypeLabel.layer.borderWidth = 1;
        itemTypeLabel.layer.borderColor = [UIColor systemGrayColor].CGColor;
        [itemTypeLabel sizeToFit];

        itemTypeLabel.centerYPos.equalTo(titleLabel.centerYPos);
        itemTypeLabel.leftPos.equalTo(itemLayout.leftPos);

        [itemLayout addSubview:itemTypeLabel];

        titleLabel.leftPos.equalTo(itemTypeLabel.rightPos).offset(8);
    } else {
        titleLabel.leftPos.equalTo(itemLayout.leftPos);
    }

    if (model.itemType == ItemTypeDoc) {
        UIImageView *typeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CoverImgHeight, CoverImgHeight)];
        typeImage.contentMode = UIViewContentModeScaleAspectFill;
        typeImage.rightPos.equalTo(itemLayout.rightPos);
        typeImage.centerYPos.equalTo(itemLayout.centerYPos);
        typeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"doc_file_%@", model.fmt]];
        [itemLayout addSubview:typeImage];
        titleLabel.rightPos.equalTo(typeImage.leftPos).offset(12);
    } else if (model.coverUrl != nil && [[model.coverUrl absoluteString] isNotBlank]) {
        YYAnimatedImageView *coverImage = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, CoverImgHeight, CoverImgHeight)];
        coverImage.contentMode = UIViewContentModeScaleAspectFill;
        coverImage.clipsToBounds = YES;
        [coverImage xy_setLayerBorderColor:[UIColor borderColor]];
        coverImage.layer.borderWidth = 1;
        [coverImage setCornerRadius:6];

        coverImage.rightPos.equalTo(itemLayout.rightPos);
        coverImage.centerYPos.equalTo(itemLayout.centerYPos);
        [coverImage setImageWithURL:model.coverUrl];
        [itemLayout addSubview:coverImage];
        titleLabel.rightPos.equalTo(coverImage.leftPos).offset(12);
    } else {
        titleLabel.rightPos.equalTo(itemLayout.rightPos);
    }

    return itemLayout;
}

- (void)handleTapped:(MyBaseLayout *)sender {
}

@end
