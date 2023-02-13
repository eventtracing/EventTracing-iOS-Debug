//
//  EventTracingInspectEngine.m
//  BlocksKit
//
//  Created by dl on 2021/5/12.
//

#import "EventTracingInspectEngine.h"
#import "EventTracingInspect2DWindow.h"
#import "EventTracingInspect2DViewController.h"
#import "EventTracingInspectEngine+Private.h"
#import "EventTracingInspectEngine+TwoD.h"
#import "EventTracingVTree+DebugTool.h"
#import <BlocksKit/BlocksKit.h>

#pragma clang diagnostic ignored "-Wincomplete-umbrella"
#import <EventTracing/NSArray+ETEnumerator.h>
#pragma clang diagnostic pop

@implementation EventTracingInspectEngine
@synthesize inspecting = _inspecting;

+ (instancetype)sharedInstance {
    static EventTracingInspectEngine *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[EventTracingInspectEngine alloc] init];
    });
    return instance;
}

- (void)startInspect2D {
    _inspecting = YES;

    [self _setupWindowIfNeeded];
    [self inspectWindowBecomeKeyWindow];
    [self beginInspectUI];
}

- (void)stop {
    _inspecting = NO;
    
    [self endInspectUI];
    
    [self inspectWindowResignKeyWindow];
    
    [self.inspectorWindow.inspectControlBar removeFromSuperview];
    [self.inspectorWindow removeFromSuperview];
    self.inspectorWindow = nil;
    
    [self removeAllBadgeViews];
}

#pragma mark - Internal

- (void)selectedEventIds:(NSArray<NSString *> *)eventIds name:(NSString *)name {
    self.eventIds = eventIds.copy;
    [self.inspectorWindow.inspectControlBar updateLeftItemName:name highlight:eventIds.count > 0];
    if (eventIds.count) {
        EventTracingVTreeNode *rootNode = [EventTracingEngine sharedInstance].context.currentVTree.rootNode;
        [@[rootNode] et_enumerateObjectsUsingBlock:^NSArray * _Nonnull(EventTracingVTreeNode * _Nonnull node, BOOL * _Nonnull stop) {
            if (node.view) {
                [self refreshBadgeViewWithNode:node];
            }
            return node.subNodes ?: @[];
        }];
    } else {
        [self removeAllBadgeViews];
    }
}

#pragma mark - EventTracingEventOutputChannel
- (void)eventOutput:(EventTracingEventOutput *)eventOutput didOutputEvent:(NSString *)event json:(NSDictionary *)json {}

- (void)eventOutput:(EventTracingEventOutput *)eventOutput
     didOutputEvent:(NSString *)event
               node:(EventTracingVTreeNode * _Nullable)node
               json:(NSDictionary *)json {
    if (!node || !node.view) {
        return;
    }
    
    ET_DebugToolPushNodeLogRecoard(event, node, json);
    
    [self refreshBadgeViewWithNode:node];
}

#pragma mark - private methods
- (void)_setupWindowIfNeeded {
    self.inspectorWindow = [EventTracingInspect2DWindow new];
    self.inspectorWindow.backgroundColor = [UIColor clearColor];
}

@end

@implementation EventTracingInspectEngine (ExceptionCollector)

- (void)exceptionDidOccuredWithKey:(NSString *)key
                              code:(NSInteger)code
                           content:(NSDictionary *)content {
    if (!self.errorGroupDatas) {
        self.errorGroupDatas = @{}.mutableCopy;
    }
    
    NSString *identifier = EventTracingErrorDataItemIdentifier(key, code, content);
    EventTracingErrorGroupData *groupData = [self.errorGroupDatas objectForKey:identifier];
    if (groupData) {
        [groupData increaseCount];
    } else {
        EventTracingErrorDataItem *dataItem = [[EventTracingErrorDataItem alloc] initWithKey:key code:code content:content];
        groupData = [[EventTracingErrorGroupData alloc] initWithDataItem:dataItem];
        [self.errorGroupDatas setObject:groupData forKey:identifier];
    }
    
    __block NSInteger totalCount = 0;
    [self.errorGroupDatas enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, EventTracingErrorGroupData * _Nonnull obj, BOOL * _Nonnull stop) {
        totalCount += obj.count;
    }];
    [self.inspectorWindow.inspectControlBar updateErrorItemWithCount:totalCount];
}

@end
