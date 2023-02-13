//
//  EventTracingVTree+DebugTool.h
//  AFNetworking-iOS11.0
//
//  Created by dl on 2021/9/15.
//

#import <EventTracing/EventTracingVTree.h>
#import <EventTracing/EventTracingVTreeNode.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT void ET_DebugToolPushNodeLogRecoard(NSString *event,
                                                         EventTracingVTreeNode *node,
                                                         NSDictionary<NSString *, NSString *> *logJson);

@interface EventTracingVTreeNodeLogRecord : NSObject

@property(nonatomic, copy, readonly) NSString *oid;
@property(nonatomic, assign, readonly) NSUInteger position;
@property(nonatomic, copy, readonly) NSString *spm;
@property(nonatomic, copy, readonly) NSString *scm;
@property(nonatomic, copy, readonly) NSString *event;

@property(nonatomic, assign, readonly) NSTimeInterval time;
@property(nonatomic, copy, readonly) NSDictionary<NSString *, NSString *> *logJson;

@end

@interface EventTracingVTree (DebugTool)

@end

@interface EventTracingVTreeNode (DebugTool)

- (NSArray<EventTracingVTreeNodeLogRecord *> *)allLogRecoards;
- (NSArray<EventTracingVTreeNodeLogRecord *> *)impressLogRecoards;
- (NSArray<EventTracingVTreeNodeLogRecord *> *)impressendLogRecoards;
- (NSArray<EventTracingVTreeNodeLogRecord *> *)clickLogRecoards;
- (NSArray<EventTracingVTreeNodeLogRecord *> *)logRecoardsForEvents:(NSArray<NSString *> *)events;

@end

NS_ASSUME_NONNULL_END
