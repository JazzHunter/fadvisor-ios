//
//  VoteButton.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/8/13.
//


#import "VoteVButton.h"
#import "LEECoolButton.h"

@interface VoteVButton ()

@property (nonatomic, strong) LEECoolButton *iconButton;
@property (nonatomic, strong) UIButton *textLabelButton;

@property (nonatomic, strong) ItemModel *itemModel;

@end

@implementation VoteVButton

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

    _iconButton = [LEECoolButton coolButtonWithImage:[UIImage imageNamed:@"ic_heart_solid"] ImageFrame:CGRectMake(0, 0, IconWidth, IconWidth)];
    _iconButton.frame = CGRectMake(0, 0, IconWidth, IconWidth);
    _iconButton.imageColorOn = [UIColor mainColor];
    _iconButton.circleColor = [UIColor mainColor];
    _iconButton.lineColor = [UIColor colorWithRed:226 / 255.0f green:96 / 255.0f blue:96 / 255.0f alpha:1.0f];

    [_iconButton addTarget:self action:@selector(toggle:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:_iconButton];

    _textLabelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _textLabelButton.myWidth = MyLayoutSize.wrap;
    _textLabelButton.myHeight = 13;
    _textLabelButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_textLabelButton setTitleColor:[UIColor metaTextColor] forState:UIControlStateNormal];
    [_textLabelButton setTitle:@"点赞" forState:UIControlStateNormal];
    [_textLabelButton setTitle:@"感谢支持" forState:UIControlStateSelected];
    [_textLabelButton addTarget:self action:@selector(toggle:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_textLabelButton];
}

- (void)setModel:(ItemModel *)model {
    self.itemModel = model;
    self.voted = model.voted;
    self.voted = YES;

    self.iconButton.selected = self.voted;
    [self handleTextButtonToggled:self.voted];
}

- (void)toggle:(UIView *)sender {
    self.voted = !self.voted;
    [self handleIconToggled:self.voted];
    [self handleTextButtonToggled:self.voted];
}

- (void)handleIconToggled:(BOOL)voted {
    if (self.voted) {
        [self.iconButton select];
        UIImpactFeedbackGenerator *impactLight = [[UIImpactFeedbackGenerator alloc]initWithStyle:UIImpactFeedbackStyleLight];
        [impactLight impactOccurred];
    } else {
        [self.iconButton deselect];
    }
}

- (void)handleTextButtonToggled:(BOOL)voted {
    self.textLabelButton.selected = voted;
    [self.textLabelButton sizeToFit];
}

@end
