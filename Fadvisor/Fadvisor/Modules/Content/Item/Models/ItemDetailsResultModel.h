//
//  ItemDetailsResultModel.h
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/24.
//

#import <Foundation/Foundation.h>
#import "ItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ItemDetailsResultModel : NSObject

/** 返回的是什么结果 */
@property (assign, nonatomic) NSInteger resultMode;

/** 获取方式 */
@property (assign, nonatomic) NSInteger acquisitionAction;

/** Info信息 */
@property (nonatomic, strong) ItemModel *itemModel;

/** ViewId */
@property (nonatomic, copy) NSString *viewId;

/** 相关内容 */
@property (nonatomic, strong) NSMutableArray<ItemModel *> *relatedItems;

/** 附件数组 */
@property (nonatomic, strong) NSMutableArray<ItemModel *> *attachments;

/** 标签信息*/
@property (nonatomic, strong) NSMutableArray<TagModel *> *tags;

/** 被包含的栏目 */
@property (nonatomic, strong) NSMutableArray<ItemModel *> *collections;

/** 作者，这里的作者包括了统计数字 */
@property (nonatomic, strong) NSMutableArray<AuthorModel *> *authors;

@end

NS_ASSUME_NONNULL_END
