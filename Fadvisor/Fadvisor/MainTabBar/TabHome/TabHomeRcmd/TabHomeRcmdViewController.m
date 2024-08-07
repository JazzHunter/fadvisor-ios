//
//  TabHomeRcmdViewController.m
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/10.
//

#import "TabHomeRcmdViewController.h"
#import "RcmdItemsService.h"
#import "RcmdAuthorsService.h"
#import "AutoRefreshFooter.h"
#import "RefreshHeader.h"
#import "NotificationView.h"
#import "ArticleDetailsViewController.h"
#import "VideoDetailsViewController.h"
#import "DocDetailsViewController.h"
#import "ContentExcepitonView.h"
#import "SkeletonPageView.h"

#import "ItemFloatCoverTableViewCell.h"
#import "ArticleFloatCoverTableViewCell.h"
#import "VideoLongCoverTableViewCell.h"
#import "DocFloatTypeTableViewCell.h"

#import "TabHomeRcmdAuthorsTableViewCell.h"

@interface TabHomeRcmdViewController ()

@property (nonatomic, copy) void (^ scrollCallback)(UIScrollView *scrollView);

@property (nonatomic, strong) RcmdItemsService *rcmdItemsService;
@property (nonatomic, strong) RcmdAuthorsService *rcmdAuthorsService;

@property (nonatomic, assign) BOOL inited;

@end

