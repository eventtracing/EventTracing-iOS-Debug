//
//  EventTracingErrorDataItem.m
//  EventTracingDebug
//
//  Created by dl on 2021/11/11.
//

#import "EventTracingErrorDataItem.h"

NSString *EventTracingErrorDataItemIdentifier(NSString *key, NSInteger code, NSDictionary<NSString *, NSString *> *content) {
    NSMutableString *identifier = @"Section".mutableCopy;
    [identifier appendFormat:@"[%@(%@)] => ", key, @(code).stringValue];
    [identifier appendString:@"items: ["];
    [[content.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            return [obj1 compare:obj2];
    }] enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            [identifier appendString:@", "];
        }
        [identifier appendFormat:@"%@: %@", key, content[key]];
    }];
    [identifier appendString:@"]"];
    
    return identifier;
}

@implementation EventTracingErrorGroupData

- (instancetype)initWithDataItem:(EventTracingErrorDataItem *)dataItem {
    self = [self init];
    if (self) {
        _dataItem = dataItem;
        [self increaseCount];
    }
    return self;
}

- (void)increaseCount {
    _count ++;
    _lastUpdatedTime = [NSDate date].timeIntervalSince1970;
}

- (NSString *)identifier {
    return self.dataItem.identifier;
}

@end

@implementation EventTracingErrorDataItem

- (instancetype)initWithKey:(NSString *)key code:(NSInteger)code content:(NSDictionary<NSString *, NSString *> *)content {
    self = [self init];
    if (self) {
        _key = key;
        _code = code;
        _content = content.copy;
    }
    return self;
}

- (NSString *)identifier {
    return EventTracingErrorDataItemIdentifier(self.key, self.code, self.content);
}

@end
