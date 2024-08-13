//
//  Collections.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/8/11.
//

#import "Collections.h"
#import "ImageTextHButton.h"

@interface Collections ()

@property (nonatomic, strong) NSArray <ItemModel *> *collections;

@end

@implementation Collections

- (instancetype)init {
    self = [super init];
    if (self) {
        self.myHeight = MyLayoutSize.wrap;
        self.orientation = MyOrientation_Vert;
        self.gravity = MyGravity_Horz_Fill;
    }
    return self;
}

- (void)setModels:(NSArray <ItemModel *> *)models {
    self.collections = [NSArray arrayWithArray:models];

    [self removeAllSubviews];

    UILabel *sectionTitleLabel = [UILabel new];
    sectionTitleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    sectionTitleLabel.textColor = [UIColor titleTextColor];
    sectionTitleLabel.myBottom = 6;
    sectionTitleLabel.text = @"收录合集";
    sectionTitleLabel.myHorzMargin = 0;
    sectionTitleLabel.myHeight = MyLayoutSize.wrap;

    [self addSubview:sectionTitleLabel];

    MyFlowLayout *contentLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:0];
//    contentLayout.autoArrange = YES;
    contentLayout.subviewHSpace = 12;
    contentLayout.subviewVSpace = 6;
    contentLayout.myHeight = MyLayoutSize.wrap;
    for (int i = 0; i < models.count; i++) {
        [contentLayout addSubview:[self createCollectionLayout:models[i] withIndex:i]];
    }

    [self addSubview:contentLayout];
}

- (UIView *)createCollectionLayout:(ItemModel *)model withIndex:(NSInteger)index {
    MyLinearLayout *collectionLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    collectionLayout.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
    collectionLayout.tag = index;
    collectionLayout.highlightedOpacity = 0.2;
    [collectionLayout setTarget:self action:@selector(handleTapped:)];
    collectionLayout.padding = UIEdgeInsetsMake(4, 8, 4, 8);
    collectionLayout.subviewHSpace = 8;
    collectionLayout.gravity = MyGravity_Vert_Center;
    collectionLayout.backgroundColor = [UIColor backgroundColorGray];
    collectionLayout.layer.cornerRadius = 4;
    collectionLayout.layer.masksToBounds = YES;

    if (model.coverUrl != nil && [[model.coverUrl absoluteString] isNotBlank]) {
        UIImageView *coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        coverImageView.clipsToBounds = YES;
        coverImageView.layer.cornerRadius = 4;
        [coverImageView setImageWithURL:model.coverUrl];

        [collectionLayout addSubview:coverImageView];
    }

    UILabel *titleLabel = [UILabel new];
    titleLabel.text = model.title;
    titleLabel.font = [UIFont systemFontOfSize:ListContentFontSize];
    titleLabel.textColor = [UIColor titleTextColor];
    titleLabel.numberOfLines = 1;
    [titleLabel sizeToFit];

    [collectionLayout addSubview:titleLabel];

    return collectionLayout;
}

- (void)handleTapped:(UIButton *)sender {
    NSLog(@"%@", self.collections[sender.tag].itemId);
}

@end
