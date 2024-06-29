//
//  DocFloatTypeTableViewCell.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/6/25.
//

#define CoverImgHeight       48     //封面图片的高度
#define SnapshotImgHeight       64     //封面图片的高度

#import "DocFloatTypeTableViewCell.h"
#import "AuthorUtils.h"
#import "Utils.h"

@interface DocFloatTypeTableViewCell()

@property (nonatomic, strong) UIImageView *typeImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *authorNamesLabel;

@property (nonatomic, strong) UILabel *sizeLabel;
@property (nonatomic, strong) UILabel *pageLabel;
@property (nonatomic, strong) UILabel *downloadLabel;

@property (nonatomic, strong) UILabel *introLabel;

@property (nonatomic, strong) UIScrollView *snapshotScrollView;
@property (nonatomic, strong) MyLinearLayout *snapshotLayout;

@end

@implementation DocFloatTypeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        self.backgroundColor = [UIColor backgroundColor];
        
        [self createLayout];
        //如果是代码实现autolayout的话必须要将translatesAutoresizingMaskIntoConstraints 设置为NO。
        _rootLayout.translatesAutoresizingMaskIntoConstraints = NO;

        //设置布局视图的autolayout约束，这里是用iOS9提供的约束设置方法，您也可以用低级版本设置，以及用masonry来进行设置。
        [_rootLayout.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor].active = YES;
        [_rootLayout.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
        //目前MyLayout和AutoLayout相结合并且高度根据宽度自适应时只能通过明确设置宽度约束，暂时不支持同时设置左右约束来确定宽度的能力。
        [_rootLayout.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor].active = YES;

        //这句代码很关键，表明self.contentView的高度随着子视图_rootLayout的高度自适应。
        [self.contentView.bottomAnchor constraintEqualToAnchor:_rootLayout.bottomAnchor constant:0].active = YES;
    }

    return self;
}

- (void)setModel:(ItemModel *)model {
    _typeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"doc_%@", model.fmt]];
    
    _titleLabel.text = model.title;

    // TODO
    _sizeLabel.text = [NSString stringWithFormat:@"%@", [Utils formatFromBytes:model.size]];
    [_sizeLabel sizeToFit];
    
    _pageLabel.text = [NSString stringWithFormat:@"%ld", model.pageSize];
    [_pageLabel sizeToFit];
    
    _downloadLabel.text = [NSString stringWithFormat:@"%@", [Utils shortedNumberDesc:model.downloadCount]];
    [_downloadLabel sizeToFit];
    
    _authorNamesLabel.text = [AuthorUtils authorNamesByArray:model.authors];
    
    if ([model.introduction isNotEmpty]) {
        _introLabel.visibility = MyVisibility_Invisible;
    } else {
        _introLabel.visibility = MyVisibility_Visible;
        _introLabel.text = model.introduction;
    }
    
    [_snapshotLayout removeAllSubviews];
    if ([model.snapshots isNotEmpty]) {
        _snapshotScrollView.visibility = MyVisibility_Invisible;
    } else {
        _snapshotScrollView.visibility = MyVisibility_Visible;
        NSArray<NSString *> *snapshotArr = [model.snapshots componentsSeparatedByString:@","];
        
        [snapshotArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == snapshotArr.count - 1 && snapshotArr.count < model.pageSize) {
                UIView *snapshotWithMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SnapshotImgHeight, SnapshotImgHeight)];
                snapshotWithMaskView.clipsToBounds = YES;
                [snapshotWithMaskView setCornerRadius:4];

                [snapshotWithMaskView addSubview:[self createSnapshotImageView:obj]];
                
                MyRelativeLayout *maskLayout = [[MyRelativeLayout alloc] initWithFrame:CGRectMake(0, 0, SnapshotImgHeight, SnapshotImgHeight)];
                [snapshotWithMaskView addSubview:maskLayout];
                
                UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
                blurView.alpha = 0.7; // 控制模糊程度
                blurView.myMargin = 0;
                blurView.leftPos.equalTo(maskLayout.leftPos);
                blurView.topPos.equalTo(maskLayout.topPos);
                [maskLayout addSubview:blurView];
                
                UILabel *leftPagesLabel = [UILabel new];
                leftPagesLabel.textColor = [UIColor whiteColor];
                leftPagesLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
                leftPagesLabel.centerXPos.equalTo(maskLayout.centerXPos);
                leftPagesLabel.centerYPos.equalTo(maskLayout.centerYPos);
                
                [maskLayout addSubview:leftPagesLabel];
                
                leftPagesLabel.text = [NSString stringWithFormat:@"+%ld", model.pageSize - snapshotArr.count] ;
                [leftPagesLabel sizeToFit];
                
                [_snapshotLayout addSubview:snapshotWithMaskView];
                
            } else {
                [_snapshotLayout addSubview:[self createSnapshotImageView:obj]];
            }
              
        }];
    }
}

