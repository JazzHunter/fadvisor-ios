//
//  ArticleDetailsViewController.m
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/24.
//

#import "ArticleDetailsViewController.h"
#import "ItemDetailsService.h"
#import "ContentEnum.h"
#import "ContentExcepitonView.h"
#import "RichTextView.h"

@interface ArticleDetailsViewController ()<UIScrollViewDelegate>

@property (nonatomic, copy) NSString *articleId;
@property (nonatomic, strong) ItemDetailsService *itemDetailsService;
@property (nonatomic, strong) ItemModel *info;
@property (nonatomic, strong) ArticleDetailsModel *detailsModel;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *pubTimeLabel;
@property (nonatomic, strong) RichTextView *richTextView;

@end

@implementation ArticleDetailsViewController

- (instancetype)initWithItem:(ItemModel *)model {
    self = [super init];
    if (self) {
        _info = model;
        _articleId = model.itemId;
    }
    
    return self;
}

- (instancetype)initWithId:(NSString *)articleId {
    self = [super init];
    if (self) {
        _articleId = [articleId copy];
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    
    [self initNavigationBar];
    
    [self initUI];
}

- (void)initNavigationBar {
    self.navigationBar.delegate = self;
    self.navigationBar.dataSource = self;
    [self.navigationBar setTitleText:self.info ? self.info.title : @"读取中..."];
}

- (void)getData {
    Weak(self);
    [self.itemDetailsService getDetails:ItemTypeArticle itemId:self.articleId completion:^(NSString *errorMsg, NSDictionary *detailsDic) {
        weakself.detailsModel = [ArticleDetailsModel mj_objectWithKeyValues:detailsDic];
        
        weakself.info = weakself.itemDetailsService.result.info;
        
        [weakself.richTextView handleHTML:weakself.detailsModel.content];
        [weakself.pubTimeLabel setText:@"编辑于刚刚"];
        [weakself.pubTimeLabel sizeToFit];
    }];
}

- (void)initUI {
    self.scrollView.delegate = self;
    
    Weak(self);
    self.richTextView.loadedFinishBlock = ^(CGFloat height) {
        if (height > 0) {
            weakself.richTextView.myHeight = height;
            weakself.richTextView.alpha = 0.0f;
            [UIView animateWithDuration:0.3f animations:^{
                weakself.richTextView.alpha = 1.0f;
            }];
        } else {
            // 加载失败 提示用户
        }
        
    };
    
    UIView *test = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 1000)];
    test.backgroundColor = [UIColor greenColor];
    
    [self.contentLayout addSubview:self.titleLabel];
    [self.contentLayout addSubview:test];
    [self.contentLayout addSubview:self.richTextView];
    
    UILabel *pubTimeLabel = [[UILabel alloc] init];
    self.pubTimeLabel = pubTimeLabel;
    [self.contentLayout addSubview:self.pubTimeLabel];
}

#pragma mark - BaseViewControllerDatasource
- (BOOL)baseViewControllerIsNeedNavBar:(BaseViewController *)baseViewController {
    return YES;
}

#pragma mark - ScrollViewDelgate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 传递滑动
    [self.richTextView offsetY:(self.richTextView.frame.origin.y - scrollView.contentOffset.y)];
}


#pragma mark - getters and setters
- (ItemDetailsService *)itemDetailsService {
    if (_itemDetailsService == nil) {
        _itemDetailsService = [[ItemDetailsService alloc] init];
    }
    return _itemDetailsService;
}

- (RichTextView *)richTextView {
    if (_richTextView == nil) {
        _richTextView = [[RichTextView alloc] init];
        _richTextView.myHorzMargin = 0;                          //同时指定左右边距为0表示宽度和父视图一样宽
        _richTextView.heightSize.lBound(self.view.heightSize, 0, 1); //高度虽然是自适应的。但是最小的高度不能低于父视图的高度.
    }
    return _richTextView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

@end
