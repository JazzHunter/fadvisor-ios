//
//  VoteButton.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/8/13.
//

#define IconWidth 16

#import "VoteHButton.h"
#import "LEECoolButton.h"

@interface VoteHButton ()

@property (nonatomic, strong) LEECoolButton *voteIcon;
@property (nonatomic, strong) UIButton *voteTextLabel;

@property (nonatomic, strong) ItemModel *itemModel;

@end

@implementation VoteHButton

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
    self.orientation = MyOrientation_Horz;
    self.subviewHSpace = 4;
    self.gravity = MyGravity_Vert_Center;
    self.highlightedBackgroundColor = [UIColor redColor];

    _voteIcon = [LEECoolButton coolButtonWithImage:[UIImage imageNamed:@"ic_heart_solid"] ImageFrame:CGRectMake(0, 0, IconWidth, IconWidth)];
    _voteIcon.frame = CGRectMake(0, 0, IconWidth, IconWidth);
    _voteIcon.imageColorOn = [UIColor mainColor];
    _voteIcon.circleColor = [UIColor mainColor];
    _voteIcon.lineColor = [UIColor colorWithRed:226 / 255.0f green:96 / 255.0f blue:96 / 255.0f alpha:1.0f];

    [_voteIcon addTarget:self action:@selector(toggle:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:_voteIcon];

    _voteTextLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    _voteTextLabel.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
    _voteTextLabel.titleLabel.font = [UIFont systemFontOfSize:13];
    [_voteTextLabel setTitleColor:[UIColor metaTextColor] forState:UIControlStateNormal];
    [_voteTextLabel setTitle:@"点赞" forState:UIControlStateNormal];
    [_voteTextLabel setTitle:@"感谢支持" forState:UIControlStateSelected];
    [_voteTextLabel addTarget:self action:@selector(toggle:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_voteTextLabel];
}

- (void)setModel:(ItemModel *)model {
    self.itemModel = model;
    self.voted = model.voted;
    self.voted = YES;

    self.voteIcon.selected = self.voted;
    [self handleTextButtonToggled:self.voted];
}

- (void)toggle:(UIView *)sender {
    self.voted = !self.voted;
    [self handleIconToggled:self.voted];
    [self handleTextButtonToggled:self.voted];
}

- (void)handleIconToggled:(BOOL)voted {
    if (self.voted) {
        [self.voteIcon select];
    } else {
        [self.voteIcon deselect];
    }
}

- (void)handleTextButtonToggled:(BOOL)voted {
    self.voteTextLabel.selected = voted;
    [self.voteTextLabel sizeToFit];
}

@end
