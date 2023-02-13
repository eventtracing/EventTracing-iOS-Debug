//
//  EventTracingVTree+DebugTool.m
//  AFNetworking-iOS11.0
//
//  Created by dl on 2021/9/15.
//

#import "EventTracingVTree+DebugTool.h"
#import <BlocksKit/BlocksKit.h>

#define LOCK dispatch_semaphore_wait(self.lock, DISPATCH_TIME_FOREVER);
#define UNLOCK dispatch_semaphore_signal(self.lock);

@interface EventTracingVTreeNodeLogRecord ()
+ (instancetype)logRecordWithEvent:(NSString *)event
                              node:(EventTracingVTreeNode *)node
                           logJson:(NSDictionary<NSString *, NSString *> *)logJson;
@end

@interface EventTracingVTreeNodeLogRecordManager : NSObject
@property(nonatomic, strong) NSMutableDictionary<id<NSObject>, NSMutableArray<EventTracingVTreeNodeLogRecord *> *> *innerAllLogRecords;
@property(nonatomic, strong) dispatch_semaphore_t lock;

+ (instancetype)sharedInstance;

- (void)pushLogWithEvent:(NSString *)event
                    node:(EventTracingVTreeNode *)node
                 logJson:(NSDictionary<NSString *, NSString *> *)logJson;
@end

void ET_DebugToolPushNodeLogRecoard(NSString *event,
                                       EventTracingVTreeNode *node,
                                       NSDictionary<NSString *, NSString *> *logJson) {
    [[EventTracingVTreeNodeLogRecordManager sharedInstance] pushLogWithEvent:event
                                                                          node:node
                                                                       logJson:logJson];
}

@implementation EventTracingVTreeNodeLogRecordManager
+ (instancetype)sharedInstance {
    static EventTracingVTreeNodeLogRecordManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [EventTracingVTreeNodeLogRecordManager new];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _innerAllLogRecords = @{}.mutableCopy;
        _lock = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)pushLogWithEvent:(NSString *)event
                    node:(EventTracingVTreeNode *)node
                 logJson:(NSDictionary<NSString *, NSString *> *)logJson {
    LOCK {
        NSMutableArray<EventTracingVTreeNodeLogRecord *> *records = [_innerAllLogRecords objectForKey:node.et_diffIdentifier].mutableCopy;
        if (!records) {
            records = @[].mutableCopy;
        }
        [records addObject:[EventTracingVTreeNodeLogRecord logRecordWithEvent:event node:node logJson:logJson]];
        id identifier = node.et_diffIdentifier;
        [_innerAllLogRecords setObject:records forKey:identifier];
    } UNLOCK
}

@end

@implementation EventTracingVTreeNodeLogRecord
@synthesize oid = _oid;
@synthesize position = _position;
@synthesize spm = _spm;
@synthesize scm = _scm;
@synthesize event = _event;
@synthesize time = _time;
@synthesize logJson = _logJson;

+ (instancetype)logRecordWithEvent:(NSString *)event
                              node:(EventTracingVTreeNode *)node
                           logJson:(NSDictionary<NSString *, NSString *> *)logJson {
    EventTracingVTreeNodeLogRecord *record = [EventTracingVTreeNodeLogRecord new];
    record->_oid = node.oid;
    record->_position = node.position;
    record->_spm = node.spm;
    record->_scm = node.scm;
    record->_event = event;
    record->_logJson = logJson;
    return record;
}

@end

@implementation EventTracingVTree (DebugTool)

@end

@implementation EventTracingVTreeNode (DebugTool)
- (NSArray<EventTracingVTreeNodeLogRecord *> *)allLogRecoards {
    return [[EventTracingVTreeNodeLogRecordManager sharedInstance].innerAllLogRecords objectForKey:self.et_diffIdentifier];
}

- (NSArray<EventTracingVTreeNodeLogRecord *> *)impressLogRecoards {
    return [self logRecoardsForEvents:@[ET_EVENT_ID_P_VIEW, ET_EVENT_ID_E_VIEW]];
}

- (NSArray<EventTracingVTreeNodeLogRecord *> *)impressendLogRecoards {
    return [self logRecoardsForEvents:@[ET_EVENT_ID_P_VIEW_END, ET_EVENT_ID_E_VIEW_END]];
}

- (NSArray<EventTracingVTreeNodeLogRecord *> *)clickLogRecoards {
    return [self logRecoardsForEvents:@[ET_EVENT_ID_E_CLCK]];
}

- (NSArray<EventTracingVTreeNodeLogRecord *> *)logRecoardsForEvents:(NSArray<NSString *> *)events {
    return [[self allLogRecoards] bk_select:^BOOL(EventTracingVTreeNodeLogRecord *obj) {
        return [events containsObject:obj.event];
    }];
}
@end
