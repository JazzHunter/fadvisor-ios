//
//  AuthorFollowButton.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/24.
//

#import "AuthorFollowButton.h"
#import "AuthorFollowService.h"
#import "AccountManager.h"
#import "ContentActionEventType.h"

@interface AuthorFollowButton ()

@property (nonatomic, strong) AuthorFollowService *authorFollowService;

@end

@implementation AuthorFollowButton

#pragma mark - Life Cycle

- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, AuthorFollowButtonWidth, AuthorFollowButtonHeight)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:14];

        [self setTitle:[@"FollowBtnNoraml" localString] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor mainColor] forState:UIControlStateNormal];

        [self setTitle:[@"FollowBtSelected" localString] forState:UIControlStateSelected];
        [self setBackgroundColor:[UIColor descriptionTextColor] forState:UIControlStateSelected];

        [self addTarget:self action:@selector(followButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFollowChanged:) name:EVENT_AUTHOR_FOLLOW_TOGGLE object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Actions

- (void)followButtonClicked:(UIButton *)sender {
    if (!ACCOUNT_MANAGER.isLogin) {
        NSLog(@"没有登录没有登录没有登录没有登录没有登录");
        return;
    }

    if (self.authorFollowService.isLoading) {
        return;
    }

    [self.authorFollowService toggleAuthorFollow:!self.isSubscribed authorId:self.authorId completion:^(NSString *errorMsg) {
        if (errorMsg) {
            //有错误处理一下
            return;
        }

        // 发送通知
        NSDictionary *userInfo = @{ @"authorId": self.authorId, @"isSubscribed": @(!self.isSubscribed) };
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_AUTHOR_FOLLOW_TOGGLE object:userInfo];
    }];
}

- (void)handleFollowChanged:(NSNotification *)notif {
    NSDictionary *info = notif.userInfo;
    if (!info) {
        return;
    }
    NSString *authorId = info[@"authorId"];
    if (!authorId || ![authorId isEqualToString:self.authorId]) {
        return;
    }

    self.subscribed = [[info objectForKey:@"isSubscribed"] boolValue];
    self.selected = self.isSubscribed;
}

#pragma mark - set & get

- (AuthorFollowService *)authorFollowService {
    if (!_authorFollowService) {
        _authorFollowService = [[AuthorFollowService alloc] init];
    }
    return _authorFollowService;
}

@end
