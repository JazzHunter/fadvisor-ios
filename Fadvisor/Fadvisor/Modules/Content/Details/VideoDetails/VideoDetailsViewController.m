//
//  VideoDetailsViewController.m
//  Fadvisor
//
//  Created by 韩建伟 on 2023/12/9.
//

#import "VideoDetailsViewController.h"
#import "AlivcPlayerManager.h"
#import "AUIPlayerDetailVideoContainer.h"
#import "AlivcPlayerMacro.h"
#import "ItemDetailsService.h"
#import "MediaModel.h"
#import "AUIPlayerBackScrollView.h"

#import "JXCategoryView.h"
#import "JXPagerListRefreshView.h"

static const CGFloat pinSectionHeaderHeight = 44.f;

@interface VideoDetailsViewController ()<AlivcPlayerPluginEventProtocol, UIGestureRecognizerDelegate>
@property (nonatomic, copy) NSString *videoId;
@property (nonatomic, strong) ItemDetailsService *itemDetailsService;
@property (nonatomic, strong) ItemModel *info;
//@property (nonatomic, strong) VideoDetailsModel *detailsModel;

@property (nonatomic, strong) AUIPlayerDetailVideoContainer *detailVideoContainer;
@property (nonatomic, copy)  NSArray<ItemModel *> *list;
@property (nonatomic, weak) UIView *lastVideoContainer;
@property (nonatomic, strong) UIScrollView *scrollView;

//@property (nonatomic, strong) JXCategoryTitleView *categoryView;
//@property (nonatomic, strong) JXPagerView *pagerView;
@end

@implementation VideoDetailsViewController

- (instancetype)initWithItem:(ItemModel *)model {
    self = [super init];
    if (self) {
        _info = model;
        _videoId = model.itemId;
    }

    return self;
}

- (instancetype)initWithId:(NSString *)videoId {
    self = [super init];
    if (self) {
        _videoId = [videoId copy];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];

    [AlivcPlayerManager manager].shouldFlowOrientation = YES;
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];

    [self getData];
}

- (void)initUI {
    [self.view addSubview:self.detailVideoContainer];
}

- (void)getData {
    NSMutableArray *list = [NSMutableArray array];
    ItemModel *itemModel = [ItemModel new];
    itemModel.mediaId = @"ff196a0069a571eeb1930666a2ec0102";
    itemModel.uuid = [NSUUID UUID];
    [list addObject:itemModel];
    self.list = list;
    [self addVidToPlayer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [AlivcPlayerManager manager].pageEventFrom = AlivcPlayerPageEventFromDetailPage;

    UIView *containerView = [AlivcPlayerManager manager].playContainView;
    containerView.hidden = NO;
    self.lastVideoContainer = containerView.superview;
    [self.detailVideoContainer addSubview:containerView];
    containerView.frame = self.detailVideoContainer.bounds;
    self.info = [self.list objectAtIndex:0];

    if (self.info.mediaId && self.info.uuid.UUIDString) {
        if (![[AlivcPlayerManager manager].currentVideoId isEqualToString:self.info.mediaId]) {
            [AlivcPlayerManager manager].disableVideo = NO;
            [[AlivcPlayerManager manager] moveToVideoId:self.info.mediaId uuid:self.info.uuid.UUIDString];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    UIView *containerView = [AlivcPlayerManager manager].playContainView;
    [self.lastVideoContainer addSubview:containerView];
    containerView.frame = self.lastVideoContainer.bounds;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if ([AlivcPlayerManager manager].pageEventJump == AlivcPlayerPageEventJumpFullScreenToDetailPage) {
        [AlivcPlayerManager manager].backgroudModeEnabled = NO;
    }

    [AlivcPlayerManager manager].shouldFlowOrientation = NO;
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];

    if ([AlivcPlayerManager manager].pageEventJump == AlivcPlayerPageEventJumpFullScreenToDetailPage) {
        [[AlivcPlayerManager manager] destroyIncludePlayer:YES];
    }
    [AlivcPlayerManager manager].pageEventJump = AlivcPlayerPageEventJumpNone;
}

- (AUIPlayerDetailVideoContainer *)detailVideoContainer
{
    if (!_detailVideoContainer) {
        //UIView *containerView = [AlivcPlayerManager manager].playContainView;
        CGFloat scale = 9.0 / 16.0;
//        if (containerView.bounds.size.width > 0) {
//            scale = containerView.bounds.size.height / containerView.bounds.size.width;
//        }
        CGRect rect = CGRectMake(0, 0, self.view.width, self.view.width * scale);
        _detailVideoContainer = [[AUIPlayerDetailVideoContainer alloc] initWithFrame:rect];
        _detailVideoContainer.backgroundColor = AlivcPlayerColor(@"vf_video_bg");
    }
    return _detailVideoContainer;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[AUIPlayerBackScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;

        CGFloat top = self.detailVideoContainer.bottom;
        _scrollView.frame = CGRectMake(0, top, self.view.width, self.view.height - top);
        _scrollView.contentSize = CGSizeMake(self.view.width, _scrollView.height);
    }
    return _scrollView;
}

- (void)addVidToPlayer
{
    NSString *currentUUid = [AlivcPlayerManager manager].currentUuid;
    NSString *currentVideoId = [AlivcPlayerManager manager].currentVideoId;

    NSMutableArray *list = [NSMutableArray array];
    [self.list enumerateObjectsUsingBlock:^(ItemModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (obj.mediaId && [currentVideoId isEqualToString:obj.mediaId]) {
            obj.uuid = [[NSUUID alloc] initWithUUIDString:currentUUid];
        }
        if (obj.mediaId && obj.uuid.UUIDString) {
            NSDictionary *dict = [NSDictionary dictionaryWithObject:obj.mediaId forKey:obj.uuid.UUIDString];

            [list addObject:dict];
        }
    }];

    [AlivcPlayerManager manager].playerSourceList = list;
}

#pragma mark - scrollview

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

@end
