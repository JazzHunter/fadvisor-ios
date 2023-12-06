//
//  BaseCollectionViewController.h
//  FingerAdvisor
//
//  Created by 韩建伟 on 2020/3/22.
//  Copyright © 2020 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class BaseCollectionViewController;
@protocol CollectionViewControllerDataSource <NSObject>

@required
// 需要返回对应的布局
- (UICollectionViewLayout *)collectionViewController:(BaseCollectionViewController *)collectionViewController layoutForCollectionView:(UICollectionView *)collectionView;

@end

@interface BaseCollectionViewController : BaseViewController  <UICollectionViewDelegate, UICollectionViewDataSource, CollectionViewControllerDataSource>

@property (weak, nonatomic) UICollectionView *collectionView;

@end

NS_ASSUME_NONNULL_END
