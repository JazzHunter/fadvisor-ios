//
//  BaseCollectionViewController.m
//  FingerAdvisor
//
//  Created by 韩建伟 on 2020/3/22.
//  Copyright © 2020 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//

#import "BaseCollectionViewController.h"
#import "AutoRefreshFooter.h"
#import "VerticalFlowLayout.h"

@interface BaseCollectionViewController ()<VerticalFlowLayoutDelegate>

@end

@implementation BaseCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBaseCollectionViewControllerUI];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
}

- (void)setupBaseCollectionViewControllerUI {
    if ([self.parentViewController isKindOfClass:[UINavigationController class]]) {
        UIEdgeInsets contentInset = self.collectionView.contentInset;
        contentInset.top += kDefaultNavBarHeight;
        self.collectionView.contentInset = contentInset;
    }
    
    UICollectionViewLayout *myLayout = [self collectionViewController:self layoutForCollectionView:self.collectionView];
    self.collectionView.collectionViewLayout = myLayout;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
}

#pragma mark - delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];

    cell.contentView.backgroundColor = [UIColor yellowColor];

    cell.contentView.clipsToBounds = YES;
    if (![cell.contentView viewWithTag:100]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        label.tag = 100;
        label.textColor = [UIColor redColor];
        label.font = [UIFont boldSystemFontOfSize:17];
        [cell.contentView addSubview:label];
    }

    UILabel *label = [cell.contentView viewWithTag:100];

    label.text = [NSString stringWithFormat:@"%zd", indexPath.item];

    return cell;
}

#pragma mark - scrollDeleggate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    UIEdgeInsets contentInset = self.collectionView.contentInset;
    
    contentInset.bottom -= self.collectionView.mj_footer.frame.size.height;
    self.collectionView.scrollIndicatorInsets = contentInset;
    [self.view endEditing:YES];
}


#pragma mark - getter
- (UICollectionView *)collectionView {
    if(_collectionView == nil) {
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[UICollectionViewFlowLayout new]];
        [self.view addSubview:collectionView];
        _collectionView = collectionView;
        collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _collectionView;
}

#pragma mark - CollectionViewControllerDataSource
- (UICollectionViewLayout *)collectionViewController:(BaseCollectionViewController *)collectionViewController layoutForCollectionView:(UICollectionView *)collectionView {
    VerticalFlowLayout *myLayout = [[VerticalFlowLayout alloc] initWithDelegate:self];
    return myLayout;
}


#pragma mark - VerticalFlowLayoutDelegate

- (CGFloat)waterflowLayout:(VerticalFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth {
    return itemWidth * (arc4random() % 4 + 1);
}

@end
