//
//  DocDetailsHeaderView.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/3/23.
//

#define CoverImgHeight 48           //封面图片的高度

#import "DocDetailsHeaderView.h"

#import "Utils.h"

@interface DocDetailsHeaderView ()

@property (nonatomic, strong) ItemModel *itemModel;

@property (nonatomic, strong) UIImageView *typeImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *introLabel;
@property (nonatomic, strong) UILabel *sizeLabel;
@property (nonatomic, strong) UILabel *pageLabel;
@property (nonatomic, strong) UILabel *downloadLabel;

@end

@implementation DocDetailsHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = [UIColor backgroundColor];
    self.myHeight = MyLayoutSize.wrap;

    self.padding = UIEdgeInsetsMake(10 + kDefaultNavBarHeight, ViewVerticalMargin, 10, ViewVerticalMargin);

    _titleLabel = [UILabel new];
    _titleLabel.textColor = [UIColor titleTextColor];
    _titleLabel.font =  [UIFont systemFontOfSize:ListTitleFontSize];
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    _titleLabel.myHorzMargin = 0;
    _titleLabel.myHeight = MyLayoutSize.wrap;
    _titleLabel.leftPos.equalTo(self.leftPos);
    _titleLabel.topPos.equalTo(self.topPos);
    [self addSubview:_titleLabel];

    _typeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CoverImgHeight, CoverImgHeight)];
    _typeImage.contentMode = UIViewContentModeScaleAspectFill;
    _typeImage.leftPos.equalTo(_titleLabel.leftPos);
    _typeImage.topPos.equalTo(_titleLabel.bottomPos).offset(6);
    [self addSubview:_typeImage];

    UIImageView *sizeIcon = [self createIconImage:@"ic_data"];
    sizeIcon.leftPos.equalTo(_typeImage.rightPos).offset(8);
    sizeIcon.centerYPos.equalTo(_typeImage.centerYPos);
    [self addSubview:sizeIcon];

    _sizeLabel = [UILabel new];
    _sizeLabel.font = [UIFont systemFontOfSize:ListMetaFontSize];
    _sizeLabel.textColor = [UIColor metaTextColor];
    _sizeLabel.leftPos.equalTo(sizeIcon.rightPos).offset(4);
    _sizeLabel.centerYPos.equalTo(sizeIcon.centerYPos);
    [self addSubview:_sizeLabel];

    UIImageView *pageIcon = [self createIconImage:@"ic_page"];
    pageIcon.leftPos.equalTo(_sizeLabel.rightPos).offset(8);
    pageIcon.centerYPos.equalTo(_sizeLabel.centerYPos);
    [self addSubview:pageIcon];

    _pageLabel = [UILabel new];
    _pageLabel.font = [UIFont systemFontOfSize:ListMetaFontSize];
    _pageLabel.textColor = [UIColor metaTextColor];
    _pageLabel.leftPos.equalTo(pageIcon.rightPos).offset(4);
    _pageLabel.centerYPos.equalTo(pageIcon.centerYPos);
    [self addSubview:_pageLabel];

    UIImageView *downloadIcon = [self createIconImage:@"ic_download"];
    downloadIcon.leftPos.equalTo(_pageLabel.rightPos).offset(8);
    downloadIcon.centerYPos.equalTo(_pageLabel.centerYPos);
    [self addSubview:downloadIcon];

    _downloadLabel = [UILabel new];
    _downloadLabel.font = [UIFont systemFontOfSize:ListMetaFontSize];
    _downloadLabel.textColor = [UIColor metaTextColor];
    _downloadLabel.leftPos.equalTo(downloadIcon.rightPos).offset(4);
    _downloadLabel.centerYPos.equalTo(downloadIcon.centerYPos);
    [self addSubview:_downloadLabel];

//    _introLabel = [UILabel new];
//    _introLabel.textColor = [UIColor descriptionTextColor];
//    _introLabel.font = [UIFont systemFontOfSize:ListIntroductionFontSize];
//    _introLabel.myHeight = MyLayoutSize.wrap; //如果想让文本的高度是动态的，请在设置明确宽度的情况下将高度设置为自适应。
//    _introLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
//    _introLabel.numberOfLines = 2;
}

- (UIImageView *)createIconImage:(NSString *)iconName {
    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IconImgHeight, IconImgHeight)];
    iconImage.contentMode = UIViewContentModeScaleAspectFit;
    iconImage.image = [UIImage imageNamed:iconName];
    return iconImage;
}

- (void)setModel:(ItemModel *)model {
    _typeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"doc_file_%@", model.fmt]];

//    _titleLabel.text = model.title;
    _titleLabel.text = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod\
    tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,\
    quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo\
    consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse\
    cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non\
    proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

    // TODO
    _sizeLabel.text = [NSString stringWithFormat:@"%@", [Utils formatFromBytes:model.size]];
    [_sizeLabel sizeToFit];

    _pageLabel.text = [NSString stringWithFormat:@"%ld", model.pageSize];
    [_pageLabel sizeToFit];

    _downloadLabel.text = [NSString stringWithFormat:@"%@", [Utils shortedNumberDesc:model.downloadCount]];
    [_downloadLabel sizeToFit];

    [self layoutIfNeeded];

    !self.loadedFinishBlock ? : self.loadedFinishBlock(self.height);
}

@end
