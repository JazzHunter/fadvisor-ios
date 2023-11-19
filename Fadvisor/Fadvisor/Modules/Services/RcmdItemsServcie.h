//
//  RcmdItems.h
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/16.
//

#import "BaseRequest.h"
#import "Item.h"

NS_ASSUME_NONNULL_BEGIN

@interface RcmdItemsServcie : BaseRequest

@property (nonatomic, strong) NSMutableArray<Item *> *rcmdItems;

- (void)getHomeRcmdItems:(BOOL)isMore completion:(void (^)(NSError *error, BOOL isHaveNextPage))completion;

@end

NS_ASSUME_NONNULL_END
