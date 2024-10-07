//
//  ColmunDetailsHeaderView.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/9/28.
//

#define CoverImgWidth        105    //封面图片的宽度
#define CoverImgHeight       85     //封面图片的高度

#import "ColumnDetailsHeaderView.h"
#import "ItemSubscribeButton.h"
#import "ContentTags.h"
#import "Utils.h"

@interface ColumnDetailsHeaderView()

@property (nonatomic, strong) YYAnimatedImageView *coverImage;
@property (nonatomic, strong) ItemSubscribeButton *subscribeButton;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *introLabel;

@property (nonatomic, strong) UILabel *topInfoLabel;

@property (nonatomic, strong) UIButton *expandButton;


@end

@implementation ColumnDetailsHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
   
    self.myHeight = MyLayoutSize.wrap;
    
    self.padding = UIEdgeInsetsMake(10 + kDefaultNavBarHeight, ViewHorizonlMargin, 16, ViewHorizonlMargin);
    
    self.coverImage = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, CoverImgWidth, CoverImgHeight)];
    self.coverImage.layer.masksToBounds = YES;
    self.coverImage.layer.cornerRadius = 6;
    self.coverImage.layer.borderWidth = 4;
    self.coverImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.coverImage xy_setLayerBorderColor:[UIColor borderColor]];
    
    self.coverImage.leftPos.equalTo(self.leftPos);
    self.coverImage.topPos.equalTo(self.topPos);
    [self addSubview:self.coverImage];
    
    self.subscribeButton = [ItemSubscribeButton new];
    self.subscribeButton.rightPos.equalTo(self.rightPos);
    self.subscribeButton.centerYPos.equalTo(self.coverImage.centerYPos);
    [self addSubview:self.subscribeButton];
    
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:ListTitleFontSize weight:UIFontWeightSemibold];
    self.titleLabel.textColor = [UIColor titleTextColor];
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.myHeight = MyLayoutSize.wrap;
    self.titleLabel.leftPos.equalTo(self.coverImage.rightPos).offset(12);
    self.titleLabel.rightPos.equalTo(self.subscribeButton.leftPos).offset(12);
    self.titleLabel.centerYPos.equalTo(self.coverImage.centerYPos);
    
    [self addSubview:self.titleLabel];
    
    self.topInfoLabel = [UILabel new];
    self.topInfoLabel.textColor = [UIColor whiteColor];
    self.topInfoLabel.font =  [UIFont systemFontOfSize:ListMetaFontSize];
    self.topInfoLabel.topPos.equalTo(self.coverImage.bottomPos).offset(12);
    self.topInfoLabel.leftPos.equalTo(self.leftPos);
    self.topInfoLabel.myHorzMargin = 0;
    self.topInfoLabel.myHeight = MyLayoutSize.wrap; //如果想让文本的高度是动态的，请在设置明确宽度的情况下将高度设置为自适应。
    
    [self addSubview:self.topInfoLabel];
    
    self.introLabel = [UILabel new];
    self.introLabel.font = [UIFont systemFontOfSize:ListIntroductionFontSize];
    self.introLabel.textColor = [UIColor descriptionTextColor];
    self.introLabel.numberOfLines = 2;
    self.introLabel.topPos.equalTo(self.topInfoLabel.bottomPos).offset(12);
    self.introLabel.leftPos.equalTo(self.leftPos);
    self.introLabel.myHorzMargin = 0;
    self.introLabel.myHeight = MyLayoutSize.wrap; //如果想让文本的高度是动态的，请在设置明确宽度的情况下将高度设置为自适应。

    [self addSubview:self.introLabel];
    
    _expandButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_expandButton setTitle:[@"展开" localString] forState:UIControlStateNormal];
    [_expandButton sizeToFit];
    _expandButton.topPos.equalTo(self.introLabel.bottomPos).offset(12);
    _expandButton.leftPos.equalTo(self.leftPos);
    
    [self addSubview:self.expandButton];
}

- (void)setModel:(ItemModel *)itemModel details:(ColumnDetailsModel *)detailsModel{
    if (!itemModel.coverUrl || itemModel.coverUrl.absoluteString.length == 0) {
        [self.coverImage setImage:[UIImage imageNamed:@"pwc_logo_drawn"]];
    } else {
        [self.coverImage setImageWithURL:itemModel.coverUrl];
    }
    
    _titleLabel.text = itemModel.title;
    [_titleLabel sizeToFit];
    
    self.topInfoLabel.text = [NSString stringWithFormat:@"%@ · ", [Utils formatBackendTimeString:itemModel.pubTime]];
    [self.topInfoLabel sizeToFit];

    self.introLabel.text = itemModel.introduction;
    [self.introLabel sizeToFit];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    NSLog(@"%f", self.height);

    !self.loadedFinishBlock ? : self.loadedFinishBlock(self.height);
}

@end
