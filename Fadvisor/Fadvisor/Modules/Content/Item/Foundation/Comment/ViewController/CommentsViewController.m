//
//  CommentsViewController.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/3/2.
//

#import "CommentsViewController.h"
#import "CommentsService.h"
#import "CommentCell.h"
#import "CommentSetCell.h"
#import "AutoRefreshFooter.h"
#import "RefreshHeader.h"
#import "NotificationView.h"
#import "SkeletonPageView.h"
#import "ContentExcepitonView.h"
#import "PopRepliesNavViewController.h"
#import <HWPanModal/HWPanModal.h>

@interface CommentsViewController ()<CommentSetCellDelegate>

@property (nonatomic, strong) CommentsService *commentsService;
@property (nonatomic, strong) ItemModel *itemModel;

@property (nonatomic, assign) BOOL inited;

@end

@implementation CommentsViewController

- (instancetype)initWithModel:(ItemModel *)model {
    self = [super init];
    if (self) {
        self.itemModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setSafeBottomInset];

    [self.tableView registerClass:[CommentCell class] forCellReuseIdentifier:NSStringFromClass([CommentCell class])];
    [self.tableView registerClass:[CommentSetCell class] forCellReuseIdentifier:NSStringFromClass([CommentSetCell class])];

    // init data
    self.inited = NO;

    //添加 Header & Footer
    Weak(self);
    self.tableView.mj_header = [RefreshHeader headerWithRefreshingBlock:^{
        if ([weakself.tableView.mj_footer isRefreshing]) {
            [weakself.tableView.mj_header endRefreshing];
        }
        if (self.commentsService.noMore) {
            [weakself.tableView.mj_header endRefreshing];
            [NotificationView showNotificaiton:@"没有新数据了" type:NotificationInfo];
            
            return;
        }
        if (!weakself.inited) {
            [weakself.view showSkeletonPage:SkeletonPageViewTypeCell isNavbarPadding:NO];
        }
        [self.commentsService getComments:NO completion:^(NSString *errorMsg, BOOL isHaveNewData) {
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

            if (weakself.commentsService.total == 0) {
                [weakself.tableView showEmptyList];
                return;
            } else if (weakself.tableView.mj_footer.hidden == YES) {
                weakself.tableView.mj_footer.hidden = NO;
                [weakself.tableView.mj_footer setState:weakself.commentsService.noMore ? MJRefreshStateNoMoreData : MJRefreshStateIdle];
            }
        }];
    }];
    self.tableView.mj_footer = [AutoRefreshFooter footerWithRefreshingBlock:^{
        if (weakself.commentsService.noMore) {
            [weakself.tableView.mj_footer endRefreshing];
            [weakself.tableView.mj_footer setState:MJRefreshStateNoMoreData];
            return;
        }

        if ([weakself.tableView.mj_header isRefreshing]) {
            [weakself.tableView.mj_footer endRefreshing];
            return;
        }
        [self.commentsService getComments:YES completion:^(NSString *errorMsg, BOOL isHaveNewData) {
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
            [weakself.tableView.mj_footer setState:weakself.commentsService.noMore ? MJRefreshStateNoMoreData : MJRefreshStateIdle];
        }];
    }];

    self.tableView.mj_footer.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentsService.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.commentsService.orderType isEqualToString:COMMENTS_ORDER_TYPE_SET]) {
        CommentSetCell *cell = (CommentSetCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CommentSetCell class]) forIndexPath:indexPath];
        cell.delegate = self;
        [cell setModel:self.commentsService.comments[indexPath.item]];
        //这里设置其他位置有间隔线而最后一行没有下划线。我们可以借助布局视图本身所提供的边界线来代替掉系统默认的cell之间的间隔线，因为布局视图的边界线所提供的能力要大于默认的间隔线。
        if (indexPath.row  == self.commentsService.comments.count - 1) {
            cell.rootLayout.bottomBorderline = nil;
        } else {
            MyBorderline *bld = [[MyBorderline alloc] initWithColor:[UIColor backgroundColorGray] thick:6];
            cell.rootLayout.bottomBorderline = bld;
        }
        return cell;
    }

    CommentCell *cell = (CommentCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CommentCell class]) forIndexPath:indexPath];
    [cell setModel:self.commentsService.comments[indexPath.item]];
    //这里设置其他位置有间隔线而最后一行没有下划线。我们可以借助布局视图本身所提供的边界线来代替掉系统默认的cell之间的间隔线，因为布局视图的边界线所提供的能力要大于默认的间隔线。
    if (indexPath.row  == self.commentsService.comments.count - 1) {
        cell.rootLayout.bottomBorderline = nil;
    } else {
        MyBorderline *bld = [[MyBorderline alloc] initWithColor:[UIColor backgroundColorGray] thick:6];
        cell.rootLayout.bottomBorderline = bld;
    }
    return cell;
}

#pragma mark - CommentSetCellDelegate
- (void)showMoreCommentsClicked:(UITableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath) {
        PopRepliesNavViewController *popRepliesNavVC = [[PopRepliesNavViewController alloc]initWithMasterComment:self.commentsService.comments[indexPath.item]];
        [self.navigationController.topViewController presentPanModal:popRepliesNavVC completion:^{
            NSLog(@"aaa");
        }];
    }
}

#pragma mark - getters and setters
- (CommentsService *)commentsService {
    if (_commentsService == nil) {
        _commentsService = [[CommentsService alloc] initWithItemType:self.itemModel.itemType itemId:self.itemModel.itemId commentMode:self.itemModel.commentMode];

//        _commentsService.orderType = COMMENTS_ORDER_TYPE_TIME;
    }
    return _commentsService;
}

@end
