//
//  ShareVButton.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/8/14.
//

#import "ShareVButton.h"
#import "ImageButton.h"
#import "SharePanel.h"

@interface ShareVButton()

@property (nonatomic, strong) ImageButton *iconButton;
@property (nonatomic, strong) UIButton *textLabelButton;

@property (nonatomic, strong) ItemModel *itemModel;

@end

@implementation ShareVButton

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.myHeight = MyLayoutSize.wrap;
    self.orientation = MyOrientation_Vert;
    self.subviewVSpace = 4;
    self.gravity = MyGravity_Horz_Center;
    [self setTarget:self action:@selector(tapped:)];

    _iconButton = [[ImageButton alloc] initWithFrame:CGRectMake(0, 0, IconWidth, IconWidth)];
    [_iconButton setImage:[[[UIImage imageNamed:@"ic_share"] imageWithTintColor:[UIColor metaTextColor]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_iconButton enableTouchDownAnimation];
    [_iconButton addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:_iconButton];

    _textLabelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _textLabelButton.myWidth = MyLayoutSize.wrap;
    _textLabelButton.myHeight = 13;
    _textLabelButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_textLabelButton setTitleColor:[UIColor metaTextColor] forState:UIControlStateNormal];
    [_textLabelButton setTitle:@"分享" forState:UIControlStateNormal];
    [_textLabelButton addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_textLabelButton];
}

- (void)setModel:(ItemModel *)model {
    self.itemModel = model;

}

- (void)tapped:(UIView *)sender {
    UIImpactFeedbackGenerator *impactLight = [[UIImpactFeedbackGenerator alloc]initWithStyle:UIImpactFeedbackStyleLight];
    [impactLight impactOccurred];
    [[SharePanel manager] showPanelWithItem:self.itemModel];

}

@end