@implementation TabHomeRcmdViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[ItemFloatCoverTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ItemFloatCoverTableViewCell class])];
    [self.tableView registerClass:[ArticleFloatCoverTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ArticleFloatCoverTableViewCell class])];
    [self.tableView registerClass:[VideoLongCoverTableViewCell class] forCellReuseIdentifier:NSStringFromClass([VideoLongCoverTableViewCell class])];
    [self.tableView registerClass:[DocFloatTypeTableViewCell class] forCellReuseIdentifier:NSStringFromClass([DocFloatTypeTableViewCell class])];
    [self.tableView registerClass:[TabHomeRcmdAuthorsTableViewCell class] forCellReuseIdentifier:NSStringFromClass([TabHomeRcmdAuthorsTableViewCell class])];

    // init data
    self.inited = NO;

    //添加 Header & Footer
    Weak(self);
    self.tableView.mj_header = [RefreshHeader headerWithRefreshingBlock:^{
        if ([weakself.tableView.mj_footer isRefreshing]) {
            [weakself.tableView.mj_header endRefreshing];
        }
        if (self.rcmdItemsService.noMore) {
            [weakself.tableView.mj_header endRefreshing];
            [NotificationView showNotificaiton:@"没有新数据了" type:NotificationInfo];
            return;
        }
        if (!weakself.inited) {
            [weakself.view showSkeletonPage:SkeletonPageViewTypeCell isNavbarPadding:NO];
        }
        [self.rcmdItemsService getHomeRcmdItems:NO completion:^(NSString *errorMsg, BOOL isHaveNewData) {
            [weakself.view hideSkeletonPage];
            // 结束刷新状态
            ![weakself.tableView.mj_header isRefreshing] ? : [weakself.tableView.mj_header endRefreshing];
            ![weakself.tableView.mj_footer isRefreshing] ? : [weakself.tableView.mj_footer endRefreshing];
            // 错误处理
            if (errorMsg) {
                if (weakself.inited) {
                    [NotificationView showNotificaiton:errorMsg type:NotificationDanger];
                } else {
                    [weakself.view showNetworkError:errorMsg reloadButtonBlock:^(id sender) {
                        [weakself.view hideBlankPage];
                        [weakself.tableView.mj_header beginRefreshing];
                    }];
                }
                return;
            }

            if (!weakself.inited) {
                weakself.inited = YES;
            } else {
                [NotificationView showNotificaiton:isHaveNewData ? @"已为您加载了新数据" : @"没有新数据了"];
            }

            if (isHaveNewData) {
                [weakself.tableView reloadData];
            }

            if (weakself.rcmdItemsService.total == 0) {
                [weakself.tableView showEmptyList];
                return;
            } else if (weakself.tableView.mj_footer.hidden == YES) {
                weakself.tableView.mj_footer.hidden = NO;
                [weakself.tableView.mj_footer setState:weakself.rcmdItemsService.noMore ? MJRefreshStateNoMoreData : MJRefreshStateIdle];
            }
        }];
    }];
    self.tableView.mj_footer = [AutoRefreshFooter footerWithRefreshingBlock:^{
        if (weakself.rcmdItemsService.noMore) {
            [weakself.tableView.mj_footer endRefreshing];
            [weakself.tableView.mj_footer setState:MJRefreshStateNoMoreData];
            return;
        }

        if ([weakself.tableView.mj_header isRefreshing]) {
            [weakself.tableView.mj_footer endRefreshing];
            return;
        }
        [self.rcmdItemsService getHomeRcmdItems:YES completion:^(NSString *errorMsg, BOOL isHaveNewData) {
            // 结束刷新状态
            ![weakself.tableView.mj_header isRefreshing] ? : [weakself.tableView.mj_header endRefreshing];
            ![weakself.tableView.mj_footer isRefreshing] ? : [weakself.tableView.mj_footer endRefreshing];

            if (errorMsg) {
                [NotificationView showNotificaiton:errorMsg type:NotificationDanger];
                [weakself.tableView.mj_footer setState:MJRefreshStateIdle];
                return;
            }

            if (isHaveNewData) {
                [weakself.tableView reloadData];
            }
            [weakself.tableView.mj_footer setState:weakself.rcmdItemsService.noMore ? MJRefreshStateNoMoreData : MJRefreshStateIdle];
        }];
    }];

    self.tableView.mj_footer.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 这里因为有作者 Cell
    NSInteger index = indexPath.row > 3 ? indexPath.row - 1 : indexPath.row;

    ItemModel *model = self.rcmdItemsService.rcmdItems[index];
    switch (model.itemType) {
        case ItemTypeArticle:{
            ArticleDetailsViewController *vc = [[ArticleDetailsViewController alloc] initWithItem:model];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } break;

        case ItemTypeDoc:{
            DocDetailsViewController *vc = [[DocDetailsViewController alloc] initWithItem:model];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } break;

        default:{
            VideoDetailsViewController *vc = [[VideoDetailsViewController alloc] initWithItem:model];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } break;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rcmdItemsService.rcmdItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.item;
    if (index == 3) {
        TabHomeRcmdAuthorsTableViewCell *cell = (TabHomeRcmdAuthorsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TabHomeRcmdAuthorsTableViewCell class]) forIndexPath:indexPath];
        Weak(self);
        if (!self.rcmdAuthorsService.inited) {
            [cell showLoading];
            [self.rcmdAuthorsService getRcmdAuthors:^(NSString *errorMsg) {
                // 错误处理
                if (errorMsg) {
                    return;
                }
                [cell setAuthorModels:weakself.rcmdAuthorsService.rcmdAuthors];
                [cell hideLoading];
            }];
        }
        
        return cell;
    }

    index = index > 3 ? index - 1 : index;

    ItemModel *item = self.rcmdItemsService.rcmdItems[index];

    MyBorderline *bottomBorderLine = (index  == self.rcmdItemsService.rcmdItems.count - 1) ? nil : [[MyBorderline alloc] initWithColor:[UIColor backgroundColorGray] thick:6];
    switch (item.itemType) {
        case ItemTypeArticle:{
            ArticleFloatCoverTableViewCell *cell = (ArticleFloatCoverTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ArticleFloatCoverTableViewCell class]) forIndexPath:indexPath];
            [cell setModel:item];
            //这里设置其他位置有间隔线而最后一行没有下划线。我们可以借助布局视图本身所提供的边界线来代替掉系统默认的cell之间的间隔线，因为布局视图的边界线所提供的能力要大于默认的间隔线。
            cell.rootLayout.bottomBorderline = bottomBorderLine;
            return cell;
        } break;

        case ItemTypeDoc:{
            DocFloatTypeTableViewCell *cell = (DocFloatTypeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DocFloatTypeTableViewCell class]) forIndexPath:indexPath];
            [cell setModel:item];
            //这里设置其他位置有间隔线而最后一行没有下划线。我们可以借助布局视图本身所提供的边界线来代替掉系统默认的cell之间的间隔线，因为布局视图的边界线所提供的能力要大于默认的间隔线。
            cell.rootLayout.bottomBorderline = bottomBorderLine;
            return cell;
        } break;

        case ItemTypeVideo:{
            VideoLongCoverTableViewCell *cell = (VideoLongCoverTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VideoLongCoverTableViewCell class]) forIndexPath:indexPath];
            [cell setModel:item];
            //这里设置其他位置有间隔线而最后一行没有下划线。我们可以借助布局视图本身所提供的边界线来代替掉系统默认的cell之间的间隔线，因为布局视图的边界线所提供的能力要大于默认的间隔线。
            cell.rootLayout.bottomBorderline = bottomBorderLine;
            return cell;
        } break;

        default:{
            ItemFloatCoverTableViewCell *cell = (ItemFloatCoverTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ItemFloatCoverTableViewCell class]) forIndexPath:indexPath];
            [cell setModel:item];
            //这里设置其他位置有间隔线而最后一行没有下划线。我们可以借助布局视图本身所提供的边界线来代替掉系统默认的cell之间的间隔线，因为布局视图的边界线所提供的能力要大于默认的间隔线。
            cell.rootLayout.bottomBorderline = bottomBorderLine;
            return cell;
        } break;
    }
}

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

#pragma mark - getters and setters
- (RcmdItemsService *)rcmdItemsService {
    if (_rcmdItemsService == nil) {
        _rcmdItemsService = [[RcmdItemsService alloc] init];
    }
    return _rcmdItemsService;
}

- (RcmdAuthorsService *)rcmdAuthorsService {
    if (_rcmdAuthorsService == nil) {
        _rcmdAuthorsService = [[RcmdAuthorsService alloc] init];
    }
    return _rcmdAuthorsService;
}

@end
