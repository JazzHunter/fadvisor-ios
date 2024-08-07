//
//  AuthorSection.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/24.
//

#import "AuthorInList.h"
#import "AuthorFollowButton.h"
#import "AuthorAvatarWithWrapper.h"

@interface AuthorInList ()

@property (nonatomic, strong) AuthorAvatarWithWrapper *authorAvatar;
@property (nonatomic, strong) AuthorFollowButton *followButton;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation AuthorInList

#pragma mark - Life Cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.myHeight = MyLayoutSize.wrap;
    self.myHorzMargin = 0;
}

#pragma mark - set & get
- (void)setModel:(AuthorModel *)model {
    [self removeAllSubviews];

    self.authorAvatar.leftPos.equalTo(self.leftPos);
    self.authorAvatar.centerYPos.equalTo(self.centerYPos);
    [self addSubview:self.authorAvatar];

    self.nameLabel.leftPos.equalTo(self.authorAvatar.rightPos).offset(12);
    self.nameLabel.rightPos.equalTo(self.followButton.leftPos).offset(12);
    self.nameLabel.topPos.equalTo(@0);
    self.nameLabel.heightSize.equalTo(@24);
    [self addSubview:self.nameLabel];

    self.titleLabel.leftPos.equalTo(self.nameLabel.leftPos);
    self.titleLabel.topPos.equalTo(self.nameLabel.bottomPos);
    self.titleLabel.widthSize.equalTo(self.nameLabel.widthSize);
    self.titleLabel.heightSize.equalTo(@20);
    [self addSubview:self.titleLabel];

    self.followButton.rightPos.equalTo(self.rightPos);
    self.followButton.centerYPos.equalTo(self.centerYPos);
    [self addSubview:self.followButton];

    self.countLabel.heightSize.equalTo(@24);
    [self addSubview:self.countLabel];

    [self setShowCount:NO];

    // setModel
    [self.authorAvatar setAvatarUrl:model.avatar];
    self.nameLabel.text = model.name;
    self.titleLabel.text = model.title ? model.title : [@"NoIntroduction" localString];

    self.countLabel.text = [NSString stringWithFormat:@"%lu项内容 · %lu人关注 · %lu次查看", model.itemCount, model.followerCount, model.viewCount];
}

- (void)setShowCount:(BOOL)isShowCount {
    self.countLabel.hidden = isShowCount;
}

- (AuthorAvatarWithWrapper *)authorAvatar {
    if (!_authorAvatar) {
        _authorAvatar = [[AuthorAvatarWithWrapper alloc] init];
    }
    return _authorAvatar;
}

- (AuthorFollowButton *)followButton {
    if (!_followButton) {
        _followButton = [[AuthorFollowButton alloc] init];
        _followButton.layer.cornerRadius = 4;
        _followButton.layer.masksToBounds = YES;
    }
    return _followButton;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor titleTextColor];
        _nameLabel.font = [UIFont systemFontOfSize:ListTitleFontSize weight:UIFontWeightSemibold];
        _nameLabel.numberOfLines = 1;
    }
    return _nameLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor descriptionTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:ListIntroductionFontSize];
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [UILabel new];
        _countLabel.textColor = [UIColor metaTextColor];
        _countLabel.font = [UIFont systemFontOfSize:ListMetaFontSize];
        _countLabel.numberOfLines = 1;
    }
    return _countLabel;
}

@end
