//
//  EventTracingInspectNodeInfoPanelView.h
//  EventTracing
//
//  Created by dl on 2021/6/11.
//

#import <UIKit/UIKit.h>
#import <EventTracing/EventTracing.h>

NS_ASSUME_NONNULL_BEGIN

@class EventTracingInspectNodeInfoPanelView;
@protocol EventTracingInspectNodeInfoPanelViewDelegate <NSObject>

- (void)panelView:(EventTracingInspectNodeInfoPanelView *)panelView didClickCloseBtn:(id)sender;

@end

@interface EventTracingInspectNodeInfoPanelView : UIView

@property(nonatomic, weak) id<EventTracingInspectNodeInfoPanelViewDelegate> delegate;

@property(nonatomic, strong, readonly) EventTracingVTreeNode *node;

- (void)refreshWithNode:(EventTracingVTreeNode *)node;

@end

NS_ASSUME_NONNULL_END
