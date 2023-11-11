//
//  TabHomeRcmdViewController.m
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/10.
//

#import "TabHomeRcmdViewController.h"

@interface TabHomeRcmdViewController ()

@property (nonatomic, copy) void (^scrollCallback)(UIScrollView *scrollView);

@end

@implementation TabHomeRcmdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
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


@end
