//
//  EventTracingInspectNodeInfoUtil.h
//  EventTracingDebug
//
//  Created by dl on 2021/11/11.
//

#import <Foundation/Foundation.h>
#import "EventTracingInfoSectionData.h"
#import <EventTracing/NEEventTracingVTreeNode.h>
#import <EventTracing/NEEventTracingVTree.h>

NS_ASSUME_NONNULL_BEGIN

@interface EventTracingInspectNodeInfoUtil : NSObject

+ (EventTracingInfoSectionData *)sectionDataFromNode:(NEEventTracingVTreeNode *)node;
+ (NSArray<EventTracingInfoSectionData *> *)recursionSectionDataFromNode:(NEEventTracingVTreeNode *)node;

@end

NS_ASSUME_NONNULL_END
