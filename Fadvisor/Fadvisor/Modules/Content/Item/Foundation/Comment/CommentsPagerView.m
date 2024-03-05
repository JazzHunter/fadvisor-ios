//
//  CommentsPagerView.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/3/5.
//

#import "CommentsPagerView.h"

@interface CommentsPagerView ()

@property (nonatomic, copy) void (^ scrollCallback)(UIScrollView *scrollView);

@end

@implementation CommentsPagerView

#pragma mark - UITableViewDataSource

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 传递滑动
    !self.scrollCallback ? : self.scrollCallback(scrollView);
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
