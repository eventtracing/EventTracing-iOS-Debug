//
//  EventTracingInspectEngine+TwoD.h
//  EventTracingDebug
//
//  Created by jiangxiaofei on 2021/9/28.
//

#import "EventTracingInspectEngine.h"
#import "EventTracingInspectEngine+Private.h"

NS_ASSUME_NONNULL_BEGIN

@interface EventTracingInspectEngine (TwoD)

@property(nonatomic, strong, nullable) EventTracingInspect2DWindow *inspectorWindow;

- (void)beginInspectUI;
- (void)endInspectUI;

- (void)inspectWindowBecomeKeyWindow;
- (void)inspectWindowResignKeyWindow;

- (void)refreshBadgeViewWithNode:(NEEventTracingVTreeNode *)node;
- (void)removeAllBadgeViews;

@end

NS_ASSUME_NONNULL_END
