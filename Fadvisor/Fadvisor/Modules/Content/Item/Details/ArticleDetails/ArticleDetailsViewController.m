//
//  ArticleDetailsViewController.m
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/24.
//

#define ToolbarHeight 44

#import "ArticleDetailsViewController.h"
#import "ItemDetailsService.h"
#import "ContentDefine.h"
#import "ContentExcepitonView.h"
#import "ArticleContent.h"
#import "AuthorSection.h"
#import "SkeletonPageView.h"
#import <MJExtension.h>
#import "Collections.h"
#import "LEECoolButton.h"
#import "ArticleDetailsModel.h"
#import "ArticleDetailsToolbarView.h"
#import "ArticleDetailsTransparentNavbar.h"
#import "MoreItemsView.h"
#import "ArticleDetailsCollItemsSectionView.h"

@interface ArticleDetailsViewController ()<NavigationBarDataSource, NavigationBarDelegate, UIScrollViewDelegate>

@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, strong) ItemDetailsService *itemDetailsService;
@property (nonatomic, strong) ItemModel *itemModel;
@property (nonatomic, strong) ArticleDetailsModel *detailsModel;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) ArticleContent *articleContent;
@property (nonatomic, strong) ArticleDetailsCollItemsSectionView *collItemsSectionView;

@property (nonatomic, strong) Collections *collections;

@property (nonatomic, strong) MyLinearLayout *toolbarPlaceholderViewInContent;
@property (nonatomic, strong) ArticleDetailsToolbarView *toolbarView;
@property (nonatomic, strong) MyLinearLayout *toolbarPlaceholderViewInBottom;
@property (assign, assign) BOOL toolbarInBottom;

@property (nonatomic, strong) ArticleDetailsTransparentNavbar *transparentNavbar;
@property (nonatomic, strong) MoreItemsView *moreItemsView;

@end

@implementation ArticleDetailsViewController

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
    [self initNavigationBar];

    [self.scrollView setSafeBottomInset];
    self.contentLayout.padding = UIEdgeInsetsMake(ViewVerticalMargin, 0, ViewVerticalMargin, 0);

    [self initUI];
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
    [self.itemDetailsService getDetails:ItemTypeArticle itemId:self.itemId completion:^(NSString *errorMsg, NSDictionary *detailsDic) {
        weakself.detailsModel = [ArticleDetailsModel mj_objectWithKeyValues:detailsDic];

        weakself.itemModel = weakself.itemDetailsService.result.itemModel;

        weakself.titleLabel.text = weakself.itemModel.title;
        [weakself.titleLabel sizeToFit];

        [weakself.articleContent setModel:weakself.itemModel details:weakself.detailsModel authors:weakself.itemDetailsService.result.authors tags:weakself.itemDetailsService.result.tags attachments:weakself.itemDetailsService.result.attachments relatedItems:weakself.itemDetailsService.result.relatedItems ];

        if (weakself.itemDetailsService.result.collections && weakself.itemDetailsService.result.collections.count > 0) {
            [weakself.collections setModels:weakself.itemDetailsService.result.collections];
            weakself.collections.hidden = NO;
        } else {
            weakself.collections.hidden = YES;
        }

        [weakself.toolbarView setModel:weakself.itemModel];

        [weakself.collItemsSectionView setModel:weakself.itemModel withCollection:self.fromCollection];
    }];
}

