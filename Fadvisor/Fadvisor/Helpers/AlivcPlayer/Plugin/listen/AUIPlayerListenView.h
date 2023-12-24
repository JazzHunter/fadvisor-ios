//
//  AUIPlayerListenView.h
//  ApsaraVideo
//
//  Created by mengyehao on 2021/7/16.
//

#import <UIKit/UIKit.h>
#import "NoActionView.h"

NS_ASSUME_NONNULL_BEGIN
@interface AUIPlayerListenView : NoActionView
@property (nonatomic, assign) BOOL landScape;
@property (nonatomic, copy) dispatch_block_t onPlayButtonBlock;
@property (nonatomic, copy) dispatch_block_t onQuitButtonBlock;
@property (nonatomic, copy) dispatch_block_t onRePlayButtonBlock;


- (void)updatePlayStatus:(BOOL)play;

- (void)updateAvataImageWithCoverurl:(NSString *)coverurl;

- (void)updaRePlayHidden:(BOOL)hidden;

@end

NS_ASSUME_NONNULL_END
