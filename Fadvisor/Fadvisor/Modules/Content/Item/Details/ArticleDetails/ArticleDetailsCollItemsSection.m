//
//  ArticleDetailsCollItemsSection.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/8/12.
//

#import "ArticleDetailsCollItemsSection.h"
#import "PopCollItemsViewController.h"
#import <HWPanModal/HWPanModal.h>

@interface ArticleDetailsCollItemsSection ()

@property (nonatomic, strong) ItemModel *collectionModel;
@property (nonatomic, strong) ItemModel *itemModel;

@property (nonatomic, strong) UIButton *collectionTitleButton;

@property (nonatomic, strong) MyRelativeLayout *previousItemLayout;
@property (nonatomic, strong) UILabel *previousItemTitleLabel;

@property (nonatomic, strong) MyRelativeLayout *nextItemLayout;
@property (nonatomic, strong) UILabel *nextItemTitleLabel;

@property (nonatomic, strong) PopCollItemsViewController *popCollItemsVC;

@end

@implementation ArticleDetailsCollItemsSection

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 8;
        self.padding = UIEdgeInsetsMake(16, 16, 16, 16);
        self.myHeight = MyLayoutSize.wrap;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    UILabel *topLeftDescLabel = [UILabel new];
    topLeftDescLabel.font = [UIFont systemFontOfSize:15];
    topLeftDescLabel.textColor = [UIColor descriptionTextColor];
    topLeftDescLabel.text = @"收录于合集";
    [topLeftDescLabel sizeToFit];

    topLeftDescLabel.leftPos.equalTo(self.leftPos);
    topLeftDescLabel.topPos.equalTo(self.topPos);
    [self addSubview:topLeftDescLabel];

    _collectionTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _collectionTitleButton.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
    _collectionTitleButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    [_collectionTitleButton setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
    _collectionTitleButton.centerYPos.equalTo(topLeftDescLabel.centerYPos);
    _collectionTitleButton.leftPos.equalTo(topLeftDescLabel.rightPos).offset(4);
    [_collectionTitleButton addTarget:self action:@selector(handleTitleButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_collectionTitleButton];

    // 详情按钮
    MyLinearLayout *detailsButtonLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    detailsButtonLayout.subviewHSpace = 4;
    detailsButtonLayout.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
    detailsButtonLayout.gravity = MyGravity_Vert_Center;
    detailsButtonLayout.rightPos.equalTo(self.rightPos);
    detailsButtonLayout.centerYPos.equalTo(topLeftDescLabel.centerYPos);
    [self addSubview:detailsButtonLayout];

    UILabel *detailsTextLabel = [UILabel new];
    detailsTextLabel.font = [UIFont systemFontOfSize:12];
    detailsTextLabel.textColor = [UIColor descriptionTextColor];
    detailsTextLabel.text = @"详情";
    [detailsTextLabel sizeToFit];
    [detailsButtonLayout addSubview:detailsTextLabel];

    UIImageView *detailsArrView = [[UIImageView alloc] initWithImage:[[[UIImage imageNamed:@"ic_right_arr"] imageWithTintColor:[UIColor descriptionTextColor]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    detailsArrView.frame = CGRectMake(0, 0, 12, 12);
    detailsArrView.rightPos.equalTo(detailsButtonLayout.rightPos);
    detailsArrView.centerYPos.equalTo(detailsButtonLayout.centerYPos);
    detailsArrView.contentMode = UIViewContentModeScaleAspectFit;
    [detailsButtonLayout addSubview:detailsArrView];

    MyLinearLayout *bottomLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    bottomLayout.myHorzMargin = 0;
    bottomLayout.subviewHSpace = 8;
    bottomLayout.myHeight = MyLayoutSize.wrap;
    bottomLayout.gravity = MyGravity_Vert_Center;
    bottomLayout.topPos.equalTo(topLeftDescLabel.bottomPos).offset(16);
    bottomLayout.leftPos.equalTo(self.leftPos);
    [self addSubview:bottomLayout];

    // 上一个按钮
    _previousItemLayout = [MyRelativeLayout new];
    _previousItemLayout.weight = 1;
    _previousItemLayout.myHeight = MyLayoutSize.wrap;
    [bottomLayout addSubview:_previousItemLayout];

    UIImageView *previousItemArrView = [[UIImageView alloc] initWithImage:[[[UIImage imageNamed:@"ic_left_arr"] imageWithTintColor:[UIColor titleTextColor]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    previousItemArrView.frame = CGRectMake(0, 0, 14, 14);
    previousItemArrView.leftPos.equalTo(_previousItemLayout.leftPos);
    previousItemArrView.topPos.equalTo(_previousItemLayout.topPos);
    previousItemArrView.contentMode = UIViewContentModeScaleAspectFit;
    [_previousItemLayout addSubview:previousItemArrView];

    UILabel *previousItemTextLabel = [UILabel new];
    previousItemTextLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    previousItemTextLabel.textColor = [UIColor titleTextColor];
    previousItemTextLabel.text = @"上一篇";
    [previousItemTextLabel sizeToFit];
    previousItemTextLabel.leftPos.equalTo(previousItemArrView.rightPos).offset(4);
    previousItemTextLabel.centerYPos.equalTo(previousItemArrView.centerYPos);
    [_previousItemLayout addSubview:previousItemTextLabel];

    _previousItemTitleLabel = [UILabel new];
    _previousItemTitleLabel.myHorzMargin = 0;
    _previousItemTitleLabel.myHeight = MyLayoutSize.wrap;
    _previousItemTitleLabel.numberOfLines = 1;
    _previousItemTitleLabel.font = [UIFont systemFontOfSize:14];
    _previousItemTitleLabel.textColor = [UIColor titleTextColor];

    _previousItemTitleLabel.leftPos.equalTo(_previousItemLayout.leftPos);
    _previousItemTitleLabel.topPos.equalTo(previousItemArrView.bottomPos).offset(4);
    [_previousItemLayout addSubview:_previousItemTitleLabel];

    // 中间的分割线
    UIView *dividerView = [UIView new];
    dividerView.backgroundColor = [UIColor colorFromHexString:@"cccccc"];
    dividerView.myWidth = 1;
    dividerView.myVertMargin = 0;
    [bottomLayout addSubview:dividerView];

    // 下一个按钮
    _nextItemLayout = [MyRelativeLayout new];
    _nextItemLayout.weight = 1;
    _nextItemLayout.myHeight = MyLayoutSize.wrap;
    [bottomLayout addSubview:_nextItemLayout];

    UIImageView *nextItemArrView = [[UIImageView alloc] initWithImage:[[[UIImage imageNamed:@"ic_right_arr"] imageWithTintColor:[UIColor titleTextColor]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    nextItemArrView.frame = CGRectMake(0, 0, 14, 14);
    nextItemArrView.rightPos.equalTo(_nextItemLayout.rightPos);
    nextItemArrView.topPos.equalTo(_nextItemLayout.topPos);
    nextItemArrView.contentMode = UIViewContentModeScaleAspectFit;
    [_nextItemLayout addSubview:nextItemArrView];

    UILabel *nextItemTextLabel = [UILabel new];
    nextItemTextLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    nextItemTextLabel.textColor = [UIColor titleTextColor];
    nextItemTextLabel.text = @"下一篇";
    [nextItemTextLabel sizeToFit];
    nextItemTextLabel.rightPos.equalTo(nextItemArrView.leftPos).offset(4);
    nextItemTextLabel.centerYPos.equalTo(nextItemArrView.centerYPos);
    [_nextItemLayout addSubview:nextItemTextLabel];

    _nextItemTitleLabel = [UILabel new];
    _nextItemTitleLabel.myHorzMargin = 0;
    _nextItemTitleLabel.myHeight = MyLayoutSize.wrap;
    _nextItemTitleLabel.numberOfLines = 1;
    _nextItemTitleLabel.font = [UIFont systemFontOfSize:14];
    _nextItemTitleLabel.textColor = [UIColor titleTextColor];
    _nextItemTitleLabel.textAlignment = NSTextAlignmentRight;

    _nextItemTitleLabel.rightPos.equalTo(_nextItemLayout.rightPos);
    _nextItemTitleLabel.topPos.equalTo(nextItemTextLabel.bottomPos).offset(4);
    [_nextItemLayout addSubview:_nextItemTitleLabel];
}

- (void)setModel:(ItemModel *)model withCollection:(ItemModel *)collection {
    self.itemModel = model;
    
    self.collectionModel = collection ? collection : model.primaryColl;
    
    [_collectionTitleButton setTitle:self.collectionModel.title forState:UIControlStateNormal];
    [_collectionTitleButton sizeToFit];

    _previousItemTitleLabel.text = @"gjweogjweogjwoegwejgow";
    _nextItemTitleLabel.text = @"gjweogjweogjwoegwejgow";
}

- (void)handleTitleButtonTapped:(UIButton *)sender {
    [self.viewController presentPanModal:self.popCollItemsVC completion:^{
        [self.popCollItemsVC setCollection:self.collectionModel];
    }];
}

#pragma mark - getters and setters
- (PopCollItemsViewController *)popCollItemsVC {
    if (_popCollItemsVC == nil) {
        _popCollItemsVC = [PopCollItemsViewController new];
    }
    return _popCollItemsVC;
}

@end
