//
//  TabAccountBottomCardsView.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/3/15.
//

#import "TabAccountBottomCardsView.h"

@implementation TabAccountBottomCardsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.myHeight = MyLayoutSize.wrap;

        MyRelativeLayout *ageLayout = [self createCardWithTitleText:@"我已使用了" imageName:@"image_tree_color" withArr:NO];
        ageLayout.leftPos.equalTo(self.leftPos);
        ageLayout.topPos.equalTo(self.topPos);
        [self addSubview:ageLayout];
        
        UILabel *ageLabel = [UILabel new];
        ageLabel.text = @"计算中";
        ageLabel.font = [UIFont systemFontOfSize:16];
        [ageLabel sizeToFit];
        ageLabel.textColor = [UIColor descriptionTextColor];
        ageLabel.leftPos.equalTo(ageLayout.leftPos).offset(16);
        ageLabel.bottomPos.equalTo(ageLayout.bottomPos).offset(12);
        [ageLayout addSubview:ageLabel];

        MyRelativeLayout *authorLayout = [self createCardWithTitleText:@"我关注了" imageName:@"image_author_color" withArr:YES];
        authorLayout.rightPos.equalTo(self.rightPos);
        authorLayout.centerYPos.equalTo(ageLayout.centerYPos);
        [self addSubview:authorLayout];
        
        UILabel *authorLabel = [UILabel new];
        authorLabel.text = @"计算中";
        authorLabel.font = [UIFont systemFontOfSize:16];
        [authorLabel sizeToFit];
        authorLabel.textColor = [UIColor descriptionTextColor];
        authorLabel.leftPos.equalTo(authorLayout.leftPos).offset(16);
        authorLabel.bottomPos.equalTo(authorLayout.bottomPos).offset(12);
        [authorLayout addSubview:authorLabel];

        MyRelativeLayout *tagLayout = [self createCardWithTitleText:@"我的标签有" imageName:@"image_tag_color" withArr:YES];
        tagLayout.leftPos.equalTo(self.leftPos);
        tagLayout.topPos.equalTo(ageLayout.bottomPos).offset(6);
        [self addSubview:tagLayout];
        
        UILabel *tagLabel = [UILabel new];
        tagLabel.text = @"计算中";
        tagLabel.font = [UIFont systemFontOfSize:16];
        [tagLabel sizeToFit];
        tagLabel.textColor = [UIColor descriptionTextColor];
        tagLabel.leftPos.equalTo(tagLayout.leftPos).offset(16);
        tagLabel.bottomPos.equalTo(tagLayout.bottomPos).offset(12);
        [tagLayout addSubview:tagLabel];

        MyRelativeLayout *collLayout = [self createCardWithTitleText:@"我订阅的专题" imageName:@"image_book_color" withArr:YES];
        collLayout.rightPos.equalTo(self.rightPos);
        collLayout.centerYPos.equalTo(tagLayout.centerYPos);
        [self addSubview:collLayout];
        
        UILabel *collLabel = [UILabel new];
        collLabel.text = @"计算中";
        collLabel.font = [UIFont systemFontOfSize:16];
        [collLabel sizeToFit];
        collLabel.textColor = [UIColor descriptionTextColor];
        collLabel.leftPos.equalTo(collLayout.leftPos).offset(16);
        collLabel.bottomPos.equalTo(collLayout.bottomPos).offset(12);
        [collLayout addSubview:collLabel];
    }
    return self;
}

- (MyRelativeLayout *)createCardWithTitleText:(NSString *)titleText imageName:(NSString *)imageName withArr:(BOOL)withArr {
    MyRelativeLayout *layout = [MyRelativeLayout new];
    layout.backgroundColor = [UIColor backgroundColor];
    layout.widthSize.equalTo(self.widthSize).multiply(0.5).add(-4);
    layout.myHeight = 100;
    layout.layer.cornerRadius = 12;
    layout.layer.masksToBounds = YES;
    layout.layer.borderWidth = 1;
    [layout xy_setLayerBorderColor:[UIColor borderColor]];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:imageName];
    imageView.rightPos.equalTo(layout).offset(-6);
    imageView.bottomPos.equalTo(layout).offset(-6);
    [layout addSubview:imageView];

    UILabel *titleLabel = [UILabel new];
    titleLabel.text = titleText;
    titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    titleLabel.textColor = [UIColor titleTextColor];
    [titleLabel sizeToFit];
    titleLabel.leftPos.equalTo(layout.leftPos).offset(16);
    titleLabel.topPos.equalTo(layout.topPos).offset(12);
    [layout addSubview:titleLabel];

    if (withArr) {
        UIImageView *rightArr = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        rightArr.image = [[[UIImage imageNamed:@"ic_right_arr"] imageWithTintColor:[UIColor metaTextColor]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        rightArr.contentMode = UIViewContentModeScaleAspectFit;
        rightArr.rightPos.equalTo(layout.rightPos).offset(16);
        rightArr.centerYPos.equalTo(titleLabel.centerYPos);
        [layout addSubview:rightArr];
    }

    return layout;
}


@end
