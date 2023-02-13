//
//  UIView+ETBadge.m
//  EventTracingDebug
//
//  Created by jiangxiaofei on 2021/9/23.
//

#import "UIView+ETBadge.h"
#import <objc/message.h>


@implementation UIView (ETBadge)

- (EventTracingInspectBadgeView *)et_badgeView {
    return objc_getAssociatedObject(self, @selector(et_badgeView));
}

- (void)setEt_badgeView:(EventTracingInspectBadgeView *)et_badgeView {
    objc_setAssociatedObject(self, @selector(et_badgeView), et_badgeView, OBJC_ASSOCIATION_RETAIN);
}

- (void)et_configViewWithBadge:(NSUInteger)badge visibleFrame:(CGRect)visibleFrame {
    if (0 == badge && self.et_badgeView) {
        [self et_removeBadgeView];
        return;
    }
    if (0 == badge) {
        return;
    }
    
    if (!self.et_badgeView) {
        self.et_badgeView = [EventTracingInspectBadgeView new];
        if (self.superview) {
            // 添加为兄弟视图，防止被其它兄弟视图遮挡
            [self.superview addSubview:self.et_badgeView];
        } else {
            [self addSubview:self.et_badgeView];
        }
    }
    [self.et_badgeView setCountBadge:badge];
    [self.et_badgeView sizeToFit];
    
    CGRect bFrame = self.et_badgeView.frame;
    if (self.superview) {
        bFrame.origin.x = CGRectGetMaxX(self.frame) - CGRectGetWidth(bFrame);
        bFrame.origin.y = CGRectGetMinY(self.frame);
    } else {
        bFrame.origin.x = CGRectGetWidth(visibleFrame) - CGRectGetWidth(bFrame);
    }
    self.et_badgeView.frame = bFrame;
}

- (void)et_removeBadgeView {
    [self.et_badgeView removeFromSuperview];
    self.et_badgeView = nil;
}

@end
