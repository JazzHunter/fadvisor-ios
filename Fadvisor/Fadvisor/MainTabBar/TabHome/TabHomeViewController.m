//
//  TabAccountViewController.m
//  Fadvisor
//
//  Created by 韩建伟 on 2021/3/20.
//

#import "TabHomeViewController.h"
//#import "JXCategoryView.h"
#import <JXCategoryViewExt/JXCategoryView.h>

#import "JXPagerListRefreshView.h"
#import "TabHomeRcmdViewController.h"

static const CGFloat pinSectionHeaderHeight = 44.f;

@interface TabHomeViewController () <JXCategoryViewDelegate, JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate>

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXPagerView *pagerView;
@property (nonatomic, strong) UIView *headerView;                   //状态栏+导航栏，根UIView
@property (nonatomic, strong) MyBaseLayout *headerViewLayout;       //顶部的布局视图，滑动会透明

@end

@implementation TabHomeViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        //TabBar的配置
        self.tabBarItem.title = [@"TabHomeName" localString];
        self.tabBarItem.image = [[UIImage imageNamed:@"tab_home_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage = [[UIImage alloc] init];
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray <NSString *> *titles = @[@"推荐", @"专题", @"栏目", @"团队"];
    
    _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, pinSectionHeaderHeight)];
    self.categoryView.titles = titles;
    self.categoryView.backgroundColor = [UIColor backgroundColor];
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = [UIColor mainColor];
    self.categoryView.titleColor = [UIColor titleTextColor];
    self.categoryView.titleColorGradientEnabled = YES;
    self.categoryView.titleLabelZoomEnabled = YES;
    self.categoryView.titleLabelStrokeWidthEnabled = YES;
    self.categoryView.titleLabelZoomScale = 1.05;
    self.categoryView.averageCellSpacingEnabled = NO;
    self.categoryView.titleLabelAnchorPointStyle = JXCategoryTitleLabelAnchorPointStyleBottom;

    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = [UIColor mainColor];
    lineView.lineStyle = JXCategoryIndicatorLineStyle_Lengthen;
    self.categoryView.indicators = @[lineView];

    self.pagerView = [[JXPagerListRefreshView alloc] initWithDelegate:self];
    self.pagerView.mainTableView.gestureDelegate = self;
    self.pagerView.pinSectionHeaderVerticalOffset = kStatusBarHeight;   //悬浮位置

    [self.view addSubview:self.pagerView];

    self.categoryView.listContainer = (id<JXCategoryViewListContainer>)self.pagerView.listContainerView;

    //导航栏隐藏的情况，处理扣边返回，下面的代码要加上
    [self.pagerView.listContainerView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    [self.pagerView.mainTableView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.pagerView.frame = self.view.bounds;
    [self.view bringSubviewToFront:self.pagerView];
}

#pragma mark - Header View

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kDefaultNavBarHeight)];
        _headerView.backgroundColor = [UIColor backgroundColor];
        _headerViewLayout = [[MyLinearLayout alloc] initWithOrientation:MyOrientation_Horz];
        _headerViewLayout.myMargin = 0;
        _headerViewLayout.gravity = MyGravity_Vert_Center;
        _headerViewLayout.padding = UIEdgeInsetsMake(kStatusBarHeight, 10, 0, 10);
        [_headerView addSubview:_headerViewLayout];

        UIImageView *appIconIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"app_icon_thumb"]];
        appIconIV.frame = CGRectMake(0, 0, 40, 40);
        [_headerViewLayout addSubview:appIconIV];
        [appIconIV setCornerRadius:6];

        MyLinearLayout *searchBarView = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
        searchBarView.myHeight = 36.f;
        searchBarView.weight = 1;
        searchBarView.backgroundColor = [UIColor backgroundColorGray];
        [searchBarView xy_setLayerBorderColor:UIColor.borderColor];
        searchBarView.layer.borderWidth = 1;
        searchBarView.layer.cornerRadius = 9;
        searchBarView.gravity = MyGravity_Vert_Center;
        searchBarView.paddingLeft = 12;
        searchBarView.myLeft = 16;
        searchBarView.highlightedOpacity = 0.2;
        [searchBarView setTarget:self action:@selector(searchBarDidClick:)];
        [_headerViewLayout addSubview:searchBarView];

        UIImageView *searchIC = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_search"]];
        [searchBarView addSubview:searchIC];

        UILabel *placeholderLabel = [UILabel new];
        placeholderLabel.text = @"请输入文章、作者、专题或者栏目";
        placeholderLabel.font = [UIFont systemFontOfSize:ListIntroductionFontSize];
        placeholderLabel.textColor = [UIColor descriptionTextColor];
        placeholderLabel.myLeft = 6;
        [placeholderLabel sizeToFit];
        [searchBarView addSubview:placeholderLabel];
    }
    return _headerView;
}

- (void)searchBarDidClick:(UIView *)sender {
    //    GeneralSearchViewController *searchVC = [[GeneralSearchViewController alloc] init];
    //    [UIView transitionWithView:self.navigationController.view duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
    //          [self.navigationController pushViewController:searchVC animated:NO];
    //    } completion:nil];
}

#pragma mark - JXPagerViewDelegate

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.headerView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return kDefaultNavBarHeight;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return pinSectionHeaderHeight;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    //和categoryView的item数量一致
    return self.categoryView.titles.count;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    //    UIViewController<JXPagerViewListViewDelegate> *vc;
    //    switch (index) {
    //        case 0: {
    //            vc = [[TabHomeRecommandViewController alloc] init];
    //            break;
    //        }
    //        case 1: {
    //            TabHomeTopicViewController *tabHomeTopicVC = [[TabHomeTopicViewController alloc] init];
    //            Weak(self);
    //            tabHomeTopicVC.topBGColorChangedBlock = ^(UIColor *targetColor){
    //                [UIView animateWithDuration:0.2f animations:^{
    //                    weakself.headerView.backgroundColor = targetColor;
    //                    weakself.categoryView.backgroundColor = targetColor;
    //                } completion:nil];
    //            };
    //            vc = tabHomeTopicVC;
    //            break;
    //        }
    //        case 2: {
    //            vc = [[TabHomeColumnViewController alloc] init];
    //            break;
    //        }
    //        case 3: {
    //            vc = [[TabHomeTeamViewController alloc] init];
    //            break;
    //        }
    //        default:
    //            break;
    //    }

    TabHomeRcmdViewController *vc = [[TabHomeRcmdViewController alloc] init];
    return vc;
}

#pragma mark - BaseViewControllerDatasource
- (BOOL)baseViewControllerIsNeedNavBar:(BaseViewController *)baseViewController {
    return NO;
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
}

#pragma mark - JXPagerMainTableViewGestureDelegate

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //禁止categoryView左右滑动的时候，上下和左右都可以滚动
    if (otherGestureRecognizer == self.categoryView.collectionView.panGestureRecognizer) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

- (void)pagerView:(JXPagerView *)pagerView mainTableViewDidScroll:(UIScrollView *)scrollView {
    CGFloat thresholdDistance = 44.f;
    CGFloat percent = scrollView.contentOffset.y / thresholdDistance;
    self.headerViewLayout.alpha = 1 - MAX(0, MIN(1, percent));
}

@end
