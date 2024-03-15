//
//  TabAccountNavigationView.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/3/11.
//

#import "TabAccountNavigationView.h"
#import "ImageButton.h"

#define btnSize 26.f

@implementation TabAccountNavigationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.orientation = MyOrientation_Horz;
        self.gravity = MyGravity_Vert_Center;
        self.subviewHSpace = 16;
        self.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);

        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    ImageButton *scanButton = [[ImageButton alloc] initWithFrame:CGRectMake(0, 0, btnSize, btnSize) imageName:@"ic_scan" color:[UIColor metaTextColor]];
//    scanButton.imageSize = CGSizeMake(12, 12);
    [scanButton addTarget:self action:@selector(scanBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:scanButton];

    ImageButton *searchButton = [[ImageButton alloc] initWithFrame:CGRectMake(0, 0, btnSize, btnSize) imageName:@"ic_search" color:[UIColor metaTextColor]];
//    searchButton.imageSize = CGSizeMake(12, 12);
    [searchButton addTarget:self action:@selector(searchBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:searchButton];

    ImageButton *settingButton = [[ImageButton alloc] initWithFrame:CGRectMake(0, 0, btnSize, btnSize) imageName:@"ic_setting" color:[UIColor metaTextColor]];
//    settingButton.imageSize = CGSizeMake(12, 12);
    [settingButton addTarget:self action:@selector(settingBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:settingButton];

    ImageButton *messageButton = [[ImageButton alloc] initWithFrame:CGRectMake(0, 0, btnSize, btnSize) imageName:@"ic_message" color:[UIColor metaTextColor]];
//    messageButton.imageSize = CGSizeMake(12, 12);
    [messageButton addTarget:self action:@selector(messageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:messageButton];
    
}

- (void)scanBtnClicked:(UIButton *)sender {
}

- (void)searchBtnClicked:(UIButton *)sender {
}

- (void)settingBtnClicked:(UIButton *)sender {
}

- (void)messageBtnClicked:(UIButton *)sender {
}

@end
