//
//  PopCollItemsViewController.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/8/16.
//

#import "PopCollItemsViewController.h"
#import "ItemInListTableViewCell.h"
#import "DocInListTableViewCell.h"
#import "AutoRefreshFooter.h"
#import "CollItemsService.h"
#import "NotificationView.h"
#import "ContentDefine.h"
#import <HWPanModal/HWPanModal.h>
#import "ImageButton.h"

@interface PopCollItemsViewController () <HWPanModalPresentable, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel *headerTitleLabel;
@property (nonatomic, strong) CollItemsService *collItemService;
@property (nonatomic, strong) ItemModel *collectionModel;
@property (nonatomic, strong) MyRelativeLayout *headerView;
@property (nonatomic, strong) ImageButton *closeButton;

@end

@implementation PopCollItemsViewController

- (void)loadView {
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    rootLayout.backgroundColor = [UIColor backgroundColorGray];
    rootLayout.insetsPaddingFromSafeArea = UIRectEdgeNone;
    rootLayout.gravity = MyGravity_Horz_Fill;
    rootLayout.subviewVSpace = 8;
    self.view = rootLayout;

    _headerView = [MyRelativeLayout new];
    _headerView.myHeight = ViewVerticalMargin * 2 + 14 + 12 + 4;
    _headerView.padding = UIEdgeInsetsMake(ViewVerticalMargin, ViewHorizonlMargin, ViewVerticalMargin, ViewHorizonlMargin);
    [self.view addSubview:_headerView];

    _headerTitleLabel = [UILabel new];
    _headerTitleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    _headerTitleLabel.textColor = [UIColor titleTextColor];
    _headerTitleLabel.myHeight = 14;
    _headerTitleLabel.leftPos.equalTo(_headerView.leftPos);
    _headerTitleLabel.topPos.equalTo(_headerView.topPos);
    _headerTitleLabel.rightPos.equalTo(_headerView.rightPos).offset(24);
    [_headerView addSubview:_headerTitleLabel];

    _closeButton = [[ImageButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [_closeButton setImage:[[[UIImage imageNamed:@"ic_close"] imageWithTintColor:[UIColor descriptionTextColor]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_closeButton enableTouchDownAnimation];
    [_closeButton addTarget:self action:@selector(closeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    _closeButton.rightPos.equalTo(_headerView.rightPos);
    _closeButton.topPos.equalTo(_headerView.topPos);
    [_headerView addSubview:_closeButton];

    _tableView = [[UITableView alloc] init];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.weight = 1;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    // 适配 ios 11
    _tableView.estimatedRowHeight = 80;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView setSafeBottomInset];
    [self.view addSubview:_tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[ItemInListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ItemInListTableViewCell class])];
    [self.tableView registerClass:[DocInListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([DocInListTableViewCell class])];

    //添加 Header & Footer
    self.tableView.mj_header.hidden = YES;

    Weak(self);
    self.tableView.mj_footer = [AutoRefreshFooter footerWithRefreshingBlock:^{
        if (weakself.collItemService.noMore) {
            [weakself.tableView.mj_footer endRefreshing];
            [weakself.tableView.mj_footer setState:MJRefreshStateNoMoreData];
            return;
        }

        [self.collItemService getItems:^(NSString *errorMsg, BOOL isHaveNewData) {
            // 结束刷新状态
//            ![weakself.tableView.mj_footer isRefreshing] ? : [weakself.tableView.mj_footer endRefreshing];

            if (errorMsg) {
                [NotificationView showNotificaiton:errorMsg type:NotificationDanger];
                [weakself.tableView.mj_footer setState:MJRefreshStateIdle];
                return;
            }

            if (isHaveNewData) {
                [weakself.tableView reloadData];
            }
            [weakself.tableView.mj_footer setState:weakself.collItemService.noMore ? MJRefreshStateNoMoreData : MJRefreshStateIdle];
        }];
    }];
}

- (void)setCollection:(ItemModel *)colleciton {
    self.collectionModel = colleciton;
    self.headerTitleLabel.text = colleciton.title;

    [self.collItemService resetWithCollection:colleciton];

    //⚠️ 这里应该是循环
    [self.tableView.mj_footer beginRefreshing];
}

- (void)closeButtonTapped:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 禁止下拉bounce
    CGPoint offset = self.tableView.contentOffset;

    if (self.tableView.contentOffset.y <= 0) {
        offset.y = 0;
    }
    self.tableView.contentOffset = offset;
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
    return self.collItemService.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyBorderline *bottomBorderLine = (indexPath.item  == self.collItemService.items.count - 1) ? nil : [[MyBorderline alloc] initWithColor:[UIColor backgroundColorGray] thick:6];

    ItemModel *item = self.collItemService.items[indexPath.item];
    switch (item.itemType) {
        case ItemTypeDoc:{
            DocInListTableViewCell *cell = (DocInListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DocInListTableViewCell class]) forIndexPath:indexPath];
            [cell setModel:item];
            //这里设置其他位置有间隔线而最后一行没有下划线。我们可以借助布局视图本身所提供的边界线来代替掉系统默认的cell之间的间隔线，因为布局视图的边界线所提供的能力要大于默认的间隔线。
            cell.rootLayout.bottomBorderline = bottomBorderLine;
            return cell;
        } break;
        default:{
            ItemInListTableViewCell *cell = (ItemInListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ItemInListTableViewCell class]) forIndexPath:indexPath];
            [cell setModel:item];
            //这里设置其他位置有间隔线而最后一行没有下划线。我们可以借助布局视图本身所提供的边界线来代替掉系统默认的cell之间的间隔线，因为布局视图的边界线所提供的能力要大于默认的间隔线。
            cell.rootLayout.bottomBorderline = bottomBorderLine;
            return cell;
        } break;
    }
}

#pragma mark - HWPanModalPresentable

- (nullable UIScrollView *)panScrollable {
    return self.tableView;
}

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMaxTopInset, kDefaultNavBarHeight);
}

- (CGFloat)topOffset {
    return 0;
}

- (BOOL)showDragIndicator {
    return YES;
}

- (BOOL)shouldRespondToPanModalGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    // 如果拖拽的点在navigation bar上，则返回yes，可以拖拽，否则只能滑动tableView
    CGPoint loc = [panGestureRecognizer locationInView:self.view];
    if (CGRectContainsPoint(self.headerView.frame, loc)) {
        return YES;
    }
    return NO;
}

#pragma mark - getters and setters
- (CollItemsService *)collItemService {
    if (_collItemService == nil) {
        _collItemService = [[CollItemsService alloc] init];
    }
    return _collItemService;
}

@end