- (UIImageView *) createSnapshotImageView:(NSString *)url {
    UIImageView *snapshotView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SnapshotImgHeight, SnapshotImgHeight)];
    snapshotView.contentMode = UIViewContentModeScaleAspectFill;
    snapshotView.clipsToBounds = YES;
    [snapshotView xy_setLayerBorderColor:[UIColor borderColor]];
    snapshotView.layer.borderWidth = 1;
    [snapshotView setCornerRadius:4];
    
    [snapshotView setImageWithURL:[NSURL URLWithString:url]];
    return snapshotView;
}

#pragma mark -- Layout Construction e

//用线性布局来实现UI界面
- (void)createLayout
{
    _rootLayout = [MyRelativeLayout new];
    _rootLayout.padding = UIEdgeInsetsMake(10, 16, 10, 16);

    //这个属性只局限于在UITableViewCell中使用，用来优化tableviewcell的高度自适应的性能，其他地方请不要使用！！！
    _rootLayout.cacheEstimatedRect = YES;
    _rootLayout.heightSize.equalTo(@(MyLayoutSize.wrap));
    _rootLayout.widthSize.equalTo(nil);
    [self.contentView addSubview:_rootLayout];

    _titleLabel = [UILabel new];
    _titleLabel.textColor = [UIColor titleTextColor];
    _titleLabel.font =  [UIFont systemFontOfSize:ListTitleFontSize];
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    _titleLabel.myLeading = _titleLabel.myTrailing = 0; //垂直线性布局里面如果同时设置了左右边距则能确定子视图的宽度，这里表示宽度和父视图相等。
    _titleLabel.myHeight = MyLayoutSize.wrap; //如果想让文本的高度是动态的，请在设置明确宽度的情况下将高度设置为自适应。
    _titleLabel.numberOfLines = 2;
    _titleLabel.leftPos.equalTo(_rootLayout.leftPos);
    _titleLabel.topPos.equalTo(_rootLayout.topPos);
    [_rootLayout addSubview:_titleLabel];

    _typeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CoverImgHeight, CoverImgHeight)];
    _typeImage.contentMode = UIViewContentModeScaleAspectFill;
    _typeImage.leftPos.equalTo(_titleLabel.leftPos);
    _typeImage.topPos.equalTo(_titleLabel.bottomPos).offset(5);
    [_rootLayout addSubview:_typeImage];
    
    MyRelativeLayout *contentLayout = [MyRelativeLayout new];
    contentLayout.myHorzMargin = 0;
    contentLayout.heightSize.equalTo(@(MyLayoutSize.wrap));
    contentLayout.leftPos.equalTo(_typeImage.rightPos).offset(8);
    contentLayout.centerYPos.equalTo(_typeImage.centerYPos);
    [_rootLayout addSubview:contentLayout];
    
    _authorNamesLabel = [UILabel new];
    _authorNamesLabel.font = [UIFont systemFontOfSize:ListMetaFontSize];
    _authorNamesLabel.myLeading = _titleLabel.myTrailing = 0; //垂直线性布局里面如果同时设置了左右边距则能确定子视图的宽度，这里表示宽度和父视图相等。
    _authorNamesLabel.myHeight = MyLayoutSize.wrap; //如果想让文本的高度是动态的，请在设置明确宽度的情况下将高度设置为自适应。
    _authorNamesLabel.textColor = [UIColor metaTextColor];
    _authorNamesLabel.leftPos.equalTo(contentLayout.leftPos);
    _authorNamesLabel.topPos.equalTo(contentLayout.topPos);
    [contentLayout addSubview:_authorNamesLabel];
    
    UIImageView *sizeIcon = [self createIconImage:@"ic_data"];
    sizeIcon.leftPos.equalTo(_authorNamesLabel.leftPos);
    sizeIcon.topPos.equalTo(_authorNamesLabel.bottomPos).offset(5);
    [contentLayout addSubview:sizeIcon];
    
    _sizeLabel = [UILabel new];
    _sizeLabel.font = [UIFont systemFontOfSize:ListMetaFontSize];
    _sizeLabel.textColor = [UIColor metaTextColor];
    _sizeLabel.leftPos.equalTo(sizeIcon.rightPos).offset(4);
    _sizeLabel.centerYPos.equalTo(sizeIcon.centerYPos);
    [contentLayout addSubview:_sizeLabel];
    
    UIImageView *pageIcon = [self createIconImage:@"ic_page"];
    pageIcon.leftPos.equalTo(_sizeLabel.rightPos).offset(8);
    pageIcon.centerYPos.equalTo(_sizeLabel.centerYPos);
    [contentLayout addSubview:pageIcon];
    
    _pageLabel = [UILabel new];
    _pageLabel.font = [UIFont systemFontOfSize:ListMetaFontSize];
    _pageLabel.textColor = [UIColor metaTextColor];
    _pageLabel.leftPos.equalTo(pageIcon.rightPos).offset(4);
    _pageLabel.centerYPos.equalTo(pageIcon.centerYPos);
    [contentLayout addSubview:_pageLabel];
    
    UIImageView *downloadIcon = [self createIconImage:@"ic_download"];
    downloadIcon.leftPos.equalTo(_pageLabel.rightPos).offset(8);
    downloadIcon.centerYPos.equalTo(_pageLabel.centerYPos);
    [contentLayout addSubview:downloadIcon];
    
    _downloadLabel = [UILabel new];
    _downloadLabel.font = [UIFont systemFontOfSize:ListMetaFontSize];
    _downloadLabel.textColor = [UIColor metaTextColor];
    _downloadLabel.leftPos.equalTo(downloadIcon.rightPos).offset(4);
    _downloadLabel.centerYPos.equalTo(downloadIcon.centerYPos);
    [contentLayout addSubview:_downloadLabel];
    
    _introLabel = [UILabel new];
    _introLabel.textColor = [UIColor descriptionTextColor];
    _introLabel.font = [UIFont systemFontOfSize:ListIntroductionFontSize];
    _introLabel.myLeading = _introLabel.myTrailing = 0; //垂直线性布局里面如果同时设置了左右边距则能确定子视图的宽度，这里表示宽度和父视图相等。
    _introLabel.myHeight = MyLayoutSize.wrap; //如果想让文本的高度是动态的，请在设置明确宽度的情况下将高度设置为自适应。
    _introLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    _introLabel.numberOfLines = 2;
    _introLabel.leftPos.equalTo(_rootLayout.leftPos);
    _introLabel.topPos.equalTo(_typeImage.bottomPos).offset(5);
    _introLabel.leftPos.equalTo(_typeImage.leftPos);

    [_rootLayout addSubview:_introLabel];
    
    _snapshotScrollView = [[UIScrollView alloc] init];
    _snapshotScrollView.myHorzMargin = 0;
    _snapshotScrollView.showsHorizontalScrollIndicator = NO;
    _snapshotScrollView.heightSize.equalTo(@SnapshotImgHeight);
    _snapshotScrollView.topPos.equalTo(_introLabel.bottomPos).offset(5);
    _snapshotScrollView.leftPos.equalTo(_introLabel.leftPos);
    [_rootLayout addSubview:_snapshotScrollView];
    
    _snapshotLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    _snapshotLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0); //设置布局内的子视图离自己的边距.
    _snapshotLayout.myVertMargin = 0;                          //同时指定左右边距为0表示宽度和父视图一样宽
    _snapshotLayout.subviewHSpace = 4;
    _snapshotLayout.widthSize.lBound(_snapshotScrollView.widthSize, 0, 1);
    [_snapshotScrollView addSubview:_snapshotLayout];
    
}

- (UIImageView *) createIconImage:(NSString *)iconName {
    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IconImgHeight, IconImgHeight)];
    iconImage.contentMode = UIViewContentModeScaleAspectFit;
    iconImage.image = [UIImage imageNamed:iconName];
    return iconImage;
}

@end
