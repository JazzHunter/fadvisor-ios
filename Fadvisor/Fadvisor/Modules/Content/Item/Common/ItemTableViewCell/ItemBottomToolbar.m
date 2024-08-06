//
//  ItemBottomToolbar.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/6/25.
//

#import "ItemBottomToolbar.h"
#import "Utils.h"
#import "ImageButton.h"
#import "ImageTextHButton.h"

@interface ItemBottomToolbar ()

@property (nonatomic, strong) UILabel *infoLabel;

@property (nonatomic, strong) ImageTextHButton *voteButton;
@property (nonatomic, strong) ImageButton *moreButton;

@end

@implementation ItemBottomToolbar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.padding = UIEdgeInsetsMake(10, 0, 10, 0);

    _infoLabel = [UILabel new];
    _infoLabel.textColor = [UIColor metaTextColor];
    _infoLabel.font =  [UIFont systemFontOfSize:ListMetaFontSize];

    _infoLabel.leftPos.equalTo(self.leftPos);
    _infoLabel.topPos.equalTo(self.topPos);
    [self addSubview:_infoLabel];

    _voteButton = [[ImageTextHButton alloc] initWithFrame:CGRectMake(0, 0, 88, 15)];
    _voteButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_voteButton setImage:[[[UIImage imageNamed:@"ic_heart"] imageWithTintColor:[UIColor metaTextColor]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_voteButton setImage:[[[UIImage imageNamed:@"ic_heart_solid"] imageWithTintColor:[UIColor mainColor]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];

    [_voteButton setImageSize:CGSizeMake(IconImgHeight, IconImgHeight)];

    _voteButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_voteButton setTitleColor:[UIColor metaTextColor] forState:UIControlStateNormal];
    [_voteButton setTitleColor:[UIColor mainColor] forState:UIControlStateSelected];
    [_voteButton setTitle:@"感谢支持" forState:UIControlStateSelected];

    _voteButton.leftPos.equalTo(_infoLabel.rightPos).offset(8);
    _voteButton.centerYPos.equalTo(_infoLabel.centerYPos);

    [self addSubview:_voteButton];

    [_voteButton addTarget:self action:@selector(voteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    _moreButton = [[ImageButton alloc]initWithFrame:CGRectMake(0, 0, IconImgHeight, IconImgHeight) imageName:@"ic_more"];
    _moreButton.rightPos.equalTo(self.rightPos);
    _moreButton.centerYPos.equalTo(_infoLabel.centerYPos);
    [self addSubview:_moreButton];
}

- (void)setModel:(ItemModel *)model {
    _infoLabel.text = [NSString stringWithFormat:@"%@ · %@阅读", [Utils formatBackendTimeString:model.pubTime], [Utils shortedNumberDesc:model.viewCount]];
    [_infoLabel sizeToFit];

    _voteButton.selected = model.voted;
    if (!_voteButton.selected) {
        [_voteButton setTitle: [NSString stringWithFormat:@"%@", [Utils shortedNumberDesc:model.viewCount]] forState:UIControlStateNormal];
    }
}

#pragma mark Action
- (void)voteButtonClicked:(UIButton *)voteButton {
    voteButton.selected = !voteButton.selected;
    if (voteButton.selected) {
        // 连续放大和缩小动画
        [UIView animateWithDuration:0.3 animations:^{
            voteButton.transform = CGAffineTransformMakeScale(1.2, 1.2);     // 放大
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                voteButton.transform = CGAffineTransformIdentity;     // 缩小
            }];
        }];
    }
}

@end
