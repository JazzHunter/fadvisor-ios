//
//  ArticleFloatCoverTableViewCell.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/6/25.
//

#define CoverImgWidth        105    //封面图片的宽度
#define CoverImgHeight       85     //封面图片的高度
#define ContactCoverImgWidth 28         //作者头像大小

#import "ArticleFloatCoverTableViewCell.h"
#import "ItemBottomToolbar.h"

@interface ArticleFloatCoverTableViewCell ()

@property (nonatomic, strong) YYAnimatedImageView *coverImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *introLabel;
@property (nonatomic, strong) ItemBottomToolbar *bottomToolbar;

@end

@implementation ArticleFloatCoverTableViewCell

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

    _introLabel.text = model.introduction;
    
    [_bottomToolbar setModel:model];
}

#pragma mark -- Layout Construction

//用线性布局来实现UI界面
- (void)createLayout
{
    _rootLayout = [MyRelativeLayout new];
    _rootLayout.padding = UIEdgeInsetsMake(10, 16, 0, 16);

    //这个属性只局限于在UITableViewCell中使用，用来优化tableviewcell的高度自适应的性能，其他地方请不要使用！！！
    _rootLayout.cacheEstimatedRect = YES;
    _rootLayout.heightSize.equalTo(@(MyLayoutSize.wrap));
    _rootLayout.widthSize.equalTo(nil);
    [self.contentView addSubview:_rootLayout];

    MyLinearLayout *contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    contentLayout.myHorzMargin = 0;
    contentLayout.myHeight = MyLayoutSize.wrap; //如果想让文本的高度是动态的，请在设置明确宽度的情况下将高度设置为自适应。
    
    contentLayout.leftPos.equalTo(_rootLayout.leftPos);
    contentLayout.topPos.equalTo(_rootLayout.topPos);
    [_rootLayout addSubview: contentLayout];
    
    
    MyLinearLayout *contentTextLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    contentTextLayout.weight = 1;
    contentTextLayout.myTrailing = 12;  //前面2行代码描述的是垂直布局占用除头像外的所有宽度，并和头像保持12个点的间距。
    contentTextLayout.subviewVSpace = 5; //垂直布局里面所有子视图都保持5个点的间距。
    [contentLayout addSubview:contentTextLayout];

    _titleLabel = [UILabel new];
    _titleLabel.textColor = [UIColor titleTextColor];
    _titleLabel.font =  [UIFont systemFontOfSize:ListTitleFontSize];
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    _titleLabel.myLeading = _titleLabel.myTrailing = 0; //垂直线性布局里面如果同时设置了左右边距则能确定子视图的宽度，这里表示宽度和父视图相等。
    _titleLabel.myHeight = MyLayoutSize.wrap; //如果想让文本的高度是动态的，请在设置明确宽度的情况下将高度设置为自适应。
    _titleLabel.numberOfLines = 2;
    [contentTextLayout addSubview:_titleLabel];

    _introLabel = [UILabel new];
    _introLabel.textColor = [UIColor descriptionTextColor];
    _introLabel.font = [UIFont systemFontOfSize:ListIntroductionFontSize];
    _introLabel.myLeading = _introLabel.myTrailing = 0; //垂直线性布局里面如果同时设置了左右边距则能确定子视图的宽度，这里表示宽度和父视图相等。
    _introLabel.myHeight = MyLayoutSize.wrap; //如果想让文本的高度是动态的，请在设置明确宽度的情况下将高度设置为自适应。
    _introLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    _introLabel.numberOfLines = 3;

    [contentTextLayout addSubview:_introLabel];

    _coverImage = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, CoverImgWidth, CoverImgHeight)];
    _coverImage.contentMode = UIViewContentModeScaleAspectFill;
    _coverImage.clipsToBounds = YES;
    [_coverImage xy_setLayerBorderColor:[UIColor borderColor]];
    _coverImage.layer.borderWidth = 1;
    [_coverImage setCornerRadius:4];
    [contentLayout addSubview:_coverImage];
    
    _bottomToolbar = [ItemBottomToolbar new];
    _bottomToolbar.myHorzMargin = 0;
    _bottomToolbar.myHeight = MyLayoutSize.wrap;
    _bottomToolbar.leftPos.equalTo(_rootLayout.leftPos);
    _bottomToolbar.topPos.equalTo(contentLayout.bottomPos).offset(5);
    [_rootLayout addSubview:_bottomToolbar];
}

@end
