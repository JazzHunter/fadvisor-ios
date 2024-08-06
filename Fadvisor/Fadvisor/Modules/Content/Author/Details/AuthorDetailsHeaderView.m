//
//  AuthorDetailsHeaderView.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/7/3.
//

#define AvatarImgHeight 96

#import "AuthorDetailsHeaderView.h"
#import "AuthorAvatarWithWrapper.h"
#import "Utils.h"
#import "AuthorFollowButton.h"

@interface AuthorDetailsHeaderView ()

@property (nonatomic, strong) AuthorModel *authorModel;

@property (nonatomic, strong) UIImageView *topBgImageView;
@property (nonatomic, strong) AuthorAvatarWithWrapper *avatarImage;
@property (nonatomic, strong) UILabel *contentAmountLabel;
@property (nonatomic, strong) UILabel *viewAmountLabel;
@property (nonatomic, strong) UILabel *followerAmountLabel;
@property (nonatomic, strong) AuthorFollowButton *followButton;

@end

@implementation AuthorDetailsHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        [self initUI];
    }
    return self;
}

- (void)initUI {

    self.topBgImageView = [UIImageView new];
    self.topBgImageView.myHorzMargin = 0;
    self.topBgImageView.myHeight = 160;
    self.topBgImageView.topPos.equalTo(self.topPos);
    self.topBgImageView.leftPos.equalTo(self.leftPos);
    [self addSubview:self.topBgImageView];

    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    blurView.alpha = 0.7; // 控制模糊程度
    blurView.widthSize.equalTo(self.topBgImageView.widthSize);
    blurView.heightSize.equalTo(self.topBgImageView.heightSize);
    blurView.centerXPos.equalTo(self.topBgImageView.centerXPos);
    blurView.centerYPos.equalTo(self.topBgImageView.centerYPos);
    [self addSubview:blurView];

    MyRelativeLayout *contentLayout = [MyRelativeLayout new];
    contentLayout.myHorzMargin = 0;
    contentLayout.myHeight = MyLayoutSize.wrap;
    contentLayout.padding = UIEdgeInsetsMake(6, ViewHorizonlMargin, 10, ViewHorizonlMargin);
    contentLayout.backgroundColor = [UIColor backgroundColor];
    contentLayout.leftPos.equalTo(self.leftPos);
    contentLayout.topPos.equalTo(self.topBgImageView.bottomPos);

    [self addSubview:contentLayout];

    self.avatarImage = [[AuthorAvatarWithWrapper alloc] initWithFrame:CGRectMake(0, 0, AvatarImgHeight, AvatarImgHeight)];
    self.avatarImage.topPos.equalTo(contentLayout.topPos).offset(-24);
    self.avatarImage.leftPos.equalTo(contentLayout.leftPos);
    [contentLayout addSubview:self.avatarImage];
    
    
    MyLinearLayout *amountLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    amountLayout.widthSize.equalTo(contentLayout.widthSize).add(-1 * AvatarImgHeight - 10);
    amountLayout.myHeight = MyLayoutSize.wrap;
    amountLayout.topPos.equalTo(contentLayout.topPos);
    amountLayout.leftPos.equalTo(self.avatarImage.rightPos).offset(10);
    amountLayout.gravity = MyGravity_Vert_Center;
    [contentLayout addSubview:amountLayout];

    // 内容数量
    MyRelativeLayout *contentAmountlayout = [MyRelativeLayout new];
    contentAmountlayout.weight = 1;
    contentAmountlayout.myHeight = MyLayoutSize.wrap;
    [amountLayout addSubview:contentAmountlayout];

    self.contentAmountLabel = [UILabel new];
    self.contentAmountLabel.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
    self.contentAmountLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    self.contentAmountLabel.textColor = [UIColor metaTextColor];
    self.contentAmountLabel.centerXPos.equalTo(contentAmountlayout.centerXPos);
    self.contentAmountLabel.centerYPos.equalTo(contentAmountlayout.centerYPos).offset(-12);
    [contentAmountlayout addSubview:self.contentAmountLabel];

    UILabel *contentAmountTextLabel = [UILabel new];
    contentAmountTextLabel.font = [UIFont systemFontOfSize:12];
    contentAmountTextLabel.textColor = [UIColor metaTextColor];
    contentAmountTextLabel.text = @"内容";
    [contentAmountTextLabel sizeToFit];
    contentAmountTextLabel.topPos.equalTo(self.contentAmountLabel.bottomPos);
    contentAmountTextLabel.centerXPos.equalTo(self.contentAmountLabel.centerXPos);
    [contentAmountlayout addSubview:contentAmountTextLabel];
    
    UIView *vDivider1 = [UIView new];
    vDivider1.myWidth = 2;
    vDivider1.heightSize.equalTo(contentAmountlayout.heightSize).multiply(0.8);
    vDivider1.backgroundColor = [UIColor borderColor];
    [amountLayout addSubview:vDivider1];
    
    // 查看数量
    MyRelativeLayout *viewAmountlayout = [MyRelativeLayout new];
    viewAmountlayout.weight = 1;
    viewAmountlayout.myHeight = MyLayoutSize.wrap;
    [amountLayout addSubview:viewAmountlayout];

    self.viewAmountLabel = [UILabel new];
    self.viewAmountLabel.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
    self.viewAmountLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    self.viewAmountLabel.textColor = [UIColor metaTextColor];
    self.viewAmountLabel.centerXPos.equalTo(viewAmountlayout.centerXPos);
    self.viewAmountLabel.centerYPos.equalTo(viewAmountlayout.centerYPos).offset(-12);
    [viewAmountlayout addSubview:self.viewAmountLabel];

    UILabel *viewAmountTextLabel = [UILabel new];
    viewAmountTextLabel.font = [UIFont systemFontOfSize:12];
    viewAmountTextLabel.textColor = [UIColor metaTextColor];
    viewAmountTextLabel.text = @"查看";
    [viewAmountTextLabel sizeToFit];
    viewAmountTextLabel.topPos.equalTo(self.viewAmountLabel.bottomPos);
    viewAmountTextLabel.centerXPos.equalTo(self.viewAmountLabel.centerXPos);
    [viewAmountlayout addSubview:viewAmountTextLabel];
    
    UIView *vDivider2 = [UIView new];
    vDivider2.myWidth = 2;
    vDivider2.heightSize.equalTo(contentAmountlayout.heightSize).multiply(0.8);
    vDivider2.backgroundColor = [UIColor borderColor];
    [amountLayout addSubview:vDivider2];
    
    // 关注人数量
    MyRelativeLayout *followerAmountlayout = [MyRelativeLayout new];
    followerAmountlayout.weight = 1;
    followerAmountlayout.myHeight = MyLayoutSize.wrap;
    [amountLayout addSubview:followerAmountlayout];

    self.followerAmountLabel = [UILabel new];
    self.followerAmountLabel.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
    self.followerAmountLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    self.followerAmountLabel.textColor = [UIColor metaTextColor];
    self.followerAmountLabel.centerXPos.equalTo(followerAmountlayout.centerXPos);
    self.followerAmountLabel.centerYPos.equalTo(followerAmountlayout.centerYPos).offset(-12);
    [followerAmountlayout addSubview:self.followerAmountLabel];

    UILabel *followerAmountTextLabel = [UILabel new];
    followerAmountTextLabel.font = [UIFont systemFontOfSize:12];
    followerAmountTextLabel.textColor = [UIColor metaTextColor];
    followerAmountTextLabel.text = @"关注";
    [followerAmountTextLabel sizeToFit];
    followerAmountTextLabel.topPos.equalTo(self.followerAmountLabel.bottomPos);
    followerAmountTextLabel.centerXPos.equalTo(self.followerAmountLabel.centerXPos);
    [followerAmountlayout addSubview:followerAmountTextLabel];
    
    // 关注按钮
    self.followButton = [[AuthorFollowButton alloc] init];
    self.followButton.myHeight = 32;
    self.followButton.widthSize.equalTo(amountLayout.widthSize);
    self.followButton.leftPos.equalTo(amountLayout.leftPos);
    self.followButton.topPos.equalTo(amountLayout.bottomPos).offset(4);
    
    [contentLayout addSubview:self.followButton];
    
    UIView *fakeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    fakeView.leftPos.equalTo(contentLayout.leftPos);
    fakeView.topPos.equalTo(self.avatarImage.bottomPos).offset(16);
    fakeView.backgroundColor = [UIColor yellowColor];
    
    [contentLayout addSubview:fakeView];
}


- (void)setModel:(AuthorModel *)authorModel details:(AuthorDetailsModel *)detailsModel {
    [self.avatarImage setAvatarUrl:authorModel.avatar];

    self.contentAmountLabel.text = [Utils shortedNumberDesc:authorModel.itemCount];
    self.viewAmountLabel.text = [Utils shortedNumberDesc:authorModel.viewCount];
    self.followerAmountLabel.text = [Utils shortedNumberDesc:authorModel.followerCount];

    [self layoutIfNeeded];

    !self.loadedFinishBlock ? : self.loadedFinishBlock(self.height);
}

@end
