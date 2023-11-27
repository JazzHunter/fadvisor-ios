//
//  TabHomeRcmdViewController.m
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/10.
//

#import "TabHomeRcmdViewController.h"
#import "RcmdItemsServcie.h"
#import "AutoRefreshFooter.h"
#import "RefreshHeader.h"
#import "NotificationView.h"
#import "ItemFloatTableViewCell.h"
#import "ArticleDetailsViewController.h"

@interface TabHomeRcmdViewController ()

@property (nonatomic, copy) void (^ scrollCallback)(UIScrollView *scrollView);

@property (nonatomic, strong) RcmdItemsServcie *rcmdItemsService;

@end

@implementation TabHomeRcmdViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[ItemFloatTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ItemFloatTableViewCell class])];

    //添加 Header & Footer
    Weak(self);
    self.tableView.mj_header = [RefreshHeader headerWithRefreshingBlock:^{
        if (self.rcmdItemsService.noMore) {
            [weakself.tableView.mj_header endRefreshing];
            [NotificationView showNotificaiton:@"没有新数据了" type:NotificationInfo];
            return;
        }
        if ([weakself.tableView.mj_footer isRefreshing]) {
            [weakself.tableView.mj_header endRefreshing];
        }
        [self.rcmdItemsService getHomeRcmdItems:NO completion:^(NSError *error, BOOL isHaveNewData) {
            // 结束刷新状态
            ![weakself.tableView.mj_header isRefreshing] ? : [weakself.tableView.mj_header endRefreshing];
            ![weakself.tableView.mj_footer isRefreshing] ? : [weakself.tableView.mj_footer endRefreshing];

            if (error) {
                [NotificationView showNotificaiton:error.localizedDescription type:NotificationDanger];
                return;
            }

            if (isHaveNewData) {
                [weakself.tableView reloadData];
            }
            [NotificationView showNotificaiton:isHaveNewData ? @"已为您加载了新数据" : @"没有新数据了"];
            [weakself.tableView.mj_footer setState:self.rcmdItemsService.noMore ? MJRefreshStateNoMoreData : MJRefreshStateIdle];
        }];
    }];
    self.tableView.mj_footer = [AutoRefreshFooter footerWithRefreshingBlock:^{
        if (weakself.rcmdItemsService.noMore) {
            [weakself.tableView.mj_footer endRefreshing];
            weakself.tableView.mj_header.hidden = YES;
            [weakself.tableView.mj_footer setState:MJRefreshStateNoMoreData];
            return;
        }

        if ([weakself.tableView.mj_header isRefreshing]) {
            [weakself.tableView.mj_footer endRefreshing];
            return;
        }
        [self.rcmdItemsService getHomeRcmdItems:YES completion:^(NSError *error, BOOL isHaveNewData) {
            // 结束刷新状态
            ![weakself.tableView.mj_header isRefreshing] ? : [weakself.tableView.mj_header endRefreshing];
            ![weakself.tableView.mj_footer isRefreshing] ? : [weakself.tableView.mj_footer endRefreshing];

            if (error) {
                [NotificationView showNotificaiton:error.localizedDescription type:NotificationDanger];
                return;
            }
            if (isHaveNewData) {
                [weakself.tableView reloadData];
            }
            [weakself.tableView.mj_footer setState:self.rcmdItemsService.noMore ? MJRefreshStateNoMoreData : MJRefreshStateIdle];
        }];
    }];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    ArticleDetailsViewController *vc = [[ArticleDetailsViewController alloc] init];
    ItemModel *model = self.rcmdItemsService.rcmdItems[indexPath.row];
    vc.articleId = model.itemId;

    vc.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if ([self numberOfSectionsInTableView:tableView] == 1) {
//        return self.topicCmtService.latestCmts.count;
//    }
    return self.rcmdItemsService.rcmdItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemFloatTableViewCell *cell = (ItemFloatTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ItemFloatTableViewCell class]) forIndexPath:indexPath];
    [cell setModel:self.rcmdItemsService.rcmdItems[indexPath.item]];

    //这里设置其他位置有间隔线而最后一行没有下划线。我们可以借助布局视图本身所提供的边界线来代替掉系统默认的cell之间的间隔线，因为布局视图的边界线所提供的能力要大于默认的间隔线。
    if (indexPath.row  == self.rcmdItemsService.rcmdItems.count - 1) {
        cell.rootLayout.bottomBorderline = nil;
    } else {
        MyBorderline *bld = [[MyBorderline alloc] initWithColor:[UIColor backgroundColorGray] thick:6];
        cell.rootLayout.bottomBorderline = bld;
    }
    return cell;
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

#pragma mark - getters and setters
- (RcmdItemsServcie *)rcmdItemsService {
    if (_rcmdItemsService == nil) {
        _rcmdItemsService = [[RcmdItemsServcie alloc] init];
    }
    return _rcmdItemsService;
}

@end
