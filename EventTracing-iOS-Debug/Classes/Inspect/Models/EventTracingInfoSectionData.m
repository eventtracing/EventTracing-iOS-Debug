//
//  EventTracingInfoSectionData.m
//  EventTracingDebug
//
//  Created by jiangxiaofei on 2021/9/18.
//

#import "EventTracingInfoSectionData.h"

@implementation EventTracingInfoSectionData

- (instancetype)initWithTitle:(NSString *)title items:(NSArray<EventTracingInfoDataItem *> *)items {
    self = [self init];
    if (self) {
        _title = title;
        _items = items;
        
        [items enumerateObjectsUsingBlock:^(EventTracingInfoDataItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.sectionData = self;
        }];
    }
    return self;
}

- (NSString *)JSONString {
    NSMutableDictionary *json = @{}.mutableCopy;
    if (self.title) {
        [json setObject:self.title forKey:@"title"];
    }
    
    [self.items enumerateObjectsUsingBlock:^(EventTracingInfoDataItem  * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.key && obj.value) {
            [json setObject:obj.value forKey:obj.key];
        }
    }];
    
    NSError *err;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:&err];
    if (err) {
        NSLog(@"JSONSerialization error: %@", err);
        return nil;
    }
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
