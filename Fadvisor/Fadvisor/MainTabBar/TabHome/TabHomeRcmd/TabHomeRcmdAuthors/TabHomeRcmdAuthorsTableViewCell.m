//
//  TabHomeRcmdAuthorsScrollView.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/7/13.
//

#import "TabHomeRcmdAuthorsTableViewCell.h"
#import "TabHomeRcmdAuthorCard.h"
#import "AuthorDetailsViewController.h"
#import "TABAnimated.h"

@interface TabHomeRcmdAuthorsTableViewCell () <UIScrollViewDelegate, TabHomeRcmdAuthorCardDelegate>

@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) MyLinearLayout *contentLayout;
@property (nonatomic, strong) CAShapeLayer *rightBezier;
@property (nonatomic, strong) UILabel *tipLabel;
@property (atomic, assign) CGFloat distanceX;

@property (nonatomic, strong) MyLinearLayout *skeletonLayout;

@end

@implementation TabHomeRcmdAuthorsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        [self createLayout];
        //如果是代码实现autolayout的话必须要将translatesAutoresizingMaskIntoConstraints 设置为NO。
        _rootLayout.translatesAutoresizingMaskIntoConstraints = NO;

        //设置布局视图的autolayout约束，这里是用iOS9提供的约束设置方法，您也可以用低级版本设置，以及用masonry来进行设置。
        [_rootLayout.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor].active = YES;
        [_rootLayout.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
        //目前MyLayout和AutoLayout相结合并且高度根据宽度自适应时只能通过明确设置宽度约束，暂时不支持同时设置左右约束来确定宽度的能力。
        [_rootLayout.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor].active = YES;

        //这句代码很关键，表明self.contentView的高度随着子视图_rootLayout的高度自适应。
        [self.contentView.bottomAnchor constraintEqualToAnchor:_rootLayout.bottomAnchor constant:0].active = YES;
    }

    return self;
}

#pragma mark -- Layout Construction

//用线性布局来实现UI界面
- (void)createLayout
{
    self.contentView.backgroundColor = [UIColor backgroundColorGray];
    _rootLayout = [MyRelativeLayout new];
    _rootLayout.padding = UIEdgeInsetsMake(10, 16, 10, 16);

    //这个属性只局限于在UITableViewCell中使用，用来优化tableviewcell的高度自适应的性能，其他地方请不要使用！！！
    _rootLayout.cacheEstimatedRect = YES;
    _rootLayout.heightSize.equalTo(@(MyLayoutSize.wrap));
    _rootLayout.widthSize.equalTo(nil);
    [self.contentView addSubview:_rootLayout];

    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor titleTextColor];
    titleLabel.font =  [UIFont systemFontOfSize:ListTitleFontSize];
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    titleLabel.leftPos.equalTo(_rootLayout.leftPos);
    titleLabel.topPos.equalTo(_rootLayout.topPos);
    titleLabel.text = @"推荐的作者";
    [titleLabel sizeToFit];
    [_rootLayout addSubview:titleLabel];

    _contentScrollView = [[UIScrollView alloc] init];
    _contentScrollView.myHorzMargin = 0;
