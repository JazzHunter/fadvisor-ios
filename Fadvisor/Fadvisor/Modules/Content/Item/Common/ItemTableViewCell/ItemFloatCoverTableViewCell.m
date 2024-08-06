//
//  ItemFloatCoverTableViewCell.m
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/21.
//

#define CoverImgWidth        105    //封面图片的宽度
#define CoverImgHeight       85     //封面图片的高度
#define ContactCoverImgWidth 28         //作者头像大小

#import "ItemFloatCoverTableViewCell.h"

@interface ItemFloatCoverTableViewCell ()

@property (nonatomic, strong) YYAnimatedImageView *coverImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *introLabel;

@end

@implementation ItemFloatCoverTableViewCell

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
    if (!model.coverUrl || model.coverUrl.absoluteString.length == 0) {
        _coverImage.visibility = MyVisibility_Gone;
    } else {
        _coverImage.visibility = MyVisibility_Visible;
        [_coverImage setImageWithURL:model.coverUrl];
    }
    
    _titleLabel.text = model.title;
//    [_titleLabel sizeToFit];

    _introLabel.text = model.introduction;
//    [_introLabel sizeToFit];
}

#pragma mark -- Layout Construction e

//用线性布局来实现UI界面
- (void)createLayout
{
    _rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    _rootLayout.padding = UIEdgeInsetsMake(10, 16, 10, 16);

    //这个属性只局限于在UITableViewCell中使用，用来优化tableviewcell的高度自适应的性能，其他地方请不要使用！！！
    _rootLayout.cacheEstimatedRect = YES;
    _rootLayout.heightSize.equalTo(@(MyLayoutSize.wrap));
    _rootLayout.widthSize.equalTo(nil);
    [self.contentView addSubview:_rootLayout];

    MyLinearLayout *contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    contentLayout.weight = 1;
    contentLayout.myTrailing = 12;  //前面2行代码描述的是垂直布局占用除头像外的所有宽度，并和头像保持12个点的间距。
    contentLayout.subviewVSpace = 5; //垂直布局里面所有子视图都保持5个点的间距。
    [_rootLayout addSubview:contentLayout];

    _titleLabel = [UILabel new];
    _titleLabel.textColor = [UIColor titleTextColor];
    _titleLabel.font =  [UIFont systemFontOfSize:ListTitleFontSize];
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    _titleLabel.myLeading = _titleLabel.myTrailing = 0; //垂直线性布局里面如果同时设置了左右边距则能确定子视图的宽度，这里表示宽度和父视图相等。
    _titleLabel.myHeight = MyLayoutSize.wrap; //如果想让文本的高度是动态的，请在设置明确宽度的情况下将高度设置为自适应。
    _titleLabel.numberOfLines = 2;
    [contentLayout addSubview:_titleLabel];

    _introLabel = [UILabel new];
    _introLabel.textColor = [UIColor descriptionTextColor];
    _introLabel.font = [UIFont systemFontOfSize:ListIntroductionFontSize];
    _introLabel.myLeading = _introLabel.myTrailing = 0; //垂直线性布局里面如果同时设置了左右边距则能确定子视图的宽度，这里表示宽度和父视图相等。
    _introLabel.myHeight = MyLayoutSize.wrap; //如果想让文本的高度是动态的，请在设置明确宽度的情况下将高度设置为自适应。
    _introLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    _introLabel.numberOfLines = 2;

    [contentLayout addSubview:_introLabel];

    _coverImage = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, CoverImgWidth, CoverImgHeight)];
    _coverImage.contentMode = UIViewContentModeScaleAspectFill;
    _coverImage.clipsToBounds = YES;
    [_coverImage xy_setLayerBorderColor:[UIColor borderColor]];
    _coverImage.layer.borderWidth = 1;
    [_coverImage setCornerRadius:4];
    [_rootLayout addSubview:_coverImage];
}

@end
