//
//  PopCollItemsViewController.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/8/16.
//

#import "ItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PopCollItemsViewController : UIViewController

@property (nonatomic, strong) UITableView *tableView;

- (void)setCollection:(ItemModel *)colleciton;

@end

NS_ASSUME_NONNULL_END
