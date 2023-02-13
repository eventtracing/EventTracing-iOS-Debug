//
//  UIView+ETBadge.h
//  EventTracingDebug
//
//  Created by jiangxiaofei on 2021/9/23.
//

#import <UIKit/UIKit.h>
#import "EventTracingInspectBadgeView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ETBadge)

@property (nonatomic, strong, nullable) EventTracingInspectBadgeView *et_badgeView;

- (void)et_configViewWithBadge:(NSUInteger)badge visibleFrame:(CGRect)visibleFrame;

- (void)et_removeBadgeView;

@end

NS_ASSUME_NONNULL_END