//    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.heightSize.equalTo(@AuthorCardViewHeight);
    _contentScrollView.delegate = self;
    _contentScrollView.topPos.equalTo(titleLabel.bottomPos).offset(5);
    _contentScrollView.leftPos.equalTo(titleLabel.leftPos);
    [_rootLayout addSubview:_contentScrollView];

    _contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    _contentLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0); //设置布局内的子视图离自己的边距.
    _contentLayout.myVertMargin = 0;                          //同时指定左右边距为0表示宽度和父视图一样宽
    _contentLayout.subviewHSpace = 8;
    _contentLayout.widthSize.lBound(_contentScrollView.widthSize, 0, 1);
    [_contentScrollView addSubview:_contentLayout];

    self.rightBezier = [CAShapeLayer layer];
    self.rightBezier.fillColor = [UIColor backgroundColor].CGColor;
    self.rightBezier.strokeColor = [UIColor backgroundColor].CGColor;

    _tipLabel = [[UILabel alloc] init];
    _tipLabel.font = [UIFont systemFontOfSize:14];
    _tipLabel.textColor = [UIColor titleTextColor];
    _tipLabel.verticalText = @"查看更多";
    [_tipLabel sizeToFit];

    _tipLabel.centerYPos.equalTo(_contentScrollView.centerYPos);
    _tipLabel.rightPos.equalTo(_rootLayout.rightPos).offset(-10);

    // 创建骨架视图
    _skeletonLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    _skeletonLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0); //设置布局内的子视图离自己的边距.
    _skeletonLayout.myVertMargin = 0;                          //同时指定左右边距为0表示宽度和父视图一样宽
    _skeletonLayout.subviewHSpace = 8;
    _skeletonLayout.widthSize.lBound(_contentScrollView.widthSize, 0, 1);
    _skeletonLayout.topPos.equalTo(titleLabel.bottomPos).offset(5);
    _skeletonLayout.leftPos.equalTo(titleLabel.leftPos);
    for (int i = 0; i < 8; i++) {
        TabHomeRcmdAuthorCard *authorCard = [TabHomeRcmdAuthorCard new];
        [authorCard layoutIfNeeded];
        authorCard.tabAnimated = TABViewAnimated.new;
        authorCard.tabAnimated.canLoadAgain = YES;
        authorCard.tabAnimated.superAnimationType = TABViewSuperAnimationTypeShimmer;
        [_skeletonLayout addSubview:authorCard];
    }
}

- (void)setAuthorModels:(NSArray<AuthorModel *> *)authorModels {
    [self.contentLayout removeAllSubviews];
    for (AuthorModel *model in authorModels) {
        TabHomeRcmdAuthorCard *authorCard = [[TabHomeRcmdAuthorCard alloc] initWithModel:model];
        authorCard.delegate = self;
        [_contentLayout addSubview:authorCard];
    }
}

- (void)showLoading {
    for (UIView *subView in self.skeletonLayout.subviews) {
        [subView tab_startAnimation];
    }
    [_rootLayout addSubview:_skeletonLayout];
}

- (void)hideLoading {
    for (UIView *subView in self.skeletonLayout.subviews) {
        [subView tab_endAnimation];
    }
    [_skeletonLayout removeFromSuperview];
}

#pragma mark - TabHomeRcmdAuthorCardDelegate

- (void)onTabHomeRcmdAuthorCardTapped:(MyBaseLayout *)sender withModel:(AuthorModel *)model {
    AuthorDetailsViewController *vc = [[AuthorDetailsViewController alloc] initWithAuthor:model];
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ScrollViewDelgate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentWidth = scrollView.contentSize.width;
    _distanceX = scrollView.contentOffset.x - contentWidth + scrollView.width;

    if (_distanceX < 0) {
        if (self.rightBezier.superlayer) {
            [self.rightBezier removeFromSuperlayer];
        }
        return;
    }

    if (!self.rightBezier.superlayer) {
        [self.rootLayout.layer addSublayer:self.rightBezier];
    }

    self.rightBezier.path = [self getPathWithMoveDistance:_distanceX];
    if (_distanceX > 80) {
        [_rootLayout addSubview:_tipLabel];
    } else {
        [_tipLabel removeFromSuperview];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_distanceX > 80) {
        UIImpactFeedbackGenerator *impactLight = [[UIImpactFeedbackGenerator alloc]initWithStyle:UIImpactFeedbackStyleLight];
        [impactLight impactOccurred];
    }
}

//根据y值获取贝塞尔路径
- (CGPathRef)getPathWithMoveDistance:(CGFloat)distance {
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint startPoint = CGPointMake(self.rootLayout.width, self.contentScrollView.top);
    CGPoint controlPoint = CGPointMake(self.rootLayout.width - distance, self.contentScrollView.top + self.contentScrollView.height * 0.5);
    CGPoint endPoint = CGPointMake(self.rootLayout.width, self.contentScrollView.bottom);

    [path moveToPoint:startPoint];
    [path addQuadCurveToPoint:endPoint controlPoint:controlPoint];

    [path addLineToPoint:CGPointMake(self.rootLayout.width, self.contentScrollView.top)];

    return path.CGPath;
}

@end
