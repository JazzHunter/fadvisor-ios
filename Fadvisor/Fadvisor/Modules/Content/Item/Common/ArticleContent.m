//
//  ArticleContent.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/8/10.
//

#import "ArticleContent.h"
#import "Utils.h"
#import "ContentTags.h"
#import "Attachments.h"
#import "RelatedItems.h"

@interface ArticleContent ()

@property (nonatomic, strong) ItemModel *itemModel;
@property (nonatomic, strong) ArticleDetailsModel *detailsModel;

@property (nonatomic, strong) AuthorSection *authorSection;
@property (nonatomic, strong) UILabel *topInfoLabel;
@property (nonatomic, strong) UILabel *updateTimeLabel;

@property (nonatomic, strong) Attachments *attachments;
@property (nonatomic, strong) ContentTags *contentTags;
@property (nonatomic, strong) RelatedItems *relatedItems;

@end

@implementation ArticleContent

- (instancetype)init {
    self = [super init];
    if (self) {
        self.orientation = MyOrientation_Vert;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.myHorzMargin = 0;
    self.myHeight = MyLayoutSize.wrap;
    self.subviewVSpace = 12;
    self.gravity = MyGravity_Horz_Fill;

    self.authorSection.padding = UIEdgeInsetsMake(0, ViewHorizonlMargin, 0, ViewHorizonlMargin);
    [self addSubview:self.authorSection];

    self.topInfoLabel = [UILabel new];
    self.topInfoLabel.textColor = [UIColor metaTextColor];
    self.topInfoLabel.font =  [UIFont systemFontOfSize:ListMetaFontSize];
    self.topInfoLabel.myLeading = self.topInfoLabel.myTrailing = ViewHorizonlMargin;
    [self addSubview:self.topInfoLabel];

    self.richTextView.myLeading = self.richTextView.myTrailing = ViewHorizonlMargin;
    [self addSubview:self.richTextView];

    self.updateTimeLabel = [UILabel new];
    self.updateTimeLabel.textColor = [UIColor metaTextColor];
    self.updateTimeLabel.font =  [UIFont systemFontOfSize:ListMetaFontSize];
    self.updateTimeLabel.myTop = 8;
    self.updateTimeLabel.myLeading = self.updateTimeLabel.myTrailing = ViewHorizonlMargin;
    [self addSubview:self.updateTimeLabel];
    
    self.contentTags.myHorzMargin = ViewHorizonlMargin;
    
    self.attachments.myHorzMargin = ViewHorizonlMargin;
}

- (void)setModel:(ItemModel *)model details:(ArticleDetailsModel *)details authors:(NSArray <AuthorModel *> *)authors tags:(NSArray <TagModel *> *)tags attachments:(NSArray <ItemModel *> *)attachments relatedItems:(NSArray <ItemModel *> *)relatedItems {
    self.itemModel = model;
    self.detailsModel = details;

    [self.authorSection setModels:authors];

    self.topInfoLabel.text = [NSString stringWithFormat:@"%@ · 共%@字 · 约需%@", [Utils formatBackendTimeString:model.pubTime], [Utils countStringHandle:model.totalWords],  [Utils durationFormatFromSeconds:model.readingTime]];
    [self.topInfoLabel sizeToFit];

    [self.richTextView handleHTML:details.content];

    self.updateTimeLabel.text = [NSString stringWithFormat:@"编辑于%@", [Utils formatBackendTimeString:model.updateTime]];
    [self.updateTimeLabel sizeToFit];

    if (tags && tags.count > 0) {
        [self.contentTags setModels:tags];
        [self addSubview:self.contentTags];
    } else {
        [self.contentTags removeFromSuperview];
    }

    if (attachments && attachments.count > 0) {
        [self.attachments setModels:attachments];
        [self addSubview:self.attachments];
    } else {
        [self.attachments removeFromSuperview];
    }

    if (relatedItems && relatedItems.count > 0) {
        [self.relatedItems setModels:relatedItems];
        [self addSubview:self.relatedItems];
    } else {
        [self.relatedItems removeFromSuperview];
    }
}

#pragma mark - ScrollViewDelgate
- (AuthorSection *)authorSection {
    if (_authorSection == nil) {
        _authorSection = [[AuthorSection alloc] init];
    }
    return _authorSection;
}

- (RichTextView *)richTextView {
    if (_richTextView == nil) {
        _richTextView = [[RichTextView alloc] init];
        _richTextView.myHorzMargin = 0;                          //同时指定左右边距为0表示宽度和父视图一样宽
//        _richTextView.heightSize.lBound(self.view.heightSize, 0, 1); //高度虽然是自适应的。但是最小的高度不能低于父视图的高度.
    }
    return _richTextView;
}

- (Attachments *)attachments {
    if (_attachments == nil) {
        _attachments = [[Attachments alloc] init];
    }
    return _attachments;
}

- (ContentTags *)contentTags {
    if (_contentTags == nil) {
        _contentTags = [[ContentTags alloc] init];
    }
    return _contentTags;
}

- (RelatedItems *)relatedItems {
    if (_relatedItems == nil) {
        _relatedItems = [[RelatedItems alloc] init];
    }
    return _relatedItems;
}

@end
