//
//  BaseTableViewController.m
//  FingerAdvisor
//
//  Created by 韩建伟 on 2020/2/23.
//  Copyright © 2020 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ItemFloatCoverSkeletonTableViewCell.h"

@interface BaseTableViewController ()

@property (nonatomic, assign) UITableViewStyle tableViewStyle;

@end

@implementation BaseTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super init]) {
        _tableViewStyle = style;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBaseTableViewUI];
}

- (void)setupBaseTableViewUI {
    if ([self baseViewControllerIsNeedNavBar:self]) {
        UIEdgeInsets contentInset = self.tableView.contentInset;
        contentInset.top += kDefaultNavBarHeight;
        self.tableView.contentInset = contentInset;
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    // 适配 ios 11
    self.tableView.estimatedRowHeight = 80;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.backgroundColor = [UIColor clearColor];

    //配置骨架屏
    self.tableView.tabAnimated = [TABTableAnimated animatedWithCellClass:[ItemFloatCoverSkeletonTableViewCell class] cellHeight:160];
    self.tableView.tabAnimated.showTableHeaderView = YES;
    self.tableView.tabAnimated.superAnimationType = TABViewSuperAnimationTypeShimmer;
    self.tableView.tabAnimated.canLoadAgain = YES;
    self.tableView.tabAnimated.adjustBlock = ^(TABComponentManager *_Nonnull manager) {
        manager.animation(1).dropStayTime(0.6).height(13);
        manager.animation(3).height(16);
        manager.animation(4).height(14);
        manager.animation(5).height(12);
        manager.animation(6).height(4);
    };
}

#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UITableViewCell new];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:self.tableViewStyle];
        [self.view addSubview:tableView];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView = tableView;
    }
    return _tableView;
}

@end
