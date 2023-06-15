//
//  EventTracingInspect2DNodeLayerView.h
//  EventTracing
//
//  Created by dl on 2021/6/10.
//

#import <Foundation/Foundation.h>
#import <EventTracing/NEEventTracing.h>

NS_ASSUME_NONNULL_BEGIN

@interface EventTracingInspect2DNodeLayerView : UIView

@property(nonatomic, strong, readonly) NEEventTracingVTree *VTree;
@property(nonatomic, strong, readonly) NEEventTracingVTreeNode *highlightNode;

- (void)drawWithVTree:(NEEventTracingVTree *)VTree highlightNode:(NEEventTracingVTreeNode *)node;
- (void)clear;

@end

NS_ASSUME_NONNULL_END
