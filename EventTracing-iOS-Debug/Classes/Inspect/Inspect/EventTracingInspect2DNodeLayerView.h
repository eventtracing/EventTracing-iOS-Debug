//
//  EventTracingInspect2DNodeLayerView.h
//  EventTracing
//
//  Created by dl on 2021/6/10.
//

#import <Foundation/Foundation.h>
#import <EventTracing/EventTracing.h>

NS_ASSUME_NONNULL_BEGIN

@interface EventTracingInspect2DNodeLayerView : UIView

@property(nonatomic, strong, readonly) EventTracingVTree *VTree;
@property(nonatomic, strong, readonly) EventTracingVTreeNode *highlightNode;

- (void)drawWithVTree:(EventTracingVTree *)VTree highlightNode:(EventTracingVTreeNode *)node;
- (void)clear;

@end

NS_ASSUME_NONNULL_END
