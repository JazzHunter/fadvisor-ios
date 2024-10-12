//
//  ArticleDetailsToolbarView.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/8/14.
//

#define ButtonWidth       42
#define AuthorAvatarWidth 32

#import "ArticleDetailsToolbarView.h"
#import "VoteVButton.h"
#import "FavVButton.h"
#import "ShareVButton.h"
#import "ContentSharePanel.h"

@interface ArticleDetailsToolbarView ()

@property (nonatomic, strong) VoteVButton *voteButton;
@property (nonatomic, strong) FavVButton *favButton;
@property (nonatomic, strong) ShareVButton *shareButton;
@property (nonatomic, strong) ItemModel *itemModel;

@property (nonatomic, strong) UIImageView *authorAvatarView;
@property (nonatomic, strong) UILabel *authorNameLabel;

@end

@implementation ArticleDetailsToolbarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.shareButton = [[ShareVButton alloc]init];
    self.shareButton.myWidth = ButtonWidth;
    self.shareButton.centerYPos.equalTo(self.centerYPos);
    self.shareButton.rightPos.equalTo(self.rightPos);
    [self addSubview:self.shareButton];

    self.favButton = [FavVButton new];
    self.favButton.myWidth = ButtonWidth;
    self.favButton.centerYPos.equalTo(self.centerYPos);
    self.favButton.rightPos.equalTo(self.shareButton.leftPos).offset(6);
    [self addSubview:self.favButton];

    self.voteButton = [VoteVButton new];
    self.voteButton.myWidth = ButtonWidth;
    self.voteButton.centerYPos.equalTo(self.centerYPos);
    self.voteButton.rightPos.equalTo(self.favButton.leftPos).offset(6);
    [self addSubview:self.voteButton];
    
    MyLinearLayout *authorLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    authorLayout.myHeight = AuthorAvatarWidth;
    authorLayout.widthSize.equalTo(@(MyLayoutSize.wrap));
    authorLayout.gravity = MyGravity_Vert_Center;
    authorLayout.subviewHSpace = 6;
    authorLayout.leftPos.equalTo(self.leftPos);
    authorLayout.rightPos.equalTo(self.voteButton.leftPos).offset(24);
    authorLayout.centerYPos.equalTo(self.centerYPos);
    authorLayout.layer.masksToBounds = YES;
    authorLayout.layer.cornerRadius = AuthorAvatarWidth / 2;
    authorLayout.highlightedOpacity = 0.3;
    authorLayout.backgroundColor = [UIColor backgroundColorGray];
    authorLayout.paddingRight = 8;

    [self addSubview:authorLayout];

    _authorAvatarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, AuthorAvatarWidth, AuthorAvatarWidth)];
    _authorAvatarView.contentMode = UIViewContentModeScaleAspectFill;
    _authorAvatarView.layer.masksToBounds = YES;
    _authorAvatarView.layer.cornerRadius = AuthorAvatarWidth / 2;
    [authorLayout addSubview:_authorAvatarView];

    _authorNameLabel = [UILabel new];
    _authorNameLabel.textColor = [UIColor titleTextColor];
    _authorNameLabel.font =  [UIFont systemFontOfSize:13];
    _authorNameLabel.numberOfLines = 2;
    _authorNameLabel.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
    _authorNameLabel.weight = 1;
    [authorLayout addSubview:_authorNameLabel];
}

- (void)setModel:(ItemModel *)model {
    self.itemModel = model;
    [self.voteButton setModel:model];
    [self.favButton setModel:model];

    if ((model.authors[0].avatar != nil && [[model.authors[0].avatar absoluteString] isNotBlank])) {
        [_authorAvatarView setImageWithURL:model.authors[0].avatar];
    } else {
        _authorAvatarView.image = [UIImage imageNamed:@"default_author_avatar"];
    }

    _authorNameLabel.text = model.authors[0].name;
}

@end
