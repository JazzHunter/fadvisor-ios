//
//  TabHomeRcmdAuthorCard.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/8/6.
//
#define AvatarImgHeight 56

#import "TabHomeRcmdAuthorCard.h"
#import "AuthorAvatarWithWrapper.h"
#import "AuthorFollowButton.h"

@interface TabHomeRcmdAuthorCard ()

@property (nonatomic, strong) AuthorAvatarWithWrapper *avatar;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) AuthorFollowButton *followButton;
@property (nonatomic, strong) UIView *fakeFollowButton;
@property (nonatomic, strong) AuthorModel *authorModel;

@end

@implementation TabHomeRcmdAuthorCard

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, AuthorCardViewWidth, AuthorCardViewHeight)];
    if (self) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithModel:(AuthorModel *)model {
    self = [super initWithFrame:CGRectMake(0, 0, AuthorCardViewWidth, AuthorCardViewHeight)];
    if (self) {
        [self initUI];
        [self setModel:model];
    }
    return self;
}

- (void)initUI {
    self.padding = UIEdgeInsetsMake(16, 16, 16, 16);
    self.backgroundColor = [UIColor backgroundColor];
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    [self xy_setLayerBorderColor:[UIColor borderColor]];
    self.layer.borderWidth = 1;

    self.avatar = [[AuthorAvatarWithWrapper alloc] initWithFrame:CGRectMake(0, 0, AvatarImgHeight, AvatarImgHeight)];

    self.avatar.topPos.equalTo(self.topPos);
    self.avatar.centerXPos.equalTo(self.centerXPos);
    [self addSubview:self.avatar];

    self.nameLabel = [UILabel new];
    self.nameLabel.myLeading = self.nameLabel.myTrailing = 0;
    self.nameLabel.heightSize.equalTo(@(ListContentFontSize * 2.5));
    self.nameLabel.textColor = [UIColor titleTextColor];
    self.nameLabel.font = [UIFont systemFontOfSize:ListContentFontSize weight:UIFontWeightSemibold];
    self.nameLabel.numberOfLines = 2;
    self.nameLabel.textAlignment = NSTextAlignmentCenter;

    self.nameLabel.topPos.equalTo(self.avatar.bottomPos).offset(8);
    self.nameLabel.centerXPos.equalTo(self.centerXPos);
    [self addSubview:self.nameLabel];

    self.titleLabel = [UILabel new];
    self.titleLabel.myLeading = self.titleLabel.myTrailing = 0;
    self.titleLabel.heightSize.equalTo(@(ListIntroductionFontSize * 2.5));
    self.titleLabel.textColor = [UIColor descriptionTextColor];
    self.titleLabel.font = [UIFont systemFontOfSize:ListIntroductionFontSize];
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.topPos.equalTo(self.nameLabel.bottomPos).offset(8);
    self.titleLabel.centerXPos.equalTo(self.centerXPos);
    [self addSubview:self.titleLabel];

    self.fakeFollowButton = [[UIView alloc] initWithFrame:CGRectMake(0, 0, AuthorFollowButtonWidth, AuthorFollowButtonHeight)];
    self.fakeFollowButton.topPos.equalTo(self.titleLabel.bottomPos).offset(8);
    self.fakeFollowButton.centerXPos.equalTo(self.centerXPos);
    self.fakeFollowButton.layer.cornerRadius = 4;
    self.fakeFollowButton.layer.masksToBounds = YES;
    [self addSubview:self.fakeFollowButton];
    
    self.followButton = [[AuthorFollowButton alloc] init];
    self.followButton.layer.cornerRadius = 4;
    self.followButton.layer.masksToBounds = YES;
    self.followButton.topPos.equalTo(self.titleLabel.bottomPos).offset(8);
    self.followButton.centerXPos.equalTo(self.centerXPos);
    
}

- (void)setModel:(AuthorModel *)model {
    self.authorModel = model;
    [self.avatar setAvatarUrl:model.avatar];
    self.nameLabel.text = model.name;
    self.titleLabel.text = model.title;
    [self.fakeFollowButton removeFromSuperview];
    [self addSubview:self.followButton];

    [self setTarget:self action:@selector(tapped:)];
}

- (void)tapped:(MyBaseLayout *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onTabHomeRcmdAuthorCardTapped:withModel:)]) {
        [self.delegate onTabHomeRcmdAuthorCardTapped:self withModel:self.authorModel];
    }
}

@end
