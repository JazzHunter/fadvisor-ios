//
//  DcoDetailsContentViewController.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/6/29.
//

#import "DocDetailsTabSnapshotViewController.h"
#import <GKPhotoBrowser/GKPhotoBrowser.h>
#import "SkeletonPageView.h"

@interface DocDetailsTabSnapshotViewController ()<UIScrollViewDelegate, GKPhotoBrowserDelegate>

@property (nonatomic, copy) void (^ scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) ItemModel *itemModel;
@property (nonatomic, strong) NSArray<NSString *> *snapshotArr;
@property (nonatomic, strong) NSMutableArray<GKPhoto *> *photos;

@end

@implementation DocDetailsTabSnapshotViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
}

- (void)initUI {
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;

    self.contentLayout.padding = UIEdgeInsetsMake(ViewVerticalMargin, ViewHorizonlMargin, ViewVerticalMargin, ViewHorizonlMargin);

    self.contentLayout.gravity = MyGravity_Horz_Fill;
    
    [self.view showSkeletonPage:SkeletonPageViewTypeContentDetail isNavbarPadding:NO];

}

#pragma mark - JXPagingViewListViewDelegate

- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.scrollView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)listWillAppear {
}

- (void)listDidAppear {
}

- (void)listWillDisappear {
}

- (void)listDidDisappear {
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.scrollView.contentOffset.x <= 0) {
        if ([otherGestureRecognizer.delegate isKindOfClass:NSClassFromString(@"_FDFullscreenPopGestureRecognizerDelegate")]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - ScrollViewDelgate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 传递滑动
    !self.scrollCallback ? : self.scrollCallback(scrollView);
}

#pragma mark - getters and setters

- (void)setModel:(ItemModel *)itemModel details:(DocDetailsModel *)detailsModel {
    self.itemModel = itemModel;

    _snapshotArr = [detailsModel.snapshots componentsSeparatedByString:@","];
    _photos = [NSMutableArray new];

    [_snapshotArr enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        UIImageView *snapshotView = [self createSnapshotImageView:obj];
        if (idx != 0) {
            snapshotView.myTop = 5;
        }

        snapshotView.userInteractionEnabled = YES;
        snapshotView.tag = idx;
        [snapshotView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(snapshotViewClick:)]];

        [self.contentLayout addSubview:snapshotView];

        // 添加图片浏览
        GKPhoto *photo = [GKPhoto new];
        photo.url = [NSURL URLWithString:obj];
        photo.sourceImageView = snapshotView;
        [_photos addObject:photo];
    }];
    
    [self.view hideSkeletonPage];
}

- (UIImageView *)createSnapshotImageView:(NSString *)url {
    UIImageView *snapshotView = [[UIImageView alloc] init];
    snapshotView.myHeight = MyLayoutSize.wrap;

    snapshotView.contentMode = UIViewContentModeScaleAspectFill;
    [snapshotView xy_setLayerBorderColor:[UIColor borderColor]];
    snapshotView.layer.borderWidth = 1;
    [snapshotView setImageWithURL:[NSURL URLWithString:url]];

    return snapshotView;
}

- (void)snapshotViewClick:(UIGestureRecognizer *)tap {
    UIImageView *imageView = (UIImageView *)tap.view;

    GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:self.photos currentIndex:imageView.tag];
    browser.showStyle = GKPhotoBrowserShowStyleZoom;        // 缩放显示
    browser.hideStyle = GKPhotoBrowserHideStyleZoomScale;   // 缩放隐藏
    browser.loadStyle = GKPhotoBrowserLoadStyleIndeterminateMask; // 不明确的加载方式带阴影
    browser.maxZoomScale = 20.0f;
    browser.doubleZoomScale = 2.0f;
    browser.isAdaptiveSafeArea = YES;
    browser.hidesCountLabel = NO;
//        browser.hidesPageControl = YES;
    browser.hidesSavedBtn = NO;
    browser.isFullWidthForLandScape = YES;
    browser.isSingleTapDisabled = NO;
    browser.isStatusBarShow = YES;      // 显示状态栏
    if (kIsiPad) {
        browser.isFollowSystemRotation = YES;
    }
    browser.delegate = self;
    [browser showFromVC:self];
}

#pragma mark - GKPhotoBrowserDelegate
- (void)photoBrowser:(GKPhotoBrowser *)browser singleTapWithIndex:(NSInteger)index {
    [browser dismiss];
}

@end
