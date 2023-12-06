//
//  VerticalFlowLayout.h
//  瀑布流完善接口
//  FingerAdvisor
//
//  Created by 韩建伟 on 2020/3/22.
//  Copyright © 2020 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VerticalFlowLayout;

@protocol VerticalFlowLayoutDelegate <NSObject>
@required
/**
 *  要求实现
 *
 *  @param waterflowLayout 哪个布局需要代理返回高度
 *  @param indexPath          对应的cell, 的indexPath, 但是indexPath.section == 0
 *  @param itemWidth           layout内部计算的宽度
 *
 *  @return 需要代理高度对应的cell的高度
 */
- (CGFloat)waterflowLayout:(VerticalFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth;
@optional

/**
 *  需要显示的列数, 默认3
 */
- (NSInteger)waterflowLayout:(VerticalFlowLayout *)waterflowLayout columnsInCollectionView:(UICollectionView *)collectionView;
/**
 *  列间距
 */
- (CGFloat)waterflowLayout:(VerticalFlowLayout *)waterflowLayout columnsMarginInCollectionView:(UICollectionView *)collectionView;
/**
 *  行间距
 */
- (CGFloat)waterflowLayout:(VerticalFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView linesMarginForItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  距离collectionView四周的间距
 */
- (UIEdgeInsets)waterflowLayout:(VerticalFlowLayout *)waterflowLayout edgeInsetsInCollectionView:(UICollectionView *)collectionView;
/**
 *  Header视图的间高度
 */
- (CGFloat)waterflowLayout:(VerticalFlowLayout *)waterflowLayout heightForHeader:(UICollectionView *)collectionView;

@end

@interface VerticalFlowLayout : UICollectionViewLayout

/** layout的代理 */
- (instancetype)initWithDelegate:(id<VerticalFlowLayoutDelegate>)delegate;

+ (instancetype)flowLayoutWithDelegate:(id<VerticalFlowLayoutDelegate>)delegate;

@end
