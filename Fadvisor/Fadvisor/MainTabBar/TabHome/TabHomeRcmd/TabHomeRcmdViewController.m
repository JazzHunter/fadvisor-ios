//
//  TabHomeRcmdViewController.m
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/10.
//

#import "TabHomeRcmdViewController.h"
#import "RcmdItemsServcie.h"

@interface TabHomeRcmdViewController ()

@property (nonatomic, copy) void (^ scrollCallback)(UIScrollView *scrollView);

@property (nonatomic, strong) RcmdItemsServcie *rcmdItemsServices;

@end

@implementation TabHomeRcmdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [self loadMore:NO];
}

- (void)loadMore:(BOOL)isMore {
    Weak(self);
    [self.rcmdItemsServices getHomeRcmdItems:isMore completion:^(NSError *error, BOOL isHaveNextPage) {
//        [self endHeaderFooterRefreshing];
        if (error) {
//            [weakself.view makeToast:error.localizedDescription];
        }
        [self.tableView reloadData];
    }];
}

#pragma mark - JXPagingViewListViewDelegate

- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.tableView;
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

#pragma mark - getter
- (RcmdItemsServcie *)rcmdItemsServices {
    if (_rcmdItemsServices == nil) {
        _rcmdItemsServices = [[RcmdItemsServcie alloc] init];
    }
    return _rcmdItemsServices;
}

@end
