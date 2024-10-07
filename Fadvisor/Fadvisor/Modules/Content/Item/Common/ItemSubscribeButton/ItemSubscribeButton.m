//
//  ItemSubscribeButton.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/9/28.
//

#import "ItemSubscribeButton.h"
#import "ItemSubscribeService.h"
#import "AccountManager.h"
#import "ContentActionEventType.h"

@interface ItemSubscribeButton ()

@property (nonatomic, strong) ItemSubscribeService *itemSubscribeService;

@end

@implementation ItemSubscribeButton

#pragma mark - Life Cycle

- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, ItemSubscribeButtonWidth, ItemSubscribeButtonHeight)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:14];

        [self setTitle:[@"SubscribeBtnNoraml" localString] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor mainColor] forState:UIControlStateNormal];

        [self setTitle:[@"SubscribeBtnSelected" localString] forState:UIControlStateSelected];
        [self setBackgroundColor:[UIColor descriptionTextColor] forState:UIControlStateSelected];

        [self addTarget:self action:@selector(subscribeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSubscribeChanged:) name:EVENT_ITEM_SUBSCRIBE_TOGGLE object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Actions

- (void)subscribeButtonClicked:(UIButton *)sender {
    if (!ACCOUNT_MANAGER.isLogin) {
        NSLog(@"没有登录没有登录没有登录没有登录没有登录");
        return;
    }

    if (self.itemSubscribeService.isLoading) {
        return;
    }

    [self.itemSubscribeService toggleItemSubscribe:!self.isSubscribed authorId:self.itemId completion:^(NSString *errorMsg) {
        if (errorMsg) {
            //有错误处理一下
            return;
        }

        // 发送通知
        NSDictionary *userInfo = @{ @"itemId": self.itemId, @"isSubscribed": @(!self.isSubscribed) };
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_ITEM_SUBSCRIBE_TOGGLE object:userInfo];
    }];
}

- (void)handleSubscribeChanged:(NSNotification *)notif {
    NSDictionary *info = notif.userInfo;
    if (!info) {
        return;
    }
    NSString *itemId = info[@"itemId"];
    if (!itemId || ![itemId isEqualToString:self.itemId]) {
        return;
    }

    self.subscribed = [[info objectForKey:@"isSubscribed"] boolValue];
    self.selected = self.isSubscribed;
}

#pragma mark - set & get

- (ItemSubscribeService *)itemSubscribeService {
    if (!_itemSubscribeService) {
        _itemSubscribeService = [[ItemSubscribeService alloc] init];
    }
    return _itemSubscribeService;
}

@end
