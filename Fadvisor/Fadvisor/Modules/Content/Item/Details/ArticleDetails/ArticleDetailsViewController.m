//
//  ArticleDetailsViewController.m
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/24.
//

#import "ArticleDetailsViewController.h"
#import "ItemDetailsService.h"
#import "ContentDefine.h"
#import "ContentExcepitonView.h"
#import "ArticleContent.h"
#import "AuthorSection.h"
#import "SharePanel.h"
#import "SkeletonPageView.h"
#import <MJExtension.h>
#import "Collections.h"
#import "LEECoolButton.h"

@interface ArticleDetailsViewController ()<NavigationBarDataSource, NavigationBarDelegate, UIScrollViewDelegate>

@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, strong) ItemDetailsService *itemDetailsService;
@property (nonatomic, strong) ItemModel *itemModel;
@property (nonatomic, strong) ArticleDetailsModel *detailsModel;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) ArticleContent *articleContent;
@property (nonatomic, strong) Collections *collections;

@property (nonatomic, strong) MyLinearLayout *shareBtn;

@end

@implementation ArticleDetailsViewController

- (instancetype)initWithItem:(ItemModel *)itemModel {
    self = [super init];
    if (self) {
        _itemModel = itemModel;
        _itemId = itemModel.itemId;
    }

    return self;
}

- (instancetype)initWithId:(NSString *)itemId {
    self = [super init];
    if (self) {
        _itemId = [itemId copy];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBar];
    
    [self.scrollView setSafeBottomInset];
    self.contentLayout.padding = UIEdgeInsetsMake(ViewVerticalMargin, 0, ViewVerticalMargin, 0);

    [self initUI];
    [self getData];
}

- (void)initNavigationBar {
    self.navigationBar.delegate = self;
    self.navigationBar.dataSource = self;
    [self.navigationBar setTitleText:self.itemModel ? self.itemModel.title : @"读取中..."];
}

- (void)getData {
    [self.view showSkeletonPage:SkeletonPageViewTypeContentDetail isNavbarPadding:YES];
    Weak(self);
    [self.itemDetailsService getDetails:ItemTypeArticle itemId:self.itemId completion:^(NSString *errorMsg, NSDictionary *detailsDic) {
        weakself.detailsModel = [ArticleDetailsModel mj_objectWithKeyValues:detailsDic];
        
        weakself.itemModel = weakself.itemDetailsService.result.itemModel;
        
        weakself.titleLabel.text = weakself.itemModel.title;
        [weakself.titleLabel sizeToFit];
        
        [weakself.articleContent setModel:weakself.itemModel details:weakself.detailsModel authors:weakself.itemDetailsService.result.authors tags:weakself.itemDetailsService.result.tags attachments:weakself.itemDetailsService.result.attachments relatedItems:weakself.itemDetailsService.result.relatedItems ];
        
        if (weakself.itemDetailsService.result.collections && weakself.itemDetailsService.result.collections.count > 0) {
            [self.collections setModels:weakself.itemDetailsService.result.collections];
            [self.contentLayout addSubview:self.collections];
        } else {
            [self.collections removeFromSuperview];
        }
    }];
}

- (void)initUI {
    self.scrollView.delegate = self;

    self.titleLabel.myLeading = self.titleLabel.myTrailing = ViewHorizonlMargin;
    self.titleLabel.myBottom = 12;
    
    [self.contentLayout addSubview:self.titleLabel];
    
    Weak(self);
    self.articleContent.richTextView.loadedFinishBlock = ^(CGFloat height) {
        if (height > 0) {
            weakself.articleContent.richTextView.myHeight = height;
            weakself.articleContent.richTextView.alpha = 0.0f;
            // 富文本读取后取消隐藏
            [weakself.view hideSkeletonPage];
            [UIView animateWithDuration:0.3f animations:^{
                weakself.articleContent.richTextView.alpha = 1.0f;
            }];
        } else {
            // 加载失败 提示用户
        }
    };
    self.articleContent.backgroundColor = [UIColor backgroundColor];
    [self.contentLayout addSubview:self.articleContent];
    
    self.collections.myHorzMargin = 0;
    self.collections.padding = UIEdgeInsetsMake(ViewVerticalMargin, ViewHorizonlMargin, ViewVerticalMargin, ViewHorizonlMargin);
    self.collections.backgroundColor = [UIColor backgroundColor];
    self.collections.myTop = 12;
    
    MyLinearLayout *shareBtn = [[MyLinearLayout alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [shareBtn setHighlightedOpacity:0.5];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"ic_share"]];
    [shareBtn setTarget:self action:@selector(handleSharePanelOpen:)];
    self.shareBtn = shareBtn;
    [self.contentLayout addSubview:self.shareBtn];
    
    //星星按钮
    
    LEECoolButton *starButton = [LEECoolButton coolButtonWithImage:[UIImage imageNamed:@"ic_star"] ImageFrame:CGRectMake(44, 44, 12, 12)];
    
    starButton.frame = CGRectMake(0, 0, 100, 100);
    
    [starButton addTarget:self action:@selector(starButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentLayout addSubview:starButton];
}

- (void)starButtonAction:(LEECoolButton *)sender{
    
    if (sender.selected) {
        //未选中状态
        [sender deselect];
    } else {
        //选中状态
        [sender select];
    }
    
}

- (void)handleSharePanelOpen:(MyBaseLayout *)sender {
    [[SharePanel manager] showPanelWithItem:self.itemModel];
}

#pragma mark - BaseViewControllerDatasource
- (BOOL)baseViewControllerIsNeedNavBar:(BaseViewController *)baseViewController {
    return YES;
}

#pragma mark - ScrollViewDelgate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 传递滑动
    [self.articleContent.richTextView offsetY:(self.articleContent.richTextView.frame.origin.y - scrollView.contentOffset.y)];
}

#pragma mark - getters and setters
- (ItemDetailsService *)itemDetailsService {
    if (_itemDetailsService == nil) {
        _itemDetailsService = [[ItemDetailsService alloc] init];
    }
    return _itemDetailsService;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:DetailsTitleFontSize weight:UIFontWeightSemibold];
        _titleLabel.textColor = [UIColor titleTextColor];
    }
    return _titleLabel;
}

- (ArticleContent *)articleContent {
    if (_articleContent == nil) {
        _articleContent = [[ArticleContent alloc] init];
    }
    return _articleContent;
}

- (Collections *)collections {
    if (_collections == nil) {
        _collections = [[Collections alloc] init];
    }
    return _collections;
}


//- (SharePanel *)sharePanel {
//    if (_sharePanel == nil) {
//        _sharePanel = [[SharePanel alloc] initWithFrame:CGRectMake(0, 0, 120, 240)];
//    }
//    return _sharePanel;
//}

@end
