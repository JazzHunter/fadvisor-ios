//
//  CommentInfoView.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/25.
//

#import "CommentView.h"
#import "ImageButton.h"
#import "LEECoolButton.h"
#import "Utils.h"

@interface CommentView ()<UITextViewDelegate>

@property (nonatomic, strong) UserAvatarWithWrapper *userAvatar;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) ImageButton *moreButton;
@property (nonatomic, strong) YYLabel *contentTextLabel;
@property (nonatomic, strong) UILabel *createTimeLabel;
@property (nonatomic, strong) ImageButton *replyButton;
@property (nonatomic, strong) LEECoolButton *commentVoteButton;

@property (nonatomic, assign) CommentViewSize commentViewSize;

#define ContentTextUnexpandNumberOfLines 3

@end

@implementation CommentView

#pragma mark - Life Cycle
- (instancetype)init {
    return [self initWithSize:CommentViewSizeNormal];
}

- (instancetype)initWithSize:(CommentViewSize)size {
    self = [super init];
    if (self) {
        self.commentViewSize = size;

        self.myHeight = MyLayoutSize.wrap;

        self.userAvatar.leftPos.equalTo(self.leftPos);
        self.userAvatar.topPos.equalTo(self.topPos);
        [self addSubview:self.userAvatar];

        self.moreButton.rightPos.equalTo(self.rightPos);
        self.moreButton.topPos.equalTo(self.topPos);
        [self.moreButton addActionHandler:^(NSInteger tag) {
            NSLog(@"more button clicked");
        }];
        [self addSubview:self.moreButton];

        self.nicknameLabel.leftPos.equalTo(self.userAvatar.rightPos).offset(8);
        self.nicknameLabel.rightPos.equalTo(self.moreButton.rightPos).offset(8);
        self.nicknameLabel.centerYPos.equalTo(self.userAvatar.centerYPos);
        [self addSubview:self.nicknameLabel];

        self.contentTextLabel.leftPos.equalTo(self.nicknameLabel.leftPos);
        self.contentTextLabel.rightPos.equalTo(self.moreButton.rightPos);
        self.contentTextLabel.topPos.equalTo(self.nicknameLabel.bottomPos).offset(4);
        [self addSubview:self.contentTextLabel];

        self.createTimeLabel.leftPos.equalTo(self.contentTextLabel.leftPos);
        self.createTimeLabel.topPos.equalTo(self.contentTextLabel.bottomPos).offset(8);
        [self addSubview:self.createTimeLabel];

        self.commentVoteButton.rightPos.equalTo(self.rightPos);
        self.commentVoteButton.centerYPos.equalTo(self.createTimeLabel.centerYPos);
        [self addSubview:self.commentVoteButton];

        self.replyButton.rightPos.equalTo(self.commentVoteButton.leftPos).offset(8);
        self.replyButton.centerYPos.equalTo(self.commentVoteButton.centerYPos);
        [self addSubview:self.replyButton];
    }
    return self;
}

#pragma mark - set & get
- (void)setModel:(CommentModel *)model {
    [self.userAvatar setAvatarUrlWithInternal:model.userFrom.avatar internal:model.userFrom.internal];

    self.nicknameLabel.text = model.userFrom.nickname;
    [self.nicknameLabel sizeToFit];

//    NSString *contentText = [[model.content stringByReplacingOccurrencesOfString:@"\%n" withString:@"\r\n"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    NSString *contentText = [self filterBlankAndBlankLines:model.content];

    CGFloat contentTextFontSize = self.commentViewSize == CommentViewSizeNormal ? 14 : 13;

    if (model.userTo != nil) {
        NSString *prefixText = @"回复";
        NSString *repliedUserNickname = model.userTo.nickname;
        contentText = [NSString stringWithFormat:@"%@%@ %@", prefixText, repliedUserNickname, contentText];
        NSMutableAttributedString *contentTextAttr = [[NSMutableAttributedString alloc] initWithString:contentText attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:contentTextFontSize], NSForegroundColorAttributeName: [UIColor contentTextColor] }];
        NSRange repliedUserNicknameRange = [contentText rangeOfString:repliedUserNickname];
        [contentTextAttr setTextHighlightRange:repliedUserNicknameRange color:[UIColor mainColor] backgroundColor:[UIColor clearColor] userInfo:@{ @"a": @"b" } tapAction:^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
            NSLog(@"%@", containerView);
        } longPressAction:^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
            NSLog(@"%@", containerView);
        }];

        self.contentTextLabel.attributedText = contentTextAttr;
    } else {
        NSMutableAttributedString *contentTextAttr = [[NSMutableAttributedString alloc] initWithString:contentText attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:contentTextFontSize], NSForegroundColorAttributeName: [UIColor contentTextColor] }];
        self.contentTextLabel.attributedText = contentTextAttr;
    }
    YYTextLinePositionSimpleModifier *modifier = [YYTextLinePositionSimpleModifier new];
    modifier.fixedLineHeight = contentTextFontSize * 1.5;
    self.contentTextLabel.linePositionModifier = modifier;

    self.createTimeLabel.text = [Utils formatBackendTimeString:model.createTime];
    [self.createTimeLabel sizeToFit];

    self.commentVoteButton.selected = model.voted;
}

