//
//  NEEventTracingVTree+DebugTool.h
//  AFNetworking-iOS11.0
//
//  Created by dl on 2021/9/15.
//

#import <EventTracing/NEEventTracingVTree.h>
#import <EventTracing/NEEventTracingVTreeNode.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT void NE_ET_DebugToolPushNodeLogRecoard(NSString *event,
                                                         NEEventTracingVTreeNode *node,
                                                         NSDictionary<NSString *, NSString *> *logJson);

@interface NEEventTracingVTreeNodeLogRecord : NSObject

@property(nonatomic, copy, readonly) NSString *oid;
@property(nonatomic, assign, readonly) NSUInteger position;
@property(nonatomic, copy, readonly) NSString *spm;
@property(nonatomic, copy, readonly) NSString *scm;
@property(nonatomic, copy, readonly) NSString *event;

@property(nonatomic, assign, readonly) NSTimeInterval time;
@property(nonatomic, copy, readonly) NSDictionary<NSString *, NSString *> *logJson;

@end

@interface NEEventTracingVTree (DebugTool)

@end

@interface NEEventTracingVTreeNode (DebugTool)

- (NSArray<NEEventTracingVTreeNodeLogRecord *> *)allLogRecoards;
- (NSArray<NEEventTracingVTreeNodeLogRecord *> *)impressLogRecoards;
- (NSArray<NEEventTracingVTreeNodeLogRecord *> *)impressendLogRecoards;
- (NSArray<NEEventTracingVTreeNodeLogRecord *> *)clickLogRecoards;
- (NSArray<NEEventTracingVTreeNodeLogRecord *> *)logRecoardsForEvents:(NSArray<NSString *> *)events;

@end

NS_ASSUME_NONNULL_END
