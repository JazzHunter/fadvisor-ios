//
//  BaseTableViewController.h
//  FingerAdvisor
//
//  Created by 韩建伟 on 2020/2/23.
//  Copyright © 2020 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import <TABAnimated/TABAnimated.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) UITableView *tableView;
// tableview的样式, 默认plain
- (instancetype)initWithStyle:(UITableViewStyle)style;

@end

NS_ASSUME_NONNULL_END
