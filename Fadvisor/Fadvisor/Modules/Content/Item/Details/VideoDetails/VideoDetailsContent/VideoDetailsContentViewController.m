//
//  VideoDetailsContentViewController.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/1/22.
//

#import "VideoDetailsContentViewController.h"
#import "RichTextView.h"
#import "SharePanel.h"
#import "AuthorSection.h"

@interface VideoDetailsContentViewController ()<UIScrollViewDelegate>

@property (nonatomic, copy) void (^ scrollCallback)(UIScrollView *scrollView);

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *pubTimeLabel;
@property (nonatomic, strong) RichTextView *richTextView;
@property (nonatomic, strong) MyLinearLayout *shareBtn;
@property (nonatomic, strong) ItemModel *itemModel;

@property (nonatomic, strong) AuthorSection *authorSection;

@end

@implementation VideoDetailsContentViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    

}

- (void)initUI {
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    
    self.contentLayout.gravity = MyGravity_Horz_Fill;
    
    self.authorSection.padding = UIEdgeInsetsMake(12, ViewHorizonlMargin, 12, ViewHorizonlMargin);
    [self.contentLayout addSubview:self.authorSection];
    
    self.titleLabel.myHeight = MyLayoutSize.wrap;
    self.titleLabel.myLeft = self.titleLabel.myRight = ViewHorizonlMargin;
    [self.contentLayout addSubview:self.titleLabel];
    
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
    self.richTextView.myLeft = self.richTextView.myRight = ViewHorizonlMargin;
    [self.contentLayout addSubview:self.richTextView];
    
    UILabel *pubTimeLabel = [[UILabel alloc] init];
    self.pubTimeLabel = pubTimeLabel;
    [self.contentLayout addSubview:self.pubTimeLabel];
    
    MyLinearLayout *shareBtn = [[MyLinearLayout alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [shareBtn setHighlightedOpacity:0.5];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"ic_share"]];
    [shareBtn setTarget:self action:@selector(handleSharePanelOpen:)];
    self.shareBtn = shareBtn;
    [self.contentLayout addSubview:self.shareBtn];
}

- (void)handleSharePanelOpen:(MyBaseLayout *)sender {
    [[SharePanel manager] showPanelWithItem:self.itemModel];
}


#pragma mark - JXPagingViewListViewDelegate

- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.scrollView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)listWillAppear {
}

- (void)listDidAppear {
}

- (void)listWillDisappear {
}

- (void)listDidDisappear {
}

#pragma mark - ScrollViewDelgate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 传递滑动
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}

#pragma mark - getters and setters

- (void)setModel:(ItemModel *)itemModel details:(VideoDetailsModel *)detailsModel {
    self.itemModel = itemModel;
    
    [self.authorSection setModels:itemModel.authors];
    self.titleLabel.text = itemModel.title;
    
    
    [self.richTextView handleHTML:detailsModel.content];
}

- (AuthorSection *)authorSection {
    if (!_authorSection) {
        _authorSection = [[AuthorSection alloc] init];
    }
    return _authorSection;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:ListTitleFontSize weight:UIFontWeightSemibold];
        _titleLabel.textColor = [UIColor titleTextColor];
    }
    return _titleLabel;
}

- (RichTextView *)richTextView {
    if (_richTextView == nil) {
        _richTextView = [[RichTextView alloc] init];
//        _richTextView.heightSize.lBound(self.view.heightSize, 0, 1); //高度虽然是自适应的。但是最小的高度不能低于父视图的高度.
    }
    return _richTextView;
}

@end
