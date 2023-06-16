//
//  NEEventTracingVTree+DebugTool.m
//  AFNetworking-iOS11.0
//
//  Created by dl on 2021/9/15.
//

#import "NEEventTracingVTree+DebugTool.h"
#import <BlocksKit/BlocksKit.h>

#define LOCK dispatch_semaphore_wait(self.lock, DISPATCH_TIME_FOREVER);
#define UNLOCK dispatch_semaphore_signal(self.lock);

@interface NEEventTracingVTreeNodeLogRecord ()
+ (instancetype)logRecordWithEvent:(NSString *)event
                              node:(NEEventTracingVTreeNode *)node
                           logJson:(NSDictionary<NSString *, NSString *> *)logJson;
@end

@interface NEEventTracingVTreeNodeLogRecordManager : NSObject
@property(nonatomic, strong) NSMutableDictionary<id<NSObject>, NSMutableArray<NEEventTracingVTreeNodeLogRecord *> *> *innerAllLogRecords;
@property(nonatomic, strong) dispatch_semaphore_t lock;

+ (instancetype)sharedInstance;

- (void)pushLogWithEvent:(NSString *)event
                    node:(NEEventTracingVTreeNode *)node
                 logJson:(NSDictionary<NSString *, NSString *> *)logJson;
@end

void NE_ET_DebugToolPushNodeLogRecoard(NSString *event,
                                       NEEventTracingVTreeNode *node,
                                       NSDictionary<NSString *, NSString *> *logJson) {
    [[NEEventTracingVTreeNodeLogRecordManager sharedInstance] pushLogWithEvent:event
                                                                          node:node
                                                                       logJson:logJson];
}

@implementation NEEventTracingVTreeNodeLogRecordManager
+ (instancetype)sharedInstance {
    static NEEventTracingVTreeNodeLogRecordManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [NEEventTracingVTreeNodeLogRecordManager new];
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
                    node:(NEEventTracingVTreeNode *)node
                 logJson:(NSDictionary<NSString *, NSString *> *)logJson {
    LOCK {
        NSMutableArray<NEEventTracingVTreeNodeLogRecord *> *records = [_innerAllLogRecords objectForKey:node.ne_et_diffIdentifier].mutableCopy;
        if (!records) {
            records = @[].mutableCopy;
        }
        [records addObject:[NEEventTracingVTreeNodeLogRecord logRecordWithEvent:event node:node logJson:logJson]];
        id identifier = node.ne_et_diffIdentifier;
        [_innerAllLogRecords setObject:records forKey:identifier];
    } UNLOCK
}

@end

@implementation NEEventTracingVTreeNodeLogRecord
@synthesize oid = _oid;
@synthesize position = _position;
@synthesize spm = _spm;
@synthesize scm = _scm;
@synthesize event = _event;
@synthesize time = _time;
@synthesize logJson = _logJson;

+ (instancetype)logRecordWithEvent:(NSString *)event
                              node:(NEEventTracingVTreeNode *)node
                           logJson:(NSDictionary<NSString *, NSString *> *)logJson {
    NEEventTracingVTreeNodeLogRecord *record = [NEEventTracingVTreeNodeLogRecord new];
    record->_oid = node.oid;
    record->_position = node.position;
    record->_spm = node.spm;
    record->_scm = node.scm;
    record->_event = event;
    record->_logJson = logJson;
    return record;
}

@end

@implementation NEEventTracingVTree (DebugTool)

@end

@implementation NEEventTracingVTreeNode (DebugTool)
- (NSArray<NEEventTracingVTreeNodeLogRecord *> *)allLogRecoards {
    return [[NEEventTracingVTreeNodeLogRecordManager sharedInstance].innerAllLogRecords objectForKey:self.ne_et_diffIdentifier];
}

- (NSArray<NEEventTracingVTreeNodeLogRecord *> *)impressLogRecoards {
    return [self logRecoardsForEvents:@[NE_ET_EVENT_ID_P_VIEW, NE_ET_EVENT_ID_E_VIEW]];
}

- (NSArray<NEEventTracingVTreeNodeLogRecord *> *)impressendLogRecoards {
    return [self logRecoardsForEvents:@[NE_ET_EVENT_ID_P_VIEW_END, NE_ET_EVENT_ID_E_VIEW_END]];
}

- (NSArray<NEEventTracingVTreeNodeLogRecord *> *)clickLogRecoards {
    return [self logRecoardsForEvents:@[NE_ET_EVENT_ID_E_CLCK]];
}

- (NSArray<NEEventTracingVTreeNodeLogRecord *> *)logRecoardsForEvents:(NSArray<NSString *> *)events {
    return [[self allLogRecoards] bk_select:^BOOL(NEEventTracingVTreeNodeLogRecord *obj) {
        return [events containsObject:obj.event];
    }];
}
@end