- (UserAvatarWithWrapper *)userAvatar {
    if (!_userAvatar) {
        _userAvatar = self.commentViewSize == CommentViewSizeNormal ? [[UserAvatarWithWrapper alloc] init] : [[UserAvatarWithWrapper alloc] initWithFrame:CGRectMake(0, 0, UserAvatarWithWrapperWidthSmall, UserAvatarWithWrapperWidthSmall)];
    }
    return _userAvatar;
}

- (UILabel *)nicknameLabel {
    if (!_nicknameLabel) {
        _nicknameLabel = [UILabel new];
        _nicknameLabel.textColor = [UIColor titleTextColor];
        _nicknameLabel.font = [UIFont systemFontOfSize:self.commentViewSize == CommentViewSizeNormal ? ListContentFontSize : ListIntroductionFontSize weight:UIFontWeightSemibold];
        _nicknameLabel.numberOfLines = 1;
        _nicknameLabel.myHeight = MyLayoutSize.wrap;
    }
    return _nicknameLabel;
}

- (ImageButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [[ImageButton alloc]initWithFrame:CGRectMake(0, 0, 24, 24) imageName:@"ic_more"];
    }
    return _moreButton;
}

- (YYLabel *)contentTextLabel {
    if (!_contentTextLabel) {
        _contentTextLabel = [[YYLabel alloc]init];
        _contentTextLabel.myHeight = MyLayoutSize.wrap;
        _contentTextLabel.textColor = [UIColor contentTextColor];
        _contentTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _contentTextLabel.numberOfLines = self.commentViewSize == CommentViewSizeNormal ? 0 : ContentTextUnexpandNumberOfLines;
    }
    return _contentTextLabel;
}

- (UILabel *)createTimeLabel {
    if (!_createTimeLabel) {
        _createTimeLabel = [UILabel new];
        _createTimeLabel.font = [UIFont systemFontOfSize:ListMetaFontSize];
        _createTimeLabel.textColor = [UIColor metaTextColor];
    }
    return _createTimeLabel;
}

- (ImageButton *)replyButton {
    if (!_replyButton) {
        _replyButton = [[ImageButton alloc]initWithFrame:CGRectMake(0, 0, 16, 16) imageName:@"ic_reply"];
    }
    return _replyButton;
}

- (LEECoolButton *)commentVoteButton {
    if (!_commentVoteButton) {
        _commentVoteButton = [LEECoolButton coolButtonWithImage:[UIImage imageNamed:@"ic_thumb_up"] ImageFrame:CGRectMake(10, 10, 12, 12)];
        _commentVoteButton.frame = CGRectMake(0, 0, 24, 24);
        _commentVoteButton.imageColorOn = [UIColor mainColor];
        _commentVoteButton.circleColor = [UIColor colorWithRed:52 / 255.0f green:152 / 255.0f blue:219 / 255.0f alpha:1.0f];
        _commentVoteButton.lineColor = [UIColor colorWithRed:41 / 255.0f green:128 / 255.0f blue:185 / 255.0f alpha:1.0f];
    }
    return _commentVoteButton;
}

- (NSString *)filterBlankAndBlankLines:(NSString *)str
{
    NSMutableString *Mstr = [NSMutableString string];

    NSArray *arr = [[str stringByReplacingOccurrencesOfString:@"\%n" withString:@"\n"] componentsSeparatedByString:@"\n"];

    for (int i = 0; i < arr.count; i++) {
        NSString *tempStr = (NSString *)arr[i];
        [tempStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        [tempStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        [tempStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
        if (tempStr.length != 0) {
            [Mstr appendString:arr[i]];
            if (i < [arr count] - 1) {
                [Mstr appendString:@"\n"];
            }
        }
    }

    return Mstr;
}

@end
