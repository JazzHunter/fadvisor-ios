//
//  DocInListTableViewCell.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/8/15.
//
#define DocTypeImgHeight 44           // 文档类型图片的高度

#import "DocInListTableViewCell.h"
#import "Utils.h"

@interface DocInListTableViewCell ()

@property (nonatomic, strong) UIImageView *typeImageView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *introLabel;
@property (nonatomic, strong) UIImageView *authorAvatarView;
@property (nonatomic, strong) UILabel *authorNameLabel;
@property (nonatomic, strong) UILabel *bottomInfoLabel;

@end

@implementation DocInListTableViewCell

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
    _typeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"doc_file_%@", model.fmt]];

    _titleLabel.text = model.title;

    _introLabel.text = [model.introduction isNotBlank] ? model.introduction : @"暂无简介";

    if ((model.authors[0].avatar != nil && [[model.authors[0].avatar absoluteString] isNotBlank])) {
        [_authorAvatarView setImageWithURL:model.authors[0].avatar];
    } else {
        _authorAvatarView.image = [UIImage imageNamed:@"default_author_avatar"];
    }

    _authorNameLabel.text = model.authors[0].name;

    _bottomInfoLabel.text = [NSString stringWithFormat:@"· %@ · %@ 查看", [Utils formatBackendTimeString:model.pubTime], [Utils shortedNumberDesc:model.viewCount]];
}

#pragma mark -- Layout Construction

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

    _typeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DocTypeImgHeight, DocTypeImgHeight)];
    _typeImageView.contentMode = UIViewContentModeScaleAspectFill;
    _typeImageView.leftPos.equalTo(_rootLayout.leftPos);
    _typeImageView.topPos.equalTo(_rootLayout.topPos);

    [_rootLayout addSubview:_typeImageView];

    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    _titleLabel.textColor = [UIColor titleTextColor];
    _titleLabel.numberOfLines = 1;
    _titleLabel.myHeight = 15;
    _titleLabel.leftPos.equalTo(_typeImageView.rightPos).offset(12);
    _titleLabel.rightPos.equalTo(_rootLayout.rightPos);
    _titleLabel.topPos.equalTo(_rootLayout.topPos);
    [_rootLayout addSubview:_titleLabel];

    _introLabel = [UILabel new];
    _introLabel.font = [UIFont systemFontOfSize:ListIntroductionFontSize];
    _introLabel.textColor = [UIColor descriptionTextColor];
    _introLabel.numberOfLines = 1;
    _introLabel.leftPos.equalTo(_titleLabel.leftPos);
    _introLabel.rightPos.equalTo(_titleLabel.rightPos);
    _introLabel.topPos.equalTo(_titleLabel.bottomPos).offset(8);
    _introLabel.myHeight = ListIntroductionFontSize;
    [_rootLayout addSubview:_introLabel];

    MyLinearLayout *metaLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    metaLayout.gravity = MyGravity_Vert_Center;
    metaLayout.subviewHSpace = 4;
    metaLayout.myHorzMargin = 0;
    metaLayout.myHeight = MyLayoutSize.wrap;
    metaLayout.leftPos.equalTo(_rootLayout.leftPos);
    metaLayout.topPos.equalTo(_typeImageView.bottomPos).offset(8);
    [_rootLayout addSubview:metaLayout];

    _authorAvatarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
    _authorAvatarView.contentMode = UIViewContentModeScaleAspectFill;
    _authorAvatarView.layer.masksToBounds = YES;
    _authorAvatarView.layer.cornerRadius = 7;
    [metaLayout addSubview:_authorAvatarView];

    _authorNameLabel = [UILabel new];
    _authorNameLabel.textColor = [UIColor metaTextColor];
    _authorNameLabel.font =  [UIFont systemFontOfSize:ListMetaFontSize];
    _authorNameLabel.numberOfLines = 1;
    _authorNameLabel.widthSize.equalTo(@(MyLayoutSize.wrap)).max(80);
    _authorNameLabel.myHeight = ListMetaFontSize;
    [metaLayout addSubview:_authorNameLabel];

    _bottomInfoLabel = [UILabel new];
    _bottomInfoLabel.textColor = [UIColor metaTextColor];
    _bottomInfoLabel.font =  [UIFont systemFontOfSize:ListMetaFontSize];
    _bottomInfoLabel.widthSize.equalTo(@(MyLayoutSize.wrap));
    _bottomInfoLabel.myHeight = ListMetaFontSize;
    [metaLayout addSubview:_bottomInfoLabel];
}

@end
