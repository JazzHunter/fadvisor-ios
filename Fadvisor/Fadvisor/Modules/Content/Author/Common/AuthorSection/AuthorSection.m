//
//  AuthorSection.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/8/7.
//

#import "AuthorSection.h"
#import "AuthorInList.h"
#import "AuthorAvatarWithWrapper.h"
#import "AuthorSectionAuthorsViewController.h"
#import <HWPanModal/HWPanModal.h>

@interface AuthorSection ()

@property (nonatomic, strong) NSArray <AuthorModel *> *authorModels;
@property (nonatomic, strong) AuthorSectionAuthorsViewController *authorsViewController;

@end

@implementation AuthorSection

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

- (void)setModels:(NSArray< AuthorModel *> *)models {
    [self removeAllSubviews];
    self.authorModels = [NSArray arrayWithArray:models];
    [self setTarget:self action:@selector(handleClicked:)];

    if (models.count == 1) {
        AuthorInList *authorInList = [AuthorInList new];
        [authorInList setModel:models[0]];
        [self addSubview:authorInList];
    } else {
        NSUInteger count = models.count > 5 ? 5 : models.count;
        NSString *descString = @"";

        AuthorAvatarWithWrapper *previousAvatar;

        for (int i = 0; i < count; i++) {
            AuthorAvatarWithWrapper *avatar = [AuthorAvatarWithWrapper new];
            [avatar setAvatarUrl:models[i].avatar];
            avatar.backgroundColor = [UIColor backgroundColor];
            avatar.centerYPos.equalTo(self.centerYPos);
            if (i >= 1) {
                avatar.leftPos.equalTo(previousAvatar.rightPos).offset(-12);
            } else {
                avatar.leftPos.equalTo(self.leftPos);
            }
            previousAvatar = avatar;
            [self addSubview:avatar];

            //拼接描述文字
            descString = [descString stringByAppendingFormat:@"%@、", models[i].name];
        }
        // 移除最后的逗号
        descString = [descString substringToIndex:descString.length - 1];
        descString = [NSString stringWithFormat:@"%@共 %ld 位作者", descString, models.count];

        UILabel *descLabel = [UILabel new];
        descLabel.font = [UIFont systemFontOfSize:ListIntroductionFontSize];
        descLabel.textColor = [UIColor descriptionTextColor];
        descLabel.centerYPos.equalTo(self.centerYPos);
        descLabel.leftPos.equalTo(previousAvatar.rightPos).offset(12);
        descLabel.rightPos.equalTo(self.rightPos);
        descLabel.myHeight = MyLayoutSize.wrap;
        descLabel.text = descString;
        [self addSubview:descLabel];
    }
}

- (void)handleClicked:(MyBaseLayout *)sender {
    if (self.authorModels.count <= 1) {
        return;
    }
    
    [self.viewController presentPanModal:self.authorsViewController];
}

#pragma mark - Setters & Getters

- (AuthorSectionAuthorsViewController *)authorsViewController {
    if (!_authorsViewController) {
        _authorsViewController = [[AuthorSectionAuthorsViewController alloc] initWithModels:self.authorModels];
    }
    return _authorsViewController;
}

@end
