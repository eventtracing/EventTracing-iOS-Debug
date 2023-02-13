//
//  EventTracingInspectEngineInternal.h
//  Pods
//
//  Created by jiangxiaofei on 2021/9/28.
//


#import "EventTracingInspectEngine.h"
#import "EventTracingInspect2DWindow.h"
#import "EventTracingInfoSectionData.h"
#import "EventTracingErrorDataItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface EventTracingInspectEngine ()

/// 标识对象开关
@property (nonatomic, assign, getter=isInspectUIEnable) BOOL inspectUIEnable;

@property(nonatomic, weak, nullable) UIWindow *previousKeyWindow;
@property(nonatomic, strong, nullable) EventTracingInspect2DWindow *inspectorWindow;

@property (nonatomic, copy) NSString *eventName;
@property (nonatomic, copy) NSArray<NSString *> *eventIds;

@property(nonatomic, strong) NSMutableDictionary<NSString *, EventTracingErrorGroupData *> *errorGroupDatas;

- (void)selectedEventIds:(NSArray<NSString *> *)eventIds name:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
