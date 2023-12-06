//
//  ContentExcepitonView.h
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/30.
//

#import <UIKit/UIKit.h>
#import "ContentEnum.h"
#import "ItemModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSInteger {
    ContentExcepitonTypeNoData,
    ContentExcepitonTypeNetworkError,
    ContentExcepitonTypeUnknown,
} ContentExcepitonType;


@interface ContentExcepitonView : UIView

- (void)config:(ContentExcepitonType)contentExcepitonType tips:(NSString *)tips reloadButtonBlock:(void (^)(UIButton *sender))block;
- (void)config:(ResultMode)resultMode acquisitionAction:(AcquisitionAction)acquisitionAction model:(ItemModel *)model reloadButtonBlock:(void (^)(UIButton *sender))block;

@end

@interface UIView (ContentExcepitonView)

- (void)showEmptyList;
- (void)showNetworkError:(nullable NSString *)tips reloadButtonBlock:(void (^)(id))block;
- (void)showPermissionError:(ResultMode)resultMode acquisitionAction:(AcquisitionAction)acquisitionAction model:(ItemModel *)model reloadButtonBlock:(void (^)(UIButton *sender))block;

@end

NS_ASSUME_NONNULL_END
