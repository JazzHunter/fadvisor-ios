//
//  MoreItems.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/8/14.
//
#define DocTypeImgHeight 44           // 文档类型图片的高度
#define CoverImgWidth    88        //封面图片的宽度
#define CoverImgHeight   60         //封面图片的高度

#import "MoreItemsView.h"
#import "ContentUtils.h"
#import "MoreItemsService.h"
#import "Utils.h"

@interface MoreItemsView ()

@property (nonatomic, strong) MoreItemsService *moreItemsServices;

@end

@implementation MoreItemsView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.myHorzMargin = 0;
        self.myHeight = MyLayoutSize.wrap;
        self.orientation = MyOrientation_Vert;
        self.inited = NO;
    }
    return self;
}

- (void)loadMoreItemsWithModel:(ItemModel *)model {
    if (self.inited || self.loading) {
        return;
    }

    [self removeAllSubviews];
    UILabel *sectionTitleLabel = [UILabel new];
    sectionTitleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    sectionTitleLabel.textColor = [UIColor titleTextColor];
    sectionTitleLabel.myBottom = 6;
    sectionTitleLabel.text = @"更多推荐";
    sectionTitleLabel.myHorzMargin = ViewHorizonlMargin;
    sectionTitleLabel.myHeight = MyLayoutSize.wrap;

    [self addSubview:sectionTitleLabel];

    Weak(self);
    self.loading = YES;
    [self.moreItemsServices getMoreItems:model.itemType itemId:model.itemId completion:^(NSString *errorMsg) {
        self.loading = NO;
        if (errorMsg) {
            self.hidden = YES;
            return;
        }
        self.inited = YES;
        if (weakself.moreItemsServices.moreItems.count == 0) {
            return;
        }
        for (int i = 0; i < weakself.moreItemsServices.moreItems.count; i++) {
            MyRelativeLayout *itemLayout = [self createItemLayout:weakself.moreItemsServices.moreItems[i] withIndex:i];
            [self addSubview:itemLayout];
        }
    }];
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
    titleLabel.numberOfLines = 1;
    [titleLabel sizeToFit];
    titleLabel.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
    titleLabel.rightPos.equalTo(itemLayout.rightPos);
    titleLabel.topPos.equalTo(itemLayout.topPos);
    [itemLayout addSubview:titleLabel];
    
    UILabel *introLabel = [UILabel new];
    introLabel.font = [UIFont systemFontOfSize:ListIntroductionFontSize];
    introLabel.textColor = [UIColor descriptionTextColor];
    introLabel.text = [model.introduction isNotBlank] ? model.introduction : @"暂无介绍";
    introLabel.numberOfLines = 1;
    [introLabel sizeToFit];
    introLabel.leftPos.equalTo(titleLabel.leftPos);
    introLabel.rightPos.equalTo(itemLayout.rightPos);
    introLabel.topPos.equalTo(titleLabel.bottomPos).offset(5);
    [itemLayout addSubview:introLabel];
    
    MyLinearLayout *metaLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    metaLayout.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
    metaLayout.rightPos.equalTo(itemLayout.rightPos);
    metaLayout.gravity = MyGravity_Vert_Center;
    metaLayout.subviewHSpace = 4;
    [itemLayout addSubview:metaLayout];
    
    UIImageView *authorAvatarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
    authorAvatarView.contentMode = UIViewContentModeScaleAspectFill;
    authorAvatarView.layer.masksToBounds = YES;
    authorAvatarView.layer.cornerRadius = 7;
    if ((model.authors[0].avatar != nil && [[model.authors[0].avatar absoluteString] isNotBlank])) {
        [authorAvatarView setImageWithURL:model.authors[0].avatar];
    } else {
        authorAvatarView.image = [UIImage imageNamed:@"default_author_avatar"];
    }
    [metaLayout addSubview:authorAvatarView];
    
    UILabel *authorNameLabel = [UILabel new];
    authorNameLabel.textColor = [UIColor metaTextColor];
    authorNameLabel.font =  [UIFont systemFontOfSize:ListMetaFontSize];
    authorNameLabel.numberOfLines = 1;
    authorNameLabel.text = model.authors[0].name;
    [authorNameLabel sizeToFit];
    authorNameLabel.widthSize.equalTo(@(MyLayoutSize.wrap)).max(80);
    [metaLayout addSubview:authorNameLabel];
    
    UILabel *bottomInfoLabel = [UILabel new];
    bottomInfoLabel.textColor = [UIColor metaTextColor];
    bottomInfoLabel.font =  [UIFont systemFontOfSize:ListMetaFontSize];
    bottomInfoLabel.text = [NSString stringWithFormat:@"· %@ · %@ 查看", [Utils formatBackendTimeString:model.pubTime], [Utils shortedNumberDesc:model.viewCount]];
    [bottomInfoLabel sizeToFit];
    [metaLayout addSubview:bottomInfoLabel];
    
    if (model.itemType == ItemTypeDoc) {
        UIImageView *typeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DocTypeImgHeight, DocTypeImgHeight)];
        typeImage.contentMode = UIViewContentModeScaleAspectFill;
        typeImage.leftPos.equalTo(itemLayout.leftPos);
        typeImage.centerYPos.equalTo(itemLayout.centerYPos);
        typeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"doc_file_%@", model.fmt]];
        [itemLayout addSubview:typeImage];
        
        titleLabel.leftPos.equalTo(typeImage.rightPos).offset(12);
        
        metaLayout.leftPos.equalTo(itemLayout.leftPos);
        metaLayout.topPos.equalTo(typeImage.bottomPos).offset(5);
    } else if (model.coverUrl != nil && [[model.coverUrl absoluteString] isNotBlank]) {
        YYAnimatedImageView *coverImage = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, CoverImgWidth, CoverImgHeight)];
        coverImage.contentMode = UIViewContentModeScaleAspectFill;
        coverImage.clipsToBounds = YES;
        [coverImage xy_setLayerBorderColor:[UIColor borderColor]];
        coverImage.layer.borderWidth = 1;
        [coverImage setCornerRadius:6];

        coverImage.leftPos.equalTo(itemLayout.leftPos);
        coverImage.centerYPos.equalTo(itemLayout.centerYPos);
        [coverImage setImageWithURL:model.coverUrl];
        [itemLayout addSubview:coverImage];
        
        titleLabel.leftPos.equalTo(coverImage.rightPos).offset(12);
        metaLayout.leftPos.equalTo(titleLabel.leftPos);
        metaLayout.topPos.equalTo(introLabel.bottomPos).offset(5);
    } else {
        titleLabel.leftPos.equalTo(itemLayout.leftPos);
        metaLayout.leftPos.equalTo(titleLabel.leftPos);
        metaLayout.topPos.equalTo(introLabel.bottomPos).offset(5);
    }
    return itemLayout;
}

- (void)handleTapped:(MyBaseLayout *)sender {
}

- (void)reset {
    self.inited = NO;
    self.hidden = NO;
}

#pragma mark - getters & setters

- (MoreItemsService *)moreItemsServices {
    if (_moreItemsServices == nil) {
        _moreItemsServices = [MoreItemsService new];
    }
    return _moreItemsServices;
}

@end
