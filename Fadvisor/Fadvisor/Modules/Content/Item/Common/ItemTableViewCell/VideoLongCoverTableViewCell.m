//
//  VideoLongCoverTableViewCell.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/3/22.
//

#import "VideoLongCoverTableViewCell.h"
#import "ImageButton.h"
#import "Utils.h"

//#define CoverImgHeight 124           //封面图片的高度

@interface VideoLongCoverTableViewCell ()

@property (nonatomic, strong) YYAnimatedImageView *coverImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *introLabel;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UIView *coverShadowView;
@property (nonatomic, strong) CAGradientLayer *coverGradientLayer; //渐变色背景涂层

@end

@implementation VideoLongCoverTableViewCell

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
        _coverImage.image = [UIImage imageNamed:@"default_media_cover"];
    } else {
        [_coverImage setImageWithURL:model.coverUrl];
    }

    _titleLabel.text = model.title;

    _introLabel.text = model.introduction;

    _durationLabel.text = [Utils timeformatFromSeconds:roundf(model.duration)];
    [_durationLabel sizeToFit];
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

    _titleLabel = [UILabel new];
    _titleLabel.textColor = [UIColor titleTextColor];
    _titleLabel.font =  [UIFont systemFontOfSize:ListTitleFontSize];
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    _titleLabel.myHorzMargin = 0;
    _titleLabel.topPos.equalTo(self.topPos);
    _titleLabel.myHeight = MyLayoutSize.wrap; //如果想让文本的高度是动态的，请在设置明确宽度的情况下将高度设置为自适应。
    _titleLabel.numberOfLines = 2;
    [_rootLayout addSubview:_titleLabel];

    MyRelativeLayout *coverLayout = [MyRelativeLayout new];
    coverLayout.myHorzMargin = 0;
    coverLayout.myHeight = kScreenWidth * 9 / 16;
    coverLayout.topPos.equalTo(_titleLabel.bottomPos).offset(5);
    coverLayout.clipsToBounds = YES;
    [coverLayout xy_setLayerBorderColor:[UIColor borderColor]];
    coverLayout.layer.borderWidth = 1;
    coverLayout.layer.cornerRadius = 4;
    [_rootLayout addSubview:coverLayout];

    _coverImage = [[YYAnimatedImageView alloc] init];
    _coverImage.contentMode = UIViewContentModeScaleAspectFill;
    _coverImage.myMargin = 0;
    _coverImage.centerXPos.equalTo(coverLayout.centerXPos);
    _coverImage.centerYPos.equalTo(coverLayout.centerYPos);
    [coverLayout addSubview:_coverImage];

    _coverShadowView = [UIView new];
    _coverShadowView.myHorzMargin = 0;
    _coverShadowView.heightSize.equalTo(coverLayout.heightSize).multiply(0.33);
    _coverShadowView.leftPos.equalTo(coverLayout.leftPos);
    _coverShadowView.bottomPos.equalTo(coverLayout.bottomPos);

    _coverGradientLayer = [CAGradientLayer layer];
    _coverGradientLayer.colors = @[(id)[[UIColor colorFromHexString:@"333333"] colorWithAlphaComponent:0].CGColor, (id)[[UIColor colorFromHexString:@"333333"] colorWithAlphaComponent:1].CGColor]; //设置渐变颜色
    _coverGradientLayer.locations = @[@0.0, @0.8]; //颜色的起点位置，递增，并且数量跟颜色数量相等
    _coverGradientLayer.startPoint = CGPointMake(0.5, 0); //
    _coverGradientLayer.endPoint = CGPointMake(0.5, 1); //
    _coverGradientLayer.frame = CGRectMake(0, 0, kScreenWidth - 2 * 16, kScreenWidth * 3 / 16);
    [_coverShadowView.layer insertSublayer:_coverGradientLayer atIndex:0];

    [coverLayout addSubview:_coverShadowView];

    _durationLabel = [[UILabel alloc]init];
    _durationLabel.textAlignment = NSTextAlignmentCenter;
    _durationLabel.textColor = [UIColor whiteColor];
    _durationLabel.font = [UIFont systemFontOfSize:ListIntroductionFontSize];
    _durationLabel.rightPos.equalTo(coverLayout.rightPos).offset(12);
    _durationLabel.bottomPos.equalTo(coverLayout.bottomPos).offset(16);
    [coverLayout addSubview:_durationLabel];

    ImageButton *playButton = [[ImageButton alloc]initWithFrame:CGRectMake(0, 0, 54, 54) imageName:@"play_with_bg"];
    playButton.centerXPos.equalTo(coverLayout.centerXPos);
    playButton.centerYPos.equalTo(coverLayout.centerYPos);
    [coverLayout addSubview:playButton];

    _introLabel = [UILabel new];
    _introLabel.textColor = [UIColor descriptionTextColor];
    _introLabel.font = [UIFont systemFontOfSize:ListIntroductionFontSize];
    _introLabel.myHorzMargin = 0;
    _introLabel.topPos.equalTo(coverLayout.bottomPos).offset(5);
    _introLabel.myHeight = MyLayoutSize.wrap; //如果想让文本的高度是动态的，请在设置明确宽度的情况下将高度设置为自适应。
    _introLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    _introLabel.numberOfLines = 2;
    [_rootLayout addSubview:_introLabel];

    UIView *a = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 100, 200)];

//    _coverGradientLayer = [CAGradientLayer layer];
//    _coverGradientLayer.colors = @[(id)[[UIColor yellowColor] colorWithAlphaComponent:1].CGColor, (id)[[UIColor blueColor] colorWithAlphaComponent:0].CGColor];         //设置渐变颜色
//    _coverGradientLayer.locations = @[@0.0, @0.8];         //颜色的起点位置，递增，并且数量跟颜色数量相等
//    _coverGradientLayer.startPoint = CGPointMake(0.5, 0);         //
//    _coverGradientLayer.endPoint = CGPointMake(0.5, 1);         //
//    [a.layer insertSublayer:_coverGradientLayer atIndex:0];
//    [_rootLayout addSubview:a];
}

@end
