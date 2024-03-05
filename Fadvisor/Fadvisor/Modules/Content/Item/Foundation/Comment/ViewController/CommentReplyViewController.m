//
//  CommentReplyViewController.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/3/4.
//

#import "CommentReplyViewController.h"
#import "CommentCell.h"
#import "CommentRepliesService.h"
#import "AutoRefreshFooter.h"
#import "RefreshHeader.h"
#import "NotificationView.h"
#import "SkeletonPageView.h"
#import "ContentExcepitonView.h"
#import "CommentCell.h"
#import "CommentView.h"

@interface CommentReplyViewController ()

@property (nonatomic, strong) CommentModel *masterCommentModel;

@property (nonatomic, strong) CommentRepliesService *repliesService;

@property (nonatomic, assign) BOOL inited;

@end

@implementation CommentReplyViewController

- (instancetype)initWithMasterComment:(CommentModel *)model {
    self = [super init];
    if (self) {
        self.masterCommentModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.repliesService = [[CommentRepliesService alloc] initWithMasterComment:self.masterCommentModel];
    
    [self.tableView setSafeBottomInset];
//
    [self.tableView registerClass:[CommentCell class] forCellReuseIdentifier:NSStringFromClass([CommentCell class])];
//    
    CommentView *masterCommentView = [[CommentView alloc] init];
    [masterCommentView setModel:self.masterCommentModel];
    masterCommentView.myWidth = self.tableView.width;
    MyBorderline *bld = [[MyBorderline alloc] initWithColor:[UIColor backgroundColorGray] thick:12];
    masterCommentView.bottomBorderline = bld;
    [masterCommentView layoutIfNeeded];
    
    self.tableView.tableHeaderView = masterCommentView;
    
   
    //添加 Header & Footer
    Weak(self);
    self.tableView.mj_header = [RefreshHeader headerWithRefreshingBlock:^{
        if ([weakself.tableView.mj_footer isRefreshing]) {
            [weakself.tableView.mj_header endRefreshing];
        }
        if (self.repliesService.noMore) {
            [weakself.tableView.mj_header endRefreshing];
            [NotificationView showNotificaiton:@"没有新数据了" type:NotificationInfo];
            return;
        }
        if (!weakself.inited) {
            [weakself.view showSkeletonPage:SkeletonPageViewTypeCell isNavbarPadding:NO];
        }
        [self.repliesService getReplies:NO completion:^(NSString *errorMsg, BOOL isHaveNewData) {
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

            if (weakself.repliesService.total == 0) {
                [weakself.tableView showEmptyList];
                return;
            } else if (weakself.tableView.mj_footer.hidden == YES) {
                weakself.tableView.mj_footer.hidden = NO;
                [weakself.tableView.mj_footer setState:weakself.repliesService.noMore ? MJRefreshStateNoMoreData : MJRefreshStateIdle];
            }
        }];
    }];
    self.tableView.mj_footer = [AutoRefreshFooter footerWithRefreshingBlock:^{
        if (weakself.repliesService.noMore) {
            [weakself.tableView.mj_footer endRefreshing];
            [weakself.tableView.mj_footer setState:MJRefreshStateNoMoreData];
            return;
        }

        if ([weakself.tableView.mj_header isRefreshing]) {
            [weakself.tableView.mj_footer endRefreshing];
            return;
        }
        [self.repliesService getReplies:YES completion:^(NSString *errorMsg, BOOL isHaveNewData) {
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
            [weakself.tableView.mj_footer setState:weakself.repliesService.noMore ? MJRefreshStateNoMoreData : MJRefreshStateIdle];
        }];
    }];

    self.tableView.mj_footer.hidden = YES;
    [self.tableView.mj_header beginRefreshing];

}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.repliesService.replies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = (CommentCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CommentCell class]) forIndexPath:indexPath];
    [cell setModel:self.repliesService.replies[indexPath.item]];
    //这里设置其他位置有间隔线而最后一行没有下划线。我们可以借助布局视图本身所提供的边界线来代替掉系统默认的cell之间的间隔线，因为布局视图的边界线所提供的能力要大于默认的间隔线。
    if (indexPath.row  == self.repliesService.replies.count - 1) {
        cell.rootLayout.bottomBorderline = nil;
    } else {
        MyBorderline *bld = [[MyBorderline alloc] initWithColor:[UIColor backgroundColorGray] thick:6];
        cell.rootLayout.bottomBorderline = bld;
    }
    return cell;
}

@end
