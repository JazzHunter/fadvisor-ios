//
//  FavHButton.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/9/29.
//

#define IconWidth 16

#import "FavHButton.h"
#import "LEECoolButton.h"

@interface FavHButton ()

@property (nonatomic, strong) LEECoolButton *iconButton;
@property (nonatomic, strong) UIButton *textLabelButton;

@property (nonatomic, strong) ItemModel *itemModel;

@end

#import "FavHButton.h"

@implementation FavHButton

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

    _iconButton = [LEECoolButton coolButtonWithImage:[UIImage imageNamed:@"ic_star_solid"] ImageFrame:CGRectMake(0, 0, IconWidth, IconWidth)];
    _iconButton.frame = CGRectMake(0, 0, IconWidth, IconWidth);
//    _iconButton.imageColorOn = [UIColor mainColor];
//    _iconButton.circleColor = [UIColor mainColor];
//    _iconButton.lineColor = [UIColor colorWithRed:226 / 255.0f green:96 / 255.0f blue:96 / 255.0f alpha:1.0f];

    [_iconButton addTarget:self action:@selector(toggle:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:_iconButton];

    _textLabelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _textLabelButton.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
    _textLabelButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_textLabelButton setTitleColor:[UIColor metaTextColor] forState:UIControlStateNormal];
    [_textLabelButton setTitle:@"点赞" forState:UIControlStateNormal];
    [_textLabelButton setTitle:@"感谢支持" forState:UIControlStateSelected];
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
    } else {
        [self.iconButton deselect];
    }
}

- (void)handleTextButtonToggled:(BOOL)faved {
    self.textLabelButton.selected = faved;
    [self.textLabelButton sizeToFit];
}


@end
