//
//  PlayerDetailsWatchTimeTipsView.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/20.
//

#import "PlayerDetailsWatchTimeTips.h"
#import "AlivcPlayerManager.h"
#import "Utils.h"

#define kDelayTime 1500

@interface PlayerDetailsWatchTimeTips ()

@end

@implementation PlayerDetailsWatchTimeTips

- (void)showWatchTimeTips:(float)watchTime
{
    [self cancelHideWatchTimeTips];

    NSString *text = [NSString stringWithFormat:@"已为您定位到%@  ", [Utils timeFormatFromSeconds:watchTime]];
    NSString *suffText = @"取消";

    NSMutableAttributedString *richText = [[NSMutableAttributedString alloc] init];

    NSAttributedString *textRich = [[NSAttributedString alloc] initWithString:text attributes:@{ NSForegroundColorAttributeName: UIColor.whiteColor }];
    [richText appendAttributedString:textRich];

    NSAttributedString *suffRich = [[NSAttributedString alloc] initWithString:suffText attributes:@{ NSForegroundColorAttributeName: UIColor.mainColor }];
    [richText appendAttributedString:suffRich];

    self.clipsToBounds = YES;
    self.layer.cornerRadius = 4;
    [self setAttributedText:richText];
    self.textAlignment = NSTextAlignmentCenter;
    self.backgroundColor = [UIColor maskBgColor];
    self.font = [UIFont systemFontOfSize:12];

    [self sizeToFit];

    CGFloat width = self.bounds.size.width + 24;

    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSeekStartClick:)];
    [self addGestureRecognizer:tapGesture];

    self.frame = CGRectMake(0, 0, width, 36);
    
    [self performSelector:@selector(hideWatchTimeTips) withObject:nil afterDelay:kDelayTime];
}

- (void)cancelHideWatchTimeTips
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideWatchTimeTips) object:nil];
    [self hideWatchTimeTips];
}

- (void)hideWatchTimeTips
{
    [self removeFromSuperview];
}

- (void)onSeekStartClick:(id)sender
{
    [self cancelHideWatchTimeTips];
    [PLAYER_MANAGER seekTo:0];
}

@end
