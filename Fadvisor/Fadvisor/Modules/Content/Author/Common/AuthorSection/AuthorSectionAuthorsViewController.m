//
//  AuthorSectionAuthorsViewController.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/8/7.
//

#import "AuthorSectionAuthorsViewController.h"
#import <HWPanModal/HWPanModal.h>
#import "AuthorInList.h"

@interface AuthorSectionAuthorsViewController ()<HWPanModalPresentable>

@property (nonatomic, strong) MyLinearLayout *contentLayout;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray <AuthorModel *> *models;

@end

@implementation AuthorSectionAuthorsViewController

- (instancetype)initWithModels:(NSArray <AuthorModel *> *)models {
    self = [super init];
    if (self) {
        self.models = [NSArray arrayWithArray:models];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBaseScrollViewUI];
}

- (void)setupBaseScrollViewUI {
    [self.view addSubview:self.scrollView];

    self.scrollView.backgroundColor = [UIColor backgroundColor];

    MyLinearLayout *contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    contentLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0); //设置布局内的子视图离自己的边距.
    contentLayout.myHorzMargin = 0;                          //同时指定左右边距为0表示宽度和父视图一样宽
//    contentLayout.heightSize.lBound(_scrollView.heightSize, 0, 1); //高度虽然是自适应的。但是最小的高度不能低于父视图的高度.
    [_scrollView addSubview:contentLayout];
    self.contentLayout = contentLayout;
    
    UILabel *descLabel = [UILabel new];
    descLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    descLabel.text = @"作者列表";
    [descLabel sizeToFit];
    descLabel.textColor = [UIColor titleTextColor];
    descLabel.myLeading = descLabel.myTrailing = ViewHorizonlMargin;
    descLabel.myTop = descLabel.myBottom = ViewVerticalMargin;
    [self.contentLayout addSubview:descLabel];

    for (AuthorModel *model in self.models) {
        AuthorInList *authorInList = [AuthorInList new];
        [authorInList setModel:model];
        authorInList.padding = UIEdgeInsetsMake(ViewVerticalMargin, ViewHorizonlMargin, ViewHorizonlMargin, ViewHorizonlMargin);
        authorInList.backgroundColor = [UIColor backgroundColor];
        authorInList.topBorderline = [[MyBorderline alloc] initWithColor:[UIColor backgroundColorGray] thick:6];
        [self.contentLayout addSubview:authorInList];
    }
    
    for (AuthorModel *model in self.models) {
        AuthorInList *authorInList = [AuthorInList new];
        [authorInList setModel:model];
        authorInList.padding = UIEdgeInsetsMake(ViewVerticalMargin, ViewHorizonlMargin, ViewHorizonlMargin, ViewHorizonlMargin);
        authorInList.backgroundColor = [UIColor backgroundColor];
        authorInList.topBorderline = [[MyBorderline alloc] initWithColor:[UIColor backgroundColorGray] thick:6];
        [self.contentLayout addSubview:authorInList];
    }
    
    for (AuthorModel *model in self.models) {
        AuthorInList *authorInList = [AuthorInList new];
        [authorInList setModel:model];
        authorInList.padding = UIEdgeInsetsMake(ViewVerticalMargin, ViewHorizonlMargin, ViewHorizonlMargin, ViewHorizonlMargin);
        authorInList.backgroundColor = [UIColor backgroundColor];
        authorInList.topBorderline = [[MyBorderline alloc] initWithColor:[UIColor backgroundColorGray] thick:6];
        [self.contentLayout addSubview:authorInList];
    }
    
    for (AuthorModel *model in self.models) {
        AuthorInList *authorInList = [AuthorInList new];
        [authorInList setModel:model];
        authorInList.padding = UIEdgeInsetsMake(ViewVerticalMargin, ViewHorizonlMargin, ViewHorizonlMargin, ViewHorizonlMargin);
        authorInList.backgroundColor = [UIColor backgroundColor];
        authorInList.topBorderline = [[MyBorderline alloc] initWithColor:[UIColor backgroundColorGray] thick:6];
        [self.contentLayout addSubview:authorInList];
    }
    
    for (AuthorModel *model in self.models) {
        AuthorInList *authorInList = [AuthorInList new];
        [authorInList setModel:model];
        authorInList.padding = UIEdgeInsetsMake(ViewVerticalMargin, ViewHorizonlMargin, ViewHorizonlMargin, ViewHorizonlMargin);
        authorInList.backgroundColor = [UIColor backgroundColor];
        authorInList.topBorderline = [[MyBorderline alloc] initWithColor:[UIColor backgroundColorGray] thick:6];
        [self.contentLayout addSubview:authorInList];
    }
}


#pragma mark - HWPanModalPresentable
- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeContent, 500.00001);
}

- (nullable UIScrollView *)panScrollable {
    return self.scrollView;
}


#pragma mark - Getters & Setters

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView = scrollView;
    }
    return _scrollView;
}

@end
