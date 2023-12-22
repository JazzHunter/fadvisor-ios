//
//  VerticalFlowLayout.m
//  FingerAdvisor
//
//  Created by 韩建伟 on 2020/3/22.
//  Copyright © 2020 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//

#import "VerticalFlowLayout.h"

static const NSInteger defaultColumns = 3;
static const CGFloat defaultXMargin = 12;
static const CGFloat defaultYMargin = 12;
static const UIEdgeInsets defaultEdgeInsets = {20, 12, 12, 12};

@interface VerticalFlowLayout()

/** 所有的cell的attrbts */
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *atrbsArray;

/** 每一列的最后的高度 */
@property (nonatomic, strong) NSMutableArray<NSNumber *> *columnsHeightArray;

- (NSInteger)columns;

- (CGFloat)xMargin;

- (CGFloat)yMarginAtIndexPath:(NSIndexPath *)indexPath;

- (UIEdgeInsets)edgeInsets;

- (CGFloat)heightForHeader;

@end

@implementation VerticalFlowLayout

/**
 *  刷新布局的时候回重新调用
 */
- (void)prepareLayout {
    [super prepareLayout];
    
    //如果重新刷新就需要移除之前存储的高度
    [self.columnsHeightArray removeAllObjects];
    
    //复赋值以顶部的高度, 并且根据列数
    for (NSInteger i = 0; i < self.columns; i++) {
        [self.columnsHeightArray addObject:@(self.edgeInsets.top + self.heightForHeader)];
    }
    
    // 移除以前计算的cells的attrbs
    [self.atrbsArray removeAllObjects];
    
    // 并且重新计算, 每个cell对应的atrbs, 保存到数组
    for (NSInteger i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
        [self.atrbsArray addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]]];
    }
    
}

/**
 *在这里边所处每个cell对应的位置和大小
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *atrbs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat w = 1.0 * (self.collectionView.frame.size.width - self.edgeInsets.left - self.edgeInsets.right - self.xMargin * (self.columns - 1)) / self.columns;
    
    w = floorf(w);
    
    // 高度由外界决定, 外界必须实现这个方法
    CGFloat h = [self.delegate waterflowLayout:self collectionView:self.collectionView heightForItemAtIndexPath:indexPath itemWidth:w];
    
    // 拿到最后的高度最小的那一列, 假设第0列最小
   __block NSInteger indexCol = 0;
   __block CGFloat minColH = [self.columnsHeightArray[indexCol] doubleValue];

    [self.columnsHeightArray enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat colH = obj.floatValue;
        if (minColH > colH) {
            minColH = colH;
            indexCol = idx;
        }
    }];
    
    CGFloat x = self.edgeInsets.left + (self.xMargin + w) * indexCol;
    
    CGFloat y = minColH + [self yMarginAtIndexPath:indexPath];
    
    // 是第一行
    if (minColH == self.edgeInsets.top) {
        y = self.edgeInsets.top;
    }
    
    // 赋值frame
    atrbs.frame = CGRectMake(x, y, w, h);
    
    // 覆盖添加完后那一列;的最新高度
    self.columnsHeightArray[indexCol] = @(CGRectGetMaxY(atrbs.frame));
    
    return atrbs;
}

// layoutAttributesForElementsInRect
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.atrbsArray;
}


- (CGSize)collectionViewContentSize
{
    CGFloat maxColH = [self.columnsHeightArray.firstObject doubleValue];
    
    for (NSInteger i = 1; i < self.columnsHeightArray.count; i++)
    {
        CGFloat colH = [self.columnsHeightArray[i] doubleValue];
        if(maxColH < colH)
        {
            maxColH = colH;
        }
    }
    
    return CGSizeMake(self.collectionView.frame.size.width, maxColH + self.edgeInsets.bottom);
}


- (NSMutableArray *)atrbsArray {
    if(_atrbsArray == nil) {
        _atrbsArray = [NSMutableArray array];
    }
    return _atrbsArray;
}

- (NSMutableArray *)columnsHeightArray {
    if(_columnsHeightArray == nil) {
        _columnsHeightArray = [NSMutableArray array];
    }
    return _columnsHeightArray;
}

- (NSInteger)columns {
    if([self.delegate respondsToSelector:@selector(waterflowLayout:columnsInCollectionView:)]) {
        return [self.delegate waterflowLayout:self columnsInCollectionView:self.collectionView];
    } else {
        return defaultColumns;
    }
}

- (CGFloat)xMargin {
    if([self.delegate respondsToSelector:@selector(waterflowLayout:columnsMarginInCollectionView:)]) {
        return [self.delegate waterflowLayout:self columnsMarginInCollectionView:self.collectionView];
    }
    else {
        return defaultXMargin;
    }
}

- (CGFloat)yMarginAtIndexPath:(NSIndexPath *)indexPath {
    if([self.delegate respondsToSelector:@selector(waterflowLayout:collectionView:linesMarginForItemAtIndexPath:)]) {
        return [self.delegate waterflowLayout:self collectionView:self.collectionView linesMarginForItemAtIndexPath:indexPath];
    } else {
        return defaultYMargin;
    }
}

- (UIEdgeInsets)edgeInsets {
    if([self.delegate respondsToSelector:@selector(waterflowLayout:edgeInsetsInCollectionView:)]) {
        return [self.delegate waterflowLayout:self edgeInsetsInCollectionView:self.collectionView];
    } else {
        return defaultEdgeInsets;
    }
}

- (CGFloat)heightForHeader {
    if([self.delegate respondsToSelector:@selector(waterflowLayout:heightForHeader:)]) {
        return [self.delegate waterflowLayout:self heightForHeader:self.collectionView];
    } else {
        return 0;
    }
}

- (id<VerticalFlowLayoutDelegate>)delegate {
    return (id<VerticalFlowLayoutDelegate>)self.collectionView.dataSource;
}

- (instancetype)initWithDelegate:(id<VerticalFlowLayoutDelegate>)delegate {
    if (self = [super init]) {
    }
    return self;
}


+ (instancetype)flowLayoutWithDelegate:(id<VerticalFlowLayoutDelegate>)delegate {
    return [[self alloc] initWithDelegate:delegate];
}

@end
