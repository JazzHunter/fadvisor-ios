//
//  DocDetailsViewController.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/3/23.
//

#import "DocDetailsViewController.h"
#import "ItemDetailsService.h"

#import "JXCategoryView.h"
#import "JXPagerListRefreshView.h"

#import "DocDetailsTabSnapshotViewController.h"
#import "DocDetailsTabContentViewController.h"
#import "CommentsPagerView.h"
#import "DocDetailsHeaderView.h"

#import <MJExtension.h>
#import "ContentExcepitonView.h"
#import "SkeletonPageView.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import "FullScreenGestureScrollView.h"

static const CGFloat pinSectionHeaderHeight = 44.f;

@interface DocDetailsViewController ()<JXCategoryViewDelegate, JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate>

@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, strong) ItemDetailsService *itemDetailsService;
@property (nonatomic, strong) ItemModel *itemModel;
@property (nonatomic, strong) DocDetailsModel *detailsModel;

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXPagerView *pagerView;

@property (nonatomic, strong) DocDetailsTabSnapshotViewController *tabSnapshotViewController;
@property (nonatomic, strong) DocDetailsTabContentViewController *tabContentViewController;
@property (nonatomic, strong) CommentsPagerView *commentsPagerView;

@property (nonatomic, strong) DocDetailsHeaderView *headerView;
@property (atomic, assign) CGFloat headerHeight; //顶部试图高度

@end

@implementation DocDetailsViewController

- (instancetype)initWithItem:(ItemModel *)itemModel {
    self = [super init];
    if (self) {
        _itemModel = itemModel;
        _itemId = itemModel.itemId;
    }

    return self;
}

- (instancetype)initWithId:(NSString *)itemId {
    self = [super init];
    if (self) {
        _itemId = [itemId copy];
    }

    return self;
}

#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    [self initNavigationBar];

    [self getData];
}

- (void)initNavigationBar {
    self.navigationBar.delegate = self;
    self.navigationBar.dataSource = self;
    [self.navigationBar setTitleText:self.itemModel ? self.itemModel.title : @"读取中..."];
}

- (void)getData {
    [self.view showSkeletonPage:SkeletonPageViewTypeContentDetail isNavbarPadding:YES];
    Weak(self);
    [self.itemDetailsService getDetails:ItemTypeDoc itemId:self.itemId completion:^(NSString *errorMsg, NSDictionary *detailsDic) {
        [self.view hideSkeletonPage];

        weakself.detailsModel = [DocDetailsModel mj_objectWithKeyValues:detailsDic];
        weakself.itemModel = weakself.itemDetailsService.result.itemModel;

        [weakself.headerView setModel:weakself.itemModel];
        
        //TODO 需要处理错误，然后看情况加载视图
        [weakself.tabSnapshotViewController setModel:weakself.itemModel details:weakself.detailsModel];
        [weakself.tabContentViewController setModel:weakself.itemModel details:weakself.detailsModel];
    }];
}

- (void)initUI {
    self.view.backgroundColor = [UIColor clearColor];

    NSArray <NSString *> *titles = @[@"内容", @"介绍", @"评论"];
    _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 24.f)];
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

    self.pagerView = [[JXPagerListRefreshView alloc] initWithDelegate:self listContainerType:(JXPagerListContainerType_ScrollView)];
    self.pagerView.mainTableView.gestureDelegate = self;
    self.pagerView.pinSectionHeaderVerticalOffset = kStatusBarHeight;   //悬浮位置
    self.pagerView.mainTableView.backgroundColor = [UIColor clearColor];
    self.pagerView.frame = self.view.bounds;
    [self.view addSubview:self.pagerView];

    self.categoryView.listContainer = (id<JXCategoryViewListContainer>)self.pagerView.listContainerView;

    //导航栏隐藏的情况，处理扣边返回，下面的代码要加上
    [self.pagerView.listContainerView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    [self.pagerView.mainTableView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
}

#pragma mark - BaseViewControllerDatasource
- (BOOL)baseViewControllerIsNeedNavBar:(BaseViewController *)baseViewController {
    return YES;
}

#pragma mark - JXPagerViewDelegate

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.headerView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return self.headerHeight;
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
    UIViewController<JXPagerViewListViewDelegate> *vc;
    switch (index) {
        case 0: {
            vc = self.tabSnapshotViewController;
            break;
        }
        case 1: {
            vc = self.tabContentViewController;
            break;
        }
        case 2: {
            vc = self.commentsPagerView;
            break;
        }
        default:
            break;
    }
    return vc;
}

- (Class)scrollViewClassInlistContainerViewInPagerView:(JXPagerView *)pagerView {
    return [FullScreenGestureScrollView class];
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
}

#pragma mark - JXPagerMainTableViewGestureDelegate

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //如果手势来自于categoryView，其他滑动需要禁止
    if (otherGestureRecognizer == self.categoryView.collectionView.panGestureRecognizer) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

- (void)pagerView:(JXPagerView *)pagerView mainTableViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat thresholdDistance = 44.f;
//    CGFloat percent = scrollView.contentOffset.y / thresholdDistance;
//    self.headerViewLayout.alpha = 1 - MAX(0, MIN(1, percent));
}

#pragma mark - getter & setter

- (ItemDetailsService *)itemDetailsService {
    if (_itemDetailsService == nil) {
        _itemDetailsService = [[ItemDetailsService alloc] init];
    }
    return _itemDetailsService;
}

- (DocDetailsTabSnapshotViewController *)tabSnapshotViewController {
    if (!_tabSnapshotViewController) {
        _tabSnapshotViewController = [[DocDetailsTabSnapshotViewController alloc] init];
    }
    return _tabSnapshotViewController;
}

- (DocDetailsTabContentViewController *)tabContentViewController {
    if (!_tabContentViewController) {
        _tabContentViewController = [[DocDetailsTabContentViewController alloc] init];
    }
    return _tabContentViewController;
}

- (CommentsPagerView *)commentsPagerView {
    if (!_commentsPagerView) {
        _commentsPagerView = [[CommentsPagerView alloc] init];
        [_commentsPagerView resetWithItem:self.itemModel];
    }
    return _commentsPagerView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[DocDetailsHeaderView alloc] init];
        _headerView.myHorzMargin = 0;
        _headerView.bottomBorderline = [[MyBorderline alloc] initWithColor:[UIColor backgroundColorGray] thick:SectionMarginVertical];
        Weak(self);
        _headerView.loadedFinishBlock = ^(CGFloat height) {
            weakself.headerHeight = height;
            [weakself.pagerView resizeTableHeaderViewHeightWithAnimatable:YES duration:0 curve:0];
        };
    }
    return _headerView;
}

@end
