//
//  TabAccountGeneralFuncsView.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/3/15.
//

#import "TabAccountGeneralFuncsView.h"
#import "ImageTextButton.h"

@implementation TabAccountGeneralFuncsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.myHeight = MyLayoutSize.wrap;
        self.padding = UIEdgeInsetsMake(12, 16, 12, 16);
        self.backgroundColor = [UIColor backgroundColor];
        self.layer.cornerRadius = 12;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1;
        [self xy_setLayerBorderColor:[UIColor borderColor]];

        UILabel *sectionLabel = [UILabel new];
        sectionLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
        sectionLabel.text = [@"常用功能" localString];
        sectionLabel.textColor = [UIColor titleTextColor];
        [sectionLabel sizeToFit];
        sectionLabel.topPos.equalTo(self.topPos);
        sectionLabel.leftPos.equalTo(self.leftPos);
        [self addSubview:sectionLabel];

        CGFloat spaceWidth = (kScreenWidth - 16 * 2 - 16 * 2 - 4 * 56) / 3;

        ImageTextButton *historyButton = [self createButtonWithTitleText:@"浏览记录" imageName:@"ic_history"];
        historyButton.topPos.equalTo(sectionLabel.bottomPos).offset(12);
        historyButton.leftPos.equalTo(sectionLabel.leftPos);
        [self addSubview:historyButton];

        ImageTextButton *favoritesButton = [self createButtonWithTitleText:@"我的收藏" imageName:@"ic_favorites"];
        favoritesButton.centerYPos.equalTo(historyButton.centerYPos);
        favoritesButton.leftPos.equalTo(historyButton.rightPos).offset(spaceWidth);
        [self addSubview:favoritesButton];

        ImageTextButton *followButton = [self createButtonWithTitleText:@"我的关注" imageName:@"ic_author"];
        followButton.centerYPos.equalTo(historyButton.centerYPos);
        followButton.leftPos.equalTo(favoritesButton.rightPos).offset(spaceWidth);
        [self addSubview:followButton];

        ImageTextButton *voteButton = [self createButtonWithTitleText:@"我的点赞" imageName:@"ic_heart"];
        voteButton.centerYPos.equalTo(historyButton.centerYPos);
        voteButton.leftPos.equalTo(followButton.rightPos).offset(spaceWidth);
        [self addSubview:voteButton];
        
        ImageTextButton *docButton = [self createButtonWithTitleText:@"我的文档" imageName:@"ic_book"];
        docButton.topPos.equalTo(historyButton.bottomPos).offset(12);
        docButton.leftPos.equalTo(historyButton.leftPos);
        [self addSubview:docButton];
        
        ImageTextButton *feedbackButton = [self createButtonWithTitleText:@"意见反馈" imageName:@"ic_feedback"];
        feedbackButton.centerYPos.equalTo(docButton.centerYPos);
        feedbackButton.leftPos.equalTo(docButton.rightPos).offset(spaceWidth);
        [self addSubview:feedbackButton];
    }
    return self;
}

- (ImageTextButton *)createButtonWithTitleText:(NSString *)titleText imageName:(NSString *)imageName {
    ImageTextButton *button = [[ImageTextButton alloc]initWithFrame:CGRectMake(0, 0, 56, 56)];
    button.imageSize = CGSizeMake(28, 28);
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitleColor:[UIColor titleTextColor] forState:UIControlStateNormal];
    [button setTitle:[titleText localString] forState:UIControlStateNormal];
    [button setImage:[[[UIImage imageNamed:imageName] imageWithTintColor:[UIColor mainColor]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    return button;
}

@end
