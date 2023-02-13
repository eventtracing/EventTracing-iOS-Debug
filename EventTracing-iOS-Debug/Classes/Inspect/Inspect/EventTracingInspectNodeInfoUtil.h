//
//  EventTracingInspectNodeInfoUtil.h
//  EventTracingDebug
//
//  Created by dl on 2021/11/11.
//

#import <Foundation/Foundation.h>
#import "EventTracingInfoSectionData.h"
#import <EventTracing/EventTracingVTreeNode.h>
#import <EventTracing/EventTracingVTree.h>

NS_ASSUME_NONNULL_BEGIN

@interface EventTracingInspectNodeInfoUtil : NSObject

+ (EventTracingInfoSectionData *)sectionDataFromNode:(EventTracingVTreeNode *)node;
+ (NSArray<EventTracingInfoSectionData *> *)recursionSectionDataFromNode:(EventTracingVTreeNode *)node;

@end

NS_ASSUME_NONNULL_END
