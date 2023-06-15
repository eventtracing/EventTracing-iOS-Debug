//
//  EventTracingInspectEngine+TwoD.m
//  EventTracingDebug
//
//  Created by jiangxiaofei on 2021/9/28.
//

#import "EventTracingInspectEngine+TwoD.h"
#import "EventTracingInspectEngine+Private.h"
#import "EventTracing2DContainerViewController.h"
#import "NEEventTracingVTree+DebugTool.h"
#import "UIView+ETBadge.h"
#import "EventTracingInfoSectionData.h"
#import <EventTracing/NEEventTracing.h>

#pragma clang diagnostic ignored "-Wincomplete-umbrella"
#import <EventTracing/NSArray+ETEnumerator.h>
#pragma clang diagnostic pop

#import <objc/message.h>

@implementation EventTracingInspectEngine (TwoD)

- (void)refreshBadgeViewWithNode:(NEEventTracingVTreeNode *)node {
    if ([self.eventIds containsObject:NE_ET_EVENT_ID_P_VIEW] ||
        [self.eventIds containsObject:NE_ET_EVENT_ID_E_VIEW]) {
        NSUInteger viewCount = node.impressLogRecoards.count;
        [node.view et_configViewWithBadge:viewCount visibleFrame:node.view.bounds];
        return;
    }
    
    if ([self.eventIds containsObject:NE_ET_EVENT_ID_E_CLCK]) {
        NSUInteger clickCount = node.clickLogRecoards.count;
        [node.view et_configViewWithBadge:clickCount visibleFrame:node.view.bounds];
        return;
    }
}

- (void)removeAllBadgeViews {
    NEEventTracingVTreeNode *rootNode = [NEEventTracingEngine sharedInstance].context.currentVTree.rootNode;
    [@[rootNode] ne_et_enumerateObjectsUsingBlock:^NSArray * _Nonnull(NEEventTracingVTreeNode * _Nonnull node, BOOL * _Nonnull stop) {
        if (node.view) {
            [node.view et_removeBadgeView];
        }
        return node.subNodes ?: @[];
    }];
}

- (void)beginInspectUI {
    self.inspectUIEnable = YES;
    
    [self.inspectorWindow.inspectControlBar updateInspectUIStatus:YES];
    [self inspectWindowBecomeKeyWindow];
}

- (void)endInspectUI {
    self.inspectUIEnable = NO;
    [self.inspectorWindow.inspectControlBar updateInspectUIStatus:NO];
    
    EventTracing2DContainerViewController *rootViewController = (EventTracing2DContainerViewController *)self.inspectorWindow.rootViewController;
    if (![rootViewController isKindOfClass:EventTracing2DContainerViewController.class]) {
        return;
    }
    
    [rootViewController.inspectViewController clearInspectUI];
}

- (void)inspectWindowBecomeKeyWindow {
    if ([UIApplication sharedApplication].keyWindow == self.inspectorWindow) {
        return;
    }
    self.previousKeyWindow = [UIApplication sharedApplication].keyWindow;
    
    [self _switchWindowTo:self.inspectorWindow];
}

- (void)inspectWindowResignKeyWindow {
    [self _switchWindowTo:self.previousKeyWindow];
}

- (void)_switchWindowTo:(UIWindow *)window {
    if ([UIApplication sharedApplication].keyWindow == window) {
        return;
    }
    
    [self.inspectorWindow.inspectControlBar removeFromSuperview];
    [window addSubview:self.inspectorWindow.inspectControlBar];
    
    [window makeKeyAndVisible];
}

@end
