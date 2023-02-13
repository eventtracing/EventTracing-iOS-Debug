//
//  EventTracingErrorDataItem.h
//  EventTracingDebug
//
//  Created by dl on 2021/11/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *EventTracingErrorDataItemIdentifier(NSString *key, NSInteger code, NSDictionary<NSString *, NSString *> *content);

@class EventTracingErrorDataItem;
@interface EventTracingErrorGroupData : NSObject

@property(nonatomic, copy, readonly) NSString *identifier;
@property(nonatomic, assign, readonly) NSInteger count;
@property(nonatomic, assign, readonly) NSTimeInterval lastUpdatedTime;
@property(nonatomic, strong, readonly) EventTracingErrorDataItem *dataItem;

- (instancetype)initWithDataItem:(EventTracingErrorDataItem *)dataItem;
- (void)increaseCount;

@end

@interface EventTracingErrorDataItem : NSObject

@property(nonatomic, copy, readonly) NSString *identifier;

@property(nonatomic, copy, readonly) NSString *key;
@property(nonatomic, assign, readonly) NSInteger code;
@property(nonatomic, copy, readonly) NSDictionary<NSString *, NSString *> *content;

- (instancetype)initWithKey:(NSString *)key code:(NSInteger)code content:(NSDictionary<NSString *, NSString *> *)content;

@end

NS_ASSUME_NONNULL_END
