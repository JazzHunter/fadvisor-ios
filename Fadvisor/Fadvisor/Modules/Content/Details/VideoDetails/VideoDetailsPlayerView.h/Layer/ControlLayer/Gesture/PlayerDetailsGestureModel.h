
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(int, GestureOrientation) {
    GestureOrientationUnknow = 0,
    GestureOrientationHorizontal,
    GestureOrientationVertical
};


@class PlayerDetailsGestureModel;

@protocol PlayerDetailsGestureModelDelegate <NSObject>

@required
//单击屏幕
- (void)onSingleClicked;

//双击屏幕
- (void)onDoubleClicked;

//手势水平移动偏移量
- (void)horizontalOrientationMoveOffset:(float)moveOffset;

@optional
//手势在view左侧区域，上下移动时 对亮度的设置
- (void)gestureModel:(PlayerDetailsGestureModel*)gestureModel brightnessDirection:(UISwipeGestureRecognizerDirection)direction;

//手势在view左侧区域，上下移动时 对音量的设置
- (void)gestureModel:(PlayerDetailsGestureModel*)gestureModel volumeDirection:(UISwipeGestureRecognizerDirection)direction;

/*
 * 功能：手势移动方向
 * 参数 ：ALYPVGestureModel 对象自己
         state 手势当前状态（开始、移动、结束）
         moveOrientation 手势移动方向
 
 */
- (void)gestureModel:(PlayerDetailsGestureModel*)gestureModel state:(UIGestureRecognizerState)state moveOrientation:(GestureOrientation)moveOrientation;


@end

@interface PlayerDetailsGestureModel : NSObject

@property (nonatomic, weak) id<PlayerDetailsGestureModelDelegate>delegate;
@property (nonatomic, assign) BOOL isLock;

/*
 * 功能 ：手势添加到特定的view中
 */
- (void)setView:(id)view;

@end
