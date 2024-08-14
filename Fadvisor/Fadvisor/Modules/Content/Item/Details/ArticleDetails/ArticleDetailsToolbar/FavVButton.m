//
//  VoteButton.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/8/13.
//


#import "FavVButton.h"
#import "LEECoolButton.h"

@interface FavVButton ()

@property (nonatomic, strong) LEECoolButton *iconButton;
@property (nonatomic, strong) UIButton *textLabelButton;

@property (nonatomic, strong) ItemModel *itemModel;

@end

@implementation FavVButton

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
    [self setTarget:self action:@selector(toggle:)];

    _iconButton = [LEECoolButton coolButtonWithImage:[UIImage imageNamed:@"ic_star"] ImageFrame:CGRectMake(0, 0, IconWidth, IconWidth)];
    _iconButton.frame = CGRectMake(0, 0, IconWidth, IconWidth);

    [_iconButton addTarget:self action:@selector(toggle:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:_iconButton];

    _textLabelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _textLabelButton.myWidth = MyLayoutSize.wrap;
    _textLabelButton.myHeight = 13;
    _textLabelButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_textLabelButton setTitleColor:[UIColor metaTextColor] forState:UIControlStateNormal];
    [_textLabelButton setTitle:@"收藏" forState:UIControlStateNormal];
    [_textLabelButton setTitle:@"已收藏" forState:UIControlStateSelected];
    [_textLabelButton addTarget:self action:@selector(toggle:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_textLabelButton];
}

- (void)setModel:(ItemModel *)model {
    self.itemModel = model;
    self.faved = model.faved;
    self.faved = YES;

    self.iconButton.selected = self.faved;
    [self handleTextButtonToggled:self.faved];
}

- (void)toggle:(UIView *)sender {
    self.faved = !self.faved;
    [self handleIconToggled:self.faved];
    [self handleTextButtonToggled:self.faved];
}

- (void)handleIconToggled:(BOOL)faved {
    if (self.faved) {
        [self.iconButton select];
        UIImpactFeedbackGenerator *impactLight = [[UIImpactFeedbackGenerator alloc]initWithStyle:UIImpactFeedbackStyleLight];
        [impactLight impactOccurred];
    } else {
        [self.iconButton deselect];
    }
}

- (void)handleTextButtonToggled:(BOOL)faved {
    self.textLabelButton.selected = faved;
    [self.textLabelButton sizeToFit];
}

@end
