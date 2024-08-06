//
//  AuthorDetailsViewController.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/6/30.
//

#import "AuthorDetailsViewController.h"
#import "GKPageSmoothView.h"
#import "JXCategoryView.h"
#import "AuthorDetailsHomeViewController.h"
#import "UIScrollView+GKGestureHandle.h"

#import "AuthorDetailsService.h"
#import "SkeletonPageView.h"
#import <MJExtension.h>
#import "AuthorDetailsModel.h"
#import "AuthorDetailsHeaderView.h"

@interface AuthorDetailsViewController ()<NavigationBarDataSource, NavigationBarDelegate, GKPageSmoothViewDataSource, GKPageSmoothViewDelegate, JXCategoryViewDelegate>

@property (nonatomic, strong) GKPageSmoothView *smoothView;
@property (nonatomic, strong) JXCategorySubTitleView *categoryView;
@property (nonatomic, strong) JXCategoryIndicatorAlignmentLineView *lineView;
@property (nonatomic, strong) AuthorDetailsHomeViewController *homeViewController;
@property (nonatomic, strong) UIView *segmentedView;
@property (nonatomic, strong) AuthorDetailsHeaderView *headerView;
@property (nonatomic, strong) UIImageView *fakeHeaderView;

@property (nonatomic, copy) NSString *authorId;
@property (nonatomic, strong) AuthorDetailsService *authorDetailsService;
@property (nonatomic, strong) AuthorModel *authorModel;
@property (nonatomic, strong) AuthorDetailsModel *detailsModel;

@end

@implementation AuthorDetailsViewController

- (instancetype)initWithAuthor:(AuthorModel *)authorModel {
    self = [super init];
    if (self) {
        _authorModel = authorModel;
        _authorId = authorModel.authorId;
    }

    return self;
}

- (instancetype)initWithId:(NSString *)itemId {
    self = [super init];
    if (self) {
        _authorId = [itemId copy];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationBar];
    [self initUI];
    [self getData];
    
   
    [self.view addSubview:self.smoothView];
    
    self.categoryView.contentScrollView = self.smoothView.listCollectionView;
    [self.smoothView reloadData];
    
}

- (void)initNavigationBar {
    self.navigationBar.delegate = self;
    self.navigationBar.dataSource = self;
//    [self.navigationBar setTitleText:self.itemModel ? self.itemModel.title : @"读取中..."];
}

- (void)getData {
    [self.view showSkeletonPage:SkeletonPageViewTypeContentDetail isNavbarPadding:YES];
    Weak(self);
    [self.authorDetailsService getDetails:self.authorId completion:^(NSString *errorMsg, NSDictionary *detailsDic) {
        weakself.detailsModel = [AuthorDetailsModel mj_objectWithKeyValues:detailsDic];

        weakself.authorModel = weakself.authorDetailsService.result.authorModel;
        
        [weakself.headerView setModel:weakself.authorModel details:weakself.detailsModel];

    }];
}

- (void)initUI {
//    self.scrollView.delegate = self;
//
//    Weak(self);
//    self.richTextView.loadedFinishBlock = ^(CGFloat height) {
//        if (height > 0) {
//            weakself.richTextView.myHeight = height;
//            weakself.richTextView.alpha = 0.0f;
//            // 富文本读取后取消隐藏
//            [UIView animateWithDuration:0.3f animations:^{
//                weakself.richTextView.alpha = 1.0f;
//            }];
//        } else {
//            // 加载失败 提示用户
//        }
//    };
//
//    [self.contentLayout addSubview:self.titleLabel];
//
//    [self.contentLayout addSubview:self.richTextView];
//
//    UILabel *pubTimeLabel = [[UILabel alloc] init];
//    self.pubTimeLabel = pubTimeLabel;
//    [self.contentLayout addSubview:self.pubTimeLabel];
//
//    MyLinearLayout *shareBtn = [[MyLinearLayout alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
//    [shareBtn setHighlightedOpacity:0.5];
//    [shareBtn setBackgroundImage:[UIImage imageNamed:@"ic_share"]];
//    [shareBtn setTarget:self action:@selector(handleSharePanelOpen:)];
//    self.shareBtn = shareBtn;
//    [self.contentLayout addSubview:self.shareBtn];
}

- (void)handleSharePanelOpen:(MyBaseLayout *)sender {
//    [[SharePanel manager] showPanelWithItem:self.itemModel];
}



- (void)viewWillLayoutSubviews {
//    CGRect frame = self.headerView.frame;
//    if (frame.size.width != self.view.frame.size.width) {
//        UIImage *image = [UIImage imageNamed:@"douban"];
//        frame.size.width = self.view.frame.size.width;
//        frame.size.height = frame.size.width * image.size.height / image.size.width;
//        self.headerView.frame = frame;
//        [self.smoothView refreshHeaderView];
//    }
//    
//    frame = self.segmentedView.frame;
//    if (frame.size.width != self.view.frame.size.width) {
//        frame.size.width = self.view.frame.size.width;
//        self.segmentedView.frame = frame;
//        
//        frame = self.categoryView.frame;
//        frame.size.width = self.view.frame.size.width;
//        self.categoryView.frame = frame;
//        [self.categoryView reloadData];
//    }
}


#pragma mark - GKPageSmoothViewDataSource
- (UIView *)headerViewInSmoothView:(GKPageSmoothView *)smoothView {
    return self.headerView;
}

- (UIView *)segmentedViewInSmoothView:(GKPageSmoothView *)smoothView {
    return self.segmentedView;
}

- (NSInteger)numberOfListsInSmoothView:(GKPageSmoothView *)smoothView {
    return self.categoryView.titles.count;
}

