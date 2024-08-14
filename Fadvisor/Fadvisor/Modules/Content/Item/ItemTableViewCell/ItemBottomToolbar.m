//
//  ItemBottomToolbar.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/6/25.
//

#import "ItemBottomToolbar.h"
#import "Utils.h"
#import "ImageButton.h"
#import "VoteHButton.h"

@interface ItemBottomToolbar ()

@property (nonatomic, strong) UILabel *infoLabel;

@property (nonatomic, strong) VoteHButton *voteButton;

@property (nonatomic, strong) ImageButton *moreButton;

@end

@implementation ItemBottomToolbar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.myHeight = MyLayoutSize.wrap;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _infoLabel = [UILabel new];
    _infoLabel.textColor = [UIColor metaTextColor];
    _infoLabel.font =  [UIFont systemFontOfSize:ListMetaFontSize];

    _infoLabel.leftPos.equalTo(self.leftPos);
    _infoLabel.topPos.equalTo(self.topPos);
    [self addSubview:_infoLabel];

    _voteButton = [VoteHButton new];
    _voteButton.leftPos.equalTo(_infoLabel.rightPos).offset(8);
    _voteButton.centerYPos.equalTo(_infoLabel.centerYPos);

    [self addSubview:_voteButton];


    _moreButton = [[ImageButton alloc]initWithFrame:CGRectMake(0, 0, IconImgHeight, IconImgHeight) imageName:@"ic_more"];
    _moreButton.rightPos.equalTo(self.rightPos);
    _moreButton.centerYPos.equalTo(_infoLabel.centerYPos);
    [self addSubview:_moreButton];
}

- (void)setModel:(ItemModel *)model {
    _infoLabel.text = [NSString stringWithFormat:@"%@ · %@阅读 · ", [Utils formatBackendTimeString:model.pubTime], [Utils shortedNumberDesc:model.viewCount]];
    [_infoLabel sizeToFit];

    [self.voteButton setModel:model];
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
