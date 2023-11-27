//
//  ArticleDetailsViewController.m
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/24.
//

#import "ArticleDetailsViewController.h"
#import "ItemDetailsService.h"
#import "ContentEnum.h"

@interface ArticleDetailsViewController ()

@property (nonatomic, strong) ItemDetailsService *itemDetailsService;
@property (nonatomic, strong) ArticleDetailsModel *detailsModel;

@end

@implementation ArticleDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self configNavigationBar];
    
    [self getData];
    
    
}

- (void) configNavigationBar {
    
    self.navigationBar.delegate = self;
    self.navigationBar.dataSource = self;
    [self.navigationBar setTitleText:@"读取中"];
}

- (void)getData {
    Weak(self);
    [self.itemDetailsService getDetails:ItemTypeArticle itemId:self.articleId completion:^(NSError *error, NSDictionary *detailsDic) {
        [weakself.navigationBar setTitleText:weakself.itemDetailsService.result.info.title];
        weakself.detailsModel = [ArticleDetailsModel mj_objectWithKeyValues:detailsDic];
    }];
}

#pragma mark - BaseViewControllerDatasource
- (BOOL)baseViewControllerIsNeedNavBar:(BaseViewController *)baseViewController {
    return YES;
}

#pragma mark - getters and setters
- (ItemDetailsService *)itemDetailsService {
    if (_itemDetailsService == nil) {
        _itemDetailsService = [[ItemDetailsService alloc] init];
    }
    return _itemDetailsService;
}

@end