- (void)initUI {
    self.scrollView.delegate = self;

    self.titleLabel.myLeading = self.titleLabel.myTrailing = ViewHorizonlMargin;
    self.titleLabel.myBottom = 12;

    [self.contentLayout addSubview:self.titleLabel];

    Weak(self);
    self.articleContent.richTextView.loadedFinishBlock = ^(CGFloat height) {
        if (height > 0) {
            weakself.articleContent.richTextView.myHeight = height;
            weakself.articleContent.richTextView.alpha = 0.0f;
            // 富文本读取后取消隐藏
            [weakself.view hideSkeletonPage];
            [UIView animateWithDuration:0.3f animations:^{
                weakself.articleContent.richTextView.alpha = 1.0f;
            }];

            [weakself.view layoutIfNeeded];
            [weakself handleToolbarViewPosition:YES];
        } else {
            // 加载失败 提示用户
        }
    };
    self.articleContent.backgroundColor = [UIColor backgroundColor];
    [self.contentLayout addSubview:self.articleContent];

    self.toolbarPlaceholderViewInContent.myHorzMargin = 0;
    self.toolbarPlaceholderViewInContent.myHeight = ToolbarHeight;
    self.toolbarPlaceholderViewInContent.padding = UIEdgeInsetsMake(0, ViewHorizonlMargin, 0, ViewHorizonlMargin);
    self.toolbarPlaceholderViewInContent.backgroundColor = [UIColor backgroundColor];
    [self.contentLayout addSubview:self.toolbarPlaceholderViewInContent];

    self.toolbarView.myHorzMargin = 0;
    self.toolbarView.myHeight = ToolbarHeight;
    self.toolbarView.padding = UIEdgeInsetsMake(10, 0, 10, 0);

    self.toolbarPlaceholderViewInBottom.myHorzMargin = 0;
    self.toolbarPlaceholderViewInBottom.myHeight = MyLayoutSize.wrap;
    self.toolbarPlaceholderViewInBottom.padding = UIEdgeInsetsMake(0, ViewHorizonlMargin, kBottomSafeAreaHeight, ViewHorizonlMargin);
    self.toolbarPlaceholderViewInBottom.bottomPos.equalTo(self.view.bottomPos);
    self.toolbarPlaceholderViewInBottom.backgroundColor = [UIColor backgroundColor];
    self.toolbarPlaceholderViewInBottom.topBorderline = [[MyBorderline alloc] initWithColor:[UIColor borderColor] thick:2];
    self.toolbarPlaceholderViewInBottom.layer.shadowColor = [UIColor blackColor].CGColor;
    self.toolbarPlaceholderViewInBottom.layer.shadowOffset = CGSizeMake(0, 2);
    self.toolbarPlaceholderViewInBottom.layer.shadowOpacity = 0.5;
    self.toolbarPlaceholderViewInBottom.layer.shadowRadius = 5;
    [self.view addSubview:self.toolbarPlaceholderViewInBottom];

    self.toolbarInBottom = YES;

    self.collItemsSectionView.myHorzMargin = ViewHorizonlMargin;
    [self.contentLayout addSubview:self.collItemsSectionView];

    self.collections.myHorzMargin = 0;
    self.collections.padding = UIEdgeInsetsMake(ViewVerticalMargin, ViewHorizonlMargin, ViewVerticalMargin, ViewHorizonlMargin);
    self.collections.backgroundColor = [UIColor backgroundColor];
    self.collections.myTop = 12;
    [self.contentLayout addSubview:self.collections];

    self.moreItemsView.backgroundColor = [UIColor backgroundColor];
    self.moreItemsView.padding = UIEdgeInsetsMake(ViewVerticalMargin, 0, ViewVerticalMargin, 0);
    self.moreItemsView.myTop = 12;
    [self.contentLayout addSubview:self.moreItemsView];

    self.transparentNavbar.alpha = 0;
    [self.view addSubview:self.transparentNavbar];
}

- (void)handleToolbarViewPosition:(BOOL)forceCheck {
    CGRect targetViewFrameInScrollView = [self.scrollView convertRect:self.toolbarPlaceholderViewInContent.bounds fromView:self.toolbarPlaceholderViewInContent];
    // 检查scrollView的contentOffset是否大于等于targetView的位置
    // 需要添加到内容中
    if ((self.scrollView.contentOffset.y + self.view.height - (ToolbarHeight + kBottomSafeAreaHeight) >= targetViewFrameInScrollView.origin.y) && (self.toolbarInBottom || forceCheck) ) {
        self.toolbarInBottom = NO;
        [self.toolbarPlaceholderViewInContent addSubview:self.toolbarView];
        self.toolbarPlaceholderViewInBottom.hidden = YES;
        // 放到底部栏中
    } else if ((self.scrollView.contentOffset.y + self.view.height - (ToolbarHeight + kBottomSafeAreaHeight) < targetViewFrameInScrollView.origin.y) && (!self.toolbarInBottom || forceCheck)) {
        self.toolbarInBottom = YES;
        [self.toolbarPlaceholderViewInBottom addSubview:self.toolbarView];
        self.toolbarPlaceholderViewInBottom.hidden = NO;
    }
}

