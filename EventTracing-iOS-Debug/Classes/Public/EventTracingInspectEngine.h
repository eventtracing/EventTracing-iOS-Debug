//
//  EventTracingInspectEngine.h
//  BlocksKit
//
//  Created by dl on 2021/5/12.
//

#import <Foundation/Foundation.h>
#import <EventTracing/NEEventTracing.h>

NS_ASSUME_NONNULL_BEGIN

@interface EventTracingInspectEngine : NSObject <NEEventTracingEventOutputChannel>

@property(nonatomic, assign, readonly, getter=isInspecting) BOOL inspecting;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
+ (instancetype)sharedInstance;

- (void)startInspect2D;

- (void)stop;

@end

@interface EventTracingInspectEngine (ExceptionCollector)
- (void)exceptionDidOccuredWithKey:(NSString *)key
                              code:(NSInteger)code
                           content:(NSDictionary *)content;
@end

NS_ASSUME_NONNULL_END
