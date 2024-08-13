//
//  ContentAttachments.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/8/11.
//

#import "Attachments.h"
#import "Utils.h"
#import "ImageButton.h"

@interface Attachments ()

@property (nonatomic, strong) NSArray <ItemModel *> *attachments;

@end

@implementation Attachments

- (instancetype)init {
    self = [super init];
    if (self) {
        self.myHeight = MyLayoutSize.wrap;
        self.subviewVSpace = 6;
    }
    return self;
}

- (void)setModels:(NSArray<ItemModel *> *)models {
    self.attachments = [NSArray arrayWithArray:models];
    [self removeAllSubviews];

    MyRelativeLayout *sectionTitleLayout = [MyRelativeLayout new];
    sectionTitleLayout.myHorzMargin = 0;
    sectionTitleLayout.myHeight = MyLayoutSize.wrap;
    [self addSubview:sectionTitleLayout];

    UILabel *sectionTitleLabel = [UILabel new];
    sectionTitleLabel.font = [UIFont systemFontOfSize:13];
    sectionTitleLabel.textColor = [UIColor descriptionTextColor];
    sectionTitleLabel.text = @"以下是文档附件";
    sectionTitleLabel.backgroundColor = [UIColor backgroundColor];
    sectionTitleLabel.widthSize.equalTo(@(MyLayoutSize.wrap)).add(16);
    sectionTitleLabel.heightSize.equalTo(@(MyLayoutSize.wrap)).add(6);
    sectionTitleLabel.leftPos.equalTo(sectionTitleLayout.leftPos).offset(16);
    sectionTitleLabel.centerYPos.equalTo(sectionTitleLayout.centerYPos);
    sectionTitleLabel.textAlignment = NSTextAlignmentCenter;
    [sectionTitleLayout addSubview:sectionTitleLabel];

    UIView *borderLine = [UIView new];
    borderLine.myHorzMargin = 0;
    borderLine.myHeight = 1;
    borderLine.backgroundColor = [UIColor descriptionTextColor];
    borderLine.centerYPos.equalTo(sectionTitleLabel.centerYPos);
    [sectionTitleLayout addSubview:borderLine];

    [sectionTitleLayout bringSubviewToFront:sectionTitleLabel];

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
    itemLayout.highlightedOpacity = 0.2;
    [itemLayout setTarget:self action:@selector(handleTapped:)];
    itemLayout.padding = UIEdgeInsetsMake(20, 24, 20, 24);
    itemLayout.backgroundColor = [self colorByFormatType:model.formatType];

    UIImageView *typeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 42, 42)];
    typeImage.contentMode = UIViewContentModeScaleAspectFill;
    typeImage.leftPos.equalTo(itemLayout.leftPos);
    typeImage.centerYPos.equalTo(itemLayout.centerYPos);
    typeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"doc_icon_%@_white", [self iconNameByFormatType:model.formatType]]];
    [itemLayout addSubview:typeImage];

    MyLinearLayout *contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    contentLayout.subviewVSpace = 5;

    contentLayout.leftPos.equalTo(typeImage.rightPos).offset(12);
    contentLayout.rightPos.equalTo(itemLayout.rightPos);
    contentLayout.myHeight = MyLayoutSize.wrap;

    [itemLayout addSubview:contentLayout];

    UILabel *titleLabel = [UILabel new];
    titleLabel.text = model.title;
    titleLabel.font = [UIFont systemFontOfSize:ListTitleFontSize weight:UIFontWeightSemibold];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.myHorzMargin = 0;
    titleLabel.myHeight = MyLayoutSize.wrap;
    titleLabel.numberOfLines = 1;
    [contentLayout addSubview:titleLabel];

    UILabel *descLabel = [UILabel new];
    descLabel.text = [NSString stringWithFormat:@"%@文件 · %@ · %ld 页", model.fmt,  [Utils formatFromBytes:model.size], model.pageSize];
    descLabel.font = [UIFont systemFontOfSize:ListMetaFontSize];
    descLabel.textColor = [UIColor whiteColor];
    descLabel.myHorzMargin = 0;
    descLabel.myHeight = MyLayoutSize.wrap;
    descLabel.numberOfLines = 1;
    [contentLayout addSubview:descLabel];
    
    ImageButton *downloadButton = [[ImageButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32) imageName:@"ic_download_white"];
    downloadButton.rightPos.equalTo(itemLayout.rightPos).offset(-16);
    downloadButton.bottomPos.equalTo(itemLayout.bottomPos).offset(-16);
    
    [itemLayout addSubview:downloadButton];

    return itemLayout;
}

- (UIColor *)colorByFormatType:(NSString *)formatType {
    if ([formatType isEqualToString:@"PDF"]) {
        return [UIColor colorFromHexString:@"E20001"];
    }
    if ([formatType isEqualToString:@"WORDS"]) {
        return [UIColor colorFromHexString:@"25579C"];
    }
    if ([formatType isEqualToString:@"SLIDES"]) {
        return [UIColor colorFromHexString:@"D34829"];
    }
    if ([formatType isEqualToString:@"CELLS"]) {
        return [UIColor colorFromHexString:@"1C7346"];
    }
    
    return [UIColor colorFromHexString:@"7d7d7d"];
}

- (NSString *)iconNameByFormatType:(NSString *)formatType {
    if ([formatType isEqualToString:@"PDF"]) {
        return @"pdf";
    }
    if ([formatType isEqualToString:@"WORDS"]) {
        return @"word";
    }
    if ([formatType isEqualToString:@"SLIDES"]) {
        return @"powerpoint";
    }
    if ([formatType isEqualToString:@"CELLS"]) {
        return @"excel";
    }
    
    return @"unknown";
}


- (void)handleTapped:(MyBaseLayout *)sender {
}

@end
