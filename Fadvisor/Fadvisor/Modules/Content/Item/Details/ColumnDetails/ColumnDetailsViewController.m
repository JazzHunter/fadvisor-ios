//
//  ColmunDetailsViewController.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/9/27.
//

#import "ColumnDetailsViewController.h"
#import "ItemDetailsService.h"
#import "ColumnDetailsModel.h"
#import "ColumnDetailsHeaderView.h"
#import "SkeletonPageView.h"
#import "ContentDefine.h"

#import <MJExtension.h>
#import <JXCategoryViewExt/JXCategoryView.h>

#import "JXPagerListRefreshView.h"

#import "ColumnDetailsItemsViewController.h"
#import "CommentsPagerView.h"

#import "FullScreenGestureScrollView.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>

#import "ListViewController.h"

static const CGFloat pinSectionHeaderHeight = 44.f;

@interface ColumnDetailsViewController ()<JXCategoryViewDelegate, JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate>

@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, strong) ItemDetailsService *itemDetailsService;
@property (nonatomic, strong) ColumnDetailsHeaderView *headerView;

@property (nonatomic, strong) ItemModel *itemModel;
@property (nonatomic, strong) ColumnDetailsModel *detailsModel;

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXPagerView *pagerView;

@property (nonatomic, strong) UIImageView *bgImageView; // 背景图

@property (nonatomic, strong) ColumnDetailsItemsViewController *tabItemsViewController;
@property (nonatomic, strong) CommentsPagerView *commentsPagerView;

@property (atomic, assign) CGFloat headerHeight; //顶部试图高度

@end

@implementation ColumnDetailsViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerHeight = 200;
    self.view.backgroundColor = [UIColor clearColor];

    [self initNavigationBar];

    [self getData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
}

- (void)initNavigationBar {
    self.navigationBar.delegate = self;
    self.navigationBar.dataSource = self;
    [self.navigationBar setTitleText:self.itemModel ? self.itemModel.title : @"读取中..."];
}

- (void)getData {
    [self.view showSkeletonPage:SkeletonPageViewTypeContentDetail isNavbarPadding:YES];
    Weak(self);
    [self.itemDetailsService getDetails:ItemTypeColumn itemId:self.itemId completion:^(NSString *errorMsg, NSDictionary *detailsDic) {
        [weakself.view hideSkeletonPage];

        // TODO 没有错误的话，再继续
        weakself.detailsModel = [ColumnDetailsModel mj_objectWithKeyValues:detailsDic];

        weakself.itemModel = weakself.itemDetailsService.result.itemModel;

        [weakself initNormalUI];

        [weakself.headerView setModel:weakself.itemModel details:weakself.detailsModel];

        if (!weakself.itemModel.bgUrl || weakself.itemModel.bgUrl.absoluteString.length == 0) {
            [self.bgImageView setImage:[UIImage imageNamed:@"default_bg"]];
        } else {
            [self.bgImageView setImageWithURL:weakself.itemModel.bgUrl];
        }
    }];
}

- (void)initNormalUI {
    self.bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.bgImageView.contentMode = UIViewContentModeScaleToFill;

    [self.view.layer masksToBounds];
    [self.view addSubview:self.bgImageView];

    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    blurView.alpha = 0.9; // 控制模糊程度
    blurView.myMargin = 0;
    blurView.frame = self.view.bounds;
    [self.view addSubview:blurView];

    NSArray <NSString *> *titles = @[@"列表", @"评论", @"团队"];

    _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
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

    [self.view addSubview:self.pagerView];

    self.categoryView.listContainer = (id<JXCategoryViewListContainer>)self.pagerView.listContainerView;

    //导航栏隐藏的情况，处理扣边返回，下面的代码要加上
    [self.pagerView.listContainerView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    [self.pagerView.mainTableView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];

//    [self.view bringSubviewToFront:self.pagerView];
}

#pragma mark - BaseViewControllerDatasource
- (BOOL)baseViewControllerIsNeedNavBar:(BaseViewController *)baseViewController {
    return NO;
}

#pragma mark - JXPagerViewDelegate

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.headerView;
//    return [UIView new];
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return self.headerHeight;
//    return 500;
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
            vc = self.tabItemsViewController;
            break;
        }
        case 1: {
            vc = self.commentsPagerView;
            break;
        }
        case 2: {
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
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
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
//    CGFloat thresholdDistance = 44.f;
//    CGFloat percent = scrollView.contentOffset.y / thresholdDistance;
//    self.headerViewLayout.alpha = 1 - MAX(0, MIN(1, percent));
}

#pragma mark - Getters & Setters
- (ItemDetailsService *)itemDetailsService {
    if (_itemDetailsService == nil) {
        _itemDetailsService = [[ItemDetailsService alloc] init];
    }
    return _itemDetailsService;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[ColumnDetailsHeaderView alloc] init];
        _headerView.myHorzMargin = 0;
        _headerView.bottomBorderline = [[MyBorderline alloc] initWithColor:[UIColor backgroundColorGray] thick:SectionMarginVertical];
        Weak(self);
        _headerView.loadedFinishBlock = ^(CGFloat height) {
            weakself.headerHeight = height;
            
            [weakself.pagerView resizeTableHeaderViewHeightWithAnimatable:NO duration:0 curve:0];

        };
    }
    return _headerView;
}

- (JXPagerView *)pagerView {
    if (!_pagerView) {
        // JXPagerListContainerType_ScrollView才能右滑返回
        // JXPagerListRefreshView 才能顺利上下滑动，JXPagerView 上下滑动有 bug
        _pagerView = [[JXPagerListRefreshView alloc] initWithDelegate:self listContainerType:JXPagerListContainerType_ScrollView];
//        _pagerView = [[JXPagerView alloc] initWithDelegate:self listContainerType:JXPagerListContainerType_ScrollView];

        _pagerView.mainTableView.gestureDelegate = self;
        _pagerView.mainTableView.backgroundColor = [UIColor clearColor];
        _pagerView.frame = self.view.bounds;
        _pagerView.pinSectionHeaderVerticalOffset = kDefaultNavBarHeight;   //悬浮位置
    }
    return _pagerView;
}

- (ColumnDetailsItemsViewController *)tabItemsViewController {
    if (!_tabItemsViewController) {
        _tabItemsViewController = [[ColumnDetailsItemsViewController alloc] initWithCollection:self.itemModel];
    }
    return _tabItemsViewController;
}

- (CommentsPagerView *)commentsPagerView {
    if (!_commentsPagerView) {
        _commentsPagerView = [[CommentsPagerView alloc] init];
        [_commentsPagerView resetWithItem:self.itemModel];
    }
    return _commentsPagerView;
}

@end
