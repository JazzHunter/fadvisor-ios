//
//  VideoDetailsViewController.m
//  Fadvisor
//
//  Created by 韩建伟 on 2023/12/9.
//

#import "VideoDetailsViewController.h"
#import "ItemDetailsService.h"
#import "MediaModel.h"
#import "Utils.h"

#import "JXCategoryView.h"
#import "JXPagerListRefreshView.h"

#import "VideoDetailsPlayerView.h"
#import "VideoDetailsContentViewController.h"
#import "CommentsViewController.h"

#import <MJExtension.h>
#import "ItemDetailsService.h"
#import "ContentDefine.h"
#import "ContentExcepitonView.h"
#import "SkeletonPageView.h"

#import "UIInterface+HXRotation.h"

static const CGFloat pinSectionHeaderHeight = 64.f;

@interface VideoDetailsViewController ()<VideoDetailsPlayerViewProtocol, JXCategoryViewDelegate, JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate>

// Data
@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, strong) ItemDetailsService *itemDetailsService;
@property (nonatomic, strong) ItemModel *itemModel;
@property (nonatomic, strong) VideoDetailsModel *detailsModel;

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXPagerView *pagerView;

@property (nonatomic, strong) VideoDetailsPlayerView *playerView;
@property (assign, nonatomic) CGFloat playerViewHeight;
@property (nonatomic, strong) UIView *headerView;                   //竖屏的容器，状态栏 + PlayerView

@property (nonatomic, assign) UIInterfaceOrientationMask currentVCInterfaceOrientationMask;

@property (nonatomic, strong) VideoDetailsContentViewController *contentViewController;
@property (nonatomic, strong) CommentsViewController *commentsViewController;

@end

@implementation VideoDetailsViewController

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
//    [self addOrRemoveDeviceOrientationChangeNotification:YES];

    self.playerViewHeight = kScreenWidth * 9 / 16;

    self.currentVCInterfaceOrientationMask = UIInterfaceOrientationMaskAllButUpsideDown;
    [self initUI];

    [self getData];
}

- (void)getData {
    [self.view showSkeletonPage:SkeletonPageViewTypeContentDetail isNavbarPadding:YES];
    Weak(self);
    [self.itemDetailsService getDetails:ItemTypeVideo itemId:self.itemId completion:^(NSString *errorMsg, NSDictionary *detailsDic) {
        [self.view hideSkeletonPage];

        weakself.detailsModel = [VideoDetailsModel mj_objectWithKeyValues:detailsDic];
        weakself.itemModel = weakself.itemDetailsService.result.itemModel;
//        if (weakself.detailsModel.width && weakself.detailsModel.height && weakself.detailsModel.width > 0 && weakself.detailsModel.height > 0) {
//            weakself.playerViewHeight = self.view.width * weakself.detailsModel.width / weakself.detailsModel.height;
//        } else {
//            weakself.playerViewHeight = self.view.width * 16 / 9;
//        }
        [weakself.playerView startNewPlayWithItem:weakself.itemModel details:weakself.detailsModel];
        [weakself.contentViewController setModel:weakself.itemModel details:weakself.detailsModel];
    }];
}

- (void)initUI {
    self.view.backgroundColor = [UIColor clearColor];

    NSArray <NSString *> *titles = @[@"内容", @"评论"];
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

- (void)viewDidLayoutSubviews {
    if (self.playerView.isScreenLocked) {
        return;
    }
    BOOL isPortrait = [Utils isInterfaceOrientationPortrait];
    self.playerView.frame = CGRectMake(0, kStatusBarHeight, kScreenWidth, self.playerViewHeight);
    if (isPortrait) {
        [self.headerView addSubview:self.playerView];
    } else {
        [self.view addSubview:self.playerView];
        [UIView animateWithDuration:0.3 animations:^{
            self.playerView.frame = self.view.bounds;
        }];
    }
    [self.playerView resetLayout:isPortrait];
}

- (void)dealloc {
//    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - JXPagerViewDelegate

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.headerView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return self.playerViewHeight + kStatusBarHeight;
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
            vc = self.contentViewController;
            break;
        }
        case 1: {
            vc = self.commentsViewController;
            break;
        }
        default:
            break;
    }
    return vc;
}

#pragma mark - VideoDetailsPlayerViewDelegate
- (void)onBackButtonClickWithPlayerView:(VideoDetailsPlayerView *)playerView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onMoreButtonClickWithPlayerView:(VideoDetailsPlayerView *)playerView {
}

- (void)onDownloadButtonClickWithPlayerView:(VideoDetailsPlayerView *)playerView {
}

- (void)onFinishWithPlayerView:(VideoDetailsPlayerView *)playerView {
}

- (void)onHorzViewPopped:(BOOL)isPopped {
//    [self addOrRemoveDeviceOrientationChangeNotification:!isPopped];
}

- (void)onScreenLockButtonClickWithPlayerView:(VideoDetailsPlayerView *)playerView isLocked:(BOOL)isLocked {
    if (isLocked) {
        self.currentVCInterfaceOrientationMask = UIInterfaceOrientationMaskLandscape;
        [self hx_setNeedsUpdateOfSupportedInterfaceOrientations];
    } else {
        self.currentVCInterfaceOrientationMask = UIInterfaceOrientationMaskAllButUpsideDown;
        [self hx_setNeedsUpdateOfSupportedInterfaceOrientations];
    }
}

- (void)onRotationToPortraitInterface:(BOOL)isPortrait {
    if (isPortrait) {
        self.currentVCInterfaceOrientationMask = UIInterfaceOrientationMaskAllButUpsideDown;
        [self hx_rotateToInterfaceOrientation:UIInterfaceOrientationPortrait];
    } else {
        self.currentVCInterfaceOrientationMask = UIInterfaceOrientationMaskAllButUpsideDown;
        [self hx_rotateToInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
    }
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
    //如果手势来自于categoryView，其他滑动禁止
    if (otherGestureRecognizer == self.categoryView.collectionView.panGestureRecognizer) {
        return NO;
    }
    //如果手势点自于playerView，其他滑动禁止
    CGPoint point = [gestureRecognizer locationInView:self.view];
    if (CGRectContainsPoint(self.playerView.frame, point)) {
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
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarHeight + _playerViewHeight)];
        _headerView.backgroundColor = [UIColor blackColor];

        _playerView = [[VideoDetailsPlayerView alloc] init];
        _playerView.frame = CGRectMake(0, kStatusBarHeight, kScreenWidth, _playerViewHeight);
        _playerView.delegate = self;
    }
    return _headerView;
}

- (ItemDetailsService *)itemDetailsService {
    if (_itemDetailsService == nil) {
        _itemDetailsService = [[ItemDetailsService alloc] init];
    }
    return _itemDetailsService;
}

- (VideoDetailsContentViewController *)contentViewController {
    if (!_contentViewController) {
        _contentViewController = [[VideoDetailsContentViewController alloc] init];
    }
    return _contentViewController;
}

- (CommentsViewController *)commentsViewController {
    if (!_commentsViewController) {
        _commentsViewController = [[CommentsViewController alloc] initWithModel:self.itemModel];
    }
    return _commentsViewController;
}

#pragma mark - 屏幕旋转
// https://gitcode.com/thelittleboy/hxrotationtool/overview?utm_source=csdn_github_accelerator&isLogin=1
// TheLittleBoy / HXRotationTool
- (BOOL)shouldAutorotate {
    return YES;
}

// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.currentVCInterfaceOrientationMask;
}

@end
