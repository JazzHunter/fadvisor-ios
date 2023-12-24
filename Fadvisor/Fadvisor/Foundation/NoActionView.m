//
//  NoActionView.m
//  Fadvisor
//
//  Created by 韩建伟 on 2023/12/24.
//

#import "NoActionView.h"

@implementation NoActionView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    
    return  view == self ? nil : view;
}

@end