- (id<GKPageSmoothListViewDelegate>)smoothView:(GKPageSmoothView *)smoothView initListAtIndex:(NSInteger)index {
    AuthorDetailsHomeViewController *listVC = [[AuthorDetailsHomeViewController alloc] init];
    return listVC;
}

#pragma mark - GKPageSmoothViewDelegate
- (void)smoothView:(GKPageSmoothView *)smoothView listScrollViewDidScroll:(UIScrollView *)scrollView contentOffset:(CGPoint)contentOffset {
    if (smoothView.isOnTop) return;

//    // 导航栏显隐
//    CGFloat offsetY = contentOffset.y;
//    CGFloat alpha = 0;
//    if (offsetY <= 0) {
//        alpha = 0;
//    }else if (offsetY > 60) {
//        alpha = 1;
//        [self changeTitle:YES];
//    }else {
//        alpha = offsetY / 60;
//        [self changeTitle:NO];
//    }
//    self.gk_navBarAlpha = alpha;
}

- (void)smoothViewDragBegan:(GKPageSmoothView *)smoothView {
    if (smoothView.isOnTop) return;
//
//    self.isTitleViewShow = (self.gk_navTitleView != nil);
//    self.originAlpha = self.gk_navBarAlpha;
}

- (void)smoothViewDragEnded:(GKPageSmoothView *)smoothView isOnTop:(BOOL)isOnTop {
//    // titleView已经显示，不作处理
//    if (self.isTitleViewShow) return;
//
//    if (isOnTop) {
//        self.gk_navBarAlpha = 1.0f;
//        [self changeTitle:YES];
//    }else {
//        self.gk_navBarAlpha = self.originAlpha;
//        [self changeTitle:NO];
//    }
}

#pragma mark - JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    [self.smoothView showingOnTop];
}

#pragma mark - getter & setter

- (UIImageView *)fakeHeaderView {
    if (!_fakeHeaderView) {
        UIImage *image = [UIImage imageNamed:@"douban"];
        _fakeHeaderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        _fakeHeaderView.image = image;
    }
    return _fakeHeaderView;
}


- (AuthorDetailsService *)authorDetailsService {
    if (_authorDetailsService == nil) {
        _authorDetailsService = [[AuthorDetailsService alloc] init];
    }
    return _authorDetailsService;
}


- (AuthorDetailsHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[AuthorDetailsHeaderView alloc] init];
        _headerView.heightSize.lBound(self.view.heightSize, 100, 1);
        Weak(self);
//        _headerView.loadedFinishBlock = ^(CGFloat height) {
//            [ weakself.smoothView refreshHeaderView];
//        };
    }
    return _headerView;
}

- (GKPageSmoothView *)smoothView {
    if (!_smoothView) {
        _smoothView = [[GKPageSmoothView alloc] initWithDataSource:self];
        _smoothView.frame = self.view.bounds;
        _smoothView.delegate = self;
        _smoothView.ceilPointHeight = kDefaultNavBarHeight;
        _smoothView.bottomHover = YES;
        _smoothView.allowDragBottom = YES;
        _smoothView.allowDragScroll = YES;
        // 解决与返回手势滑动冲突
        _smoothView.listCollectionView.gk_openGestureHandle = YES;
        _smoothView.holdUpScrollView = YES;
    }
    return _smoothView;
}

- (UIView *)segmentedView {
    if (!_segmentedView) {
        _segmentedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 60)];
        _segmentedView.backgroundColor = [UIColor whiteColor];
        [_segmentedView addSubview:self.categoryView];

        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake((self.view.width - 60) / 2, 6, 60, 6)];
        topView.backgroundColor = [UIColor lightGrayColor];
        topView.layer.cornerRadius = 3;
        topView.layer.masksToBounds = YES;
        [_segmentedView addSubview:topView];
        
    }
    return _segmentedView;
}

- (JXCategorySubTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategorySubTitleView alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 40)];
        _categoryView.backgroundColor = UIColor.whiteColor;
        _categoryView.averageCellSpacingEnabled = NO;
        _categoryView.contentEdgeInsetLeft = 16;
        _categoryView.delegate = self;
        _categoryView.titles = @[@"影评", @"讨论", @"精选"];
        _categoryView.titleFont = [UIFont systemFontOfSize:16];
        _categoryView.titleColor = UIColor.grayColor;
        _categoryView.titleSelectedColor = UIColor.blackColor;
        _categoryView.subTitles = @[@"342", @"2004", @"50"];
        _categoryView.subTitleFont = [UIFont systemFontOfSize:11];
        _categoryView.subTitleColor = UIColor.grayColor;
        _categoryView.subTitleSelectedColor = UIColor.grayColor;
        _categoryView.positionStyle = JXCategorySubTitlePositionStyle_Right;
        _categoryView.alignStyle = JXCategorySubTitleAlignStyle_Top;
        _categoryView.cellSpacing = 30;
        _categoryView.cellWidthIncrement = 0;
        _categoryView.ignoreSubTitleWidth = YES;

        JXCategoryIndicatorLineView *lineView = [JXCategoryIndicatorLineView new];
        lineView.indicatorColor = UIColor.blackColor;
        _categoryView.indicators = @[self.lineView];

//        _categoryView.contentScrollView = self.smoothView.listCollectionView;
    }
    return _categoryView;
}

- (JXCategoryIndicatorAlignmentLineView *)lineView {
    if (!_lineView) {
        _lineView = [JXCategoryIndicatorAlignmentLineView new];
        _lineView.indicatorColor = [UIColor mainColor];
    }
    return _lineView;
}

@end