- (void)handleMoreItemsLoad {
    CGRect targetViewFrameInScrollView = [self.scrollView convertRect:self.moreItemsView.bounds fromView:self.moreItemsView];
    // 检查scrollView的contentOffset是否大于等于targetView的位置
    // 需要添加到内容中
    if (self.scrollView.contentOffset.y + self.view.height  >= targetViewFrameInScrollView.origin.y) {
        [self.moreItemsView loadMoreItemsWithModel:self.itemModel];
    }
}

#pragma mark - BaseViewControllerDatasource
- (BOOL)baseViewControllerIsNeedNavBar:(BaseViewController *)baseViewController {
    return YES;
}

#pragma mark - ScrollViewDelgate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 传递滑动
    [self.articleContent.richTextView offsetY:(self.articleContent.richTextView.frame.origin.y - scrollView.contentOffset.y)];

    // 处理Toolbar的位置
    [self handleToolbarViewPosition:NO];

    // 处理上下滑动导致的状态栏变化
    UIPanGestureRecognizer *pan = scrollView.panGestureRecognizer;
    CGFloat velocity = [pan velocityInView:scrollView].y;

    if (velocity < -50) {
        [UIView animateWithDuration:0.3 animations:^{
            self.navigationBar.alpha = 0;
            self.transparentNavbar.alpha = 1;
        }];
    } else if (velocity > 50) {
        [UIView animateWithDuration:0.3 animations:^{
            self.navigationBar.alpha = 1;
            self.transparentNavbar.alpha = 0;
        }];
    }

    // 处理更多推荐
    [self handleMoreItemsLoad];
}

#pragma mark - getters and setters
- (ItemDetailsService *)itemDetailsService {
    if (_itemDetailsService == nil) {
        _itemDetailsService = [[ItemDetailsService alloc] init];
    }
    return _itemDetailsService;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:DetailsTitleFontSize weight:UIFontWeightSemibold];
        _titleLabel.textColor = [UIColor titleTextColor];
    }
    return _titleLabel;
}

- (ArticleContent *)articleContent {
    if (_articleContent == nil) {
        _articleContent = [[ArticleContent alloc] init];
    }
    return _articleContent;
}

- (ArticleDetailsCollItemsSectionView *)collItemsSectionView {
    if (_collItemsSectionView == nil) {
        _collItemsSectionView = [ArticleDetailsCollItemsSectionView new];
    }
    return _collItemsSectionView;
}

- (Collections *)collections {
    if (_collections == nil) {
        _collections = [[Collections alloc] init];
    }
    return _collections;
}

- (MyLinearLayout *)toolbarPlaceholderViewInContent {
    if (_toolbarPlaceholderViewInContent == nil) {
        _toolbarPlaceholderViewInContent = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    }
    return _toolbarPlaceholderViewInContent;
}

- (ArticleDetailsToolbarView *)toolbarView {
    if (_toolbarView == nil) {
        _toolbarView = [[ArticleDetailsToolbarView alloc] init];
    }
    return _toolbarView;
}

- (MyLinearLayout *)toolbarPlaceholderViewInBottom {
    if (_toolbarPlaceholderViewInBottom == nil) {
        _toolbarPlaceholderViewInBottom = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    }
    return _toolbarPlaceholderViewInBottom;
}

- (ArticleDetailsTransparentNavbar *)transparentNavbar {
    if (_transparentNavbar == nil) {
        _transparentNavbar = [ArticleDetailsTransparentNavbar new];
    }
    return _transparentNavbar;
}

- (MoreItemsView *)moreItemsView {
    if (_moreItemsView == nil) {
        _moreItemsView = [MoreItemsView new];
    }
    return _moreItemsView;
}

@end
