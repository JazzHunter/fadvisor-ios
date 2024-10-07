//
//  ColumnDetailsItemsViewController.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/9/29.
//

#import "ColumnDetailsItemsViewController.h"
#import "CollItemsService.h"

#import "ItemFloatCoverTableViewCell.h"
#import "ArticleFloatCoverTableViewCell.h"
#import "VideoLongCoverTableViewCell.h"
#import "DocFloatTypeTableViewCell.h"
#import "ContentExcepitonView.h"

#import "ArticleDetailsViewController.h"
#import "VideoDetailsViewController.h"
#import "DocDetailsViewController.h"

#import "AutoRefreshFooter.h"
#import "RefreshHeader.h"

@interface ColumnDetailsItemsViewController ()

@property (nonatomic, copy) void (^ scrollCallback)(UIScrollView *scrollView);

@property (nonatomic, strong) CollItemsService *itemsService;

@property (nonatomic, strong) ItemModel *collectionModel;

@end

@implementation ColumnDetailsItemsViewController

- (instancetype)initWithCollection:(ItemModel *)collectionModel {
    self = [super init];
    if (self) {
        self.collectionModel = collectionModel;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setSafeBottomInset];
    
    [self.tableView registerClass:[ItemFloatCoverTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ItemFloatCoverTableViewCell class])];
    [self.tableView registerClass:[ArticleFloatCoverTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ArticleFloatCoverTableViewCell class])];
    [self.tableView registerClass:[VideoLongCoverTableViewCell class] forCellReuseIdentifier:NSStringFromClass([VideoLongCoverTableViewCell class])];
    [self.tableView registerClass:[DocFloatTypeTableViewCell class] forCellReuseIdentifier:NSStringFromClass([DocFloatTypeTableViewCell class])];

    // init data
    self.inited = NO;

    //添加 Header & Footer
    Weak(self);
    self.tableView.mj_footer = [AutoRefreshFooter footerWithRefreshingBlock:^{
        
        if (weakself.itemsService.noMore) {
            [weakself.tableView.mj_footer endRefreshing];
            [weakself.tableView.mj_footer setState:MJRefreshStateNoMoreData];
            return;
        }

        [self.itemsService getItems:^(NSString *errorMsg, BOOL isHaveNewData) {
            // 结束刷新状态
            ![weakself.tableView.mj_footer isRefreshing] ? : [weakself.tableView.mj_footer endRefreshing];

            if (errorMsg) {
//                [NotificationView showNotificaiton:errorMsg type:NotificationDanger];
//                [weakself.tableView.mj_footer setState:MJRefreshStateIdle];
                return;
            }

            if (isHaveNewData) {
                [weakself.tableView reloadData];
            }
            
            [weakself.tableView.mj_footer setState:weakself.itemsService.noMore ? MJRefreshStateNoMoreData : MJRefreshStateIdle];
        }];
    }];
    
    // 第一次加载
    [self.itemsService getItems:^(NSString *errorMsg, BOOL isHaveNewData) {
        
        if (errorMsg) {
            // 处理错误
            return;
        }

        if (isHaveNewData) {
            [weakself.tableView reloadData];
        }
        
        if (!self.inited) {
            self.inited = YES;
        }
        
        [weakself.tableView.mj_footer setState:weakself.itemsService.noMore ? MJRefreshStateNoMoreData : MJRefreshStateIdle];
    }];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    // 这里因为有作者 Cell
    NSInteger index = indexPath.row > 3 ? indexPath.row - 1 : indexPath.row;

    ItemModel *model = self.itemsService.items[index];
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
    return self.itemsService.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.item;

    ItemModel *item = self.itemsService.items[index];

    MyBorderline *bottomBorderLine = (index  == self.itemsService.items.count - 1) ? nil : [[MyBorderline alloc] initWithColor:[UIColor backgroundColorGray] thick:6];
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
- (CollItemsService *)itemsService {
    if (_itemsService == nil) {
        _itemsService = [[CollItemsService alloc] init];
        [_itemsService resetWithCollection: self.collectionModel];
    }
    return _itemsService;
}


@end
