//
//  DcoDetailsContentViewController.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/6/29.
//

#import "DocDetailsContentViewController.h"

@interface DocDetailsContentViewController ()<UIScrollViewDelegate>

@property (nonatomic, copy) void (^ scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) ItemModel *itemModel;
@property (nonatomic, strong) NSArray<NSString*> *snapshotArr;

@end

@implementation DocDetailsContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)initUI {
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    
    self.contentLayout.padding = UIEdgeInsetsMake(ViewVerticalMargin, ViewHorizonlMargin, ViewVerticalMargin, ViewHorizonlMargin);
    
    self.contentLayout.gravity = MyGravity_Horz_Fill;

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

#pragma mark - ScrollViewDelgate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 传递滑动
    !self.scrollCallback ? : self.scrollCallback(scrollView);
}

#pragma mark - getters and setters

- (void)setModel:(ItemModel *)itemModel details:(DocDetailsModel *)detailsModel {
    self.itemModel = itemModel;
    
    _snapshotArr = [detailsModel.snapshots componentsSeparatedByString:@","];
    
    [_snapshotArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *snapshotView = [self createSnapshotImageView:obj];
        if (idx != 0) {
            snapshotView.myTop = 5;
        }
        [self.contentLayout addSubview:snapshotView];
    }];
    
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

@end
