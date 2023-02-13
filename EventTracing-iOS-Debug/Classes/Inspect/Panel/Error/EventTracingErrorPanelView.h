//
//  EventTracingErrorPanelView.h
//  EventTracingDebug
//
//  Created by Smallfly on 2021/9/21.
//

#import <UIKit/UIKit.h>
#import "EventTracingInfoSectionData.h"
#import "EventTracingInfoListView.h"

NS_ASSUME_NONNULL_BEGIN

@class EventTracingErrorPanelView;
@protocol EventTracingErrorPanelViewDelegate <NSObject>

- (void)errorPanelView:(EventTracingErrorPanelView *)panelView onClickCopyButton:(id)sender;
- (void)errorPanelView:(EventTracingErrorPanelView *)panelView onClickCloseButton:(id)sender;

@end

@interface EventTracingErrorPanelView : UIView

@property (nonatomic, strong, readonly) EventTracingInfoListView *listView;

@property (nonatomic, weak) id<EventTracingErrorPanelViewDelegate> delegate;

- (void)refreshWithSectionDatas:(NSArray<EventTracingInfoSectionData *> *)sectionDatas;

@end

NS_ASSUME_NONNULL_END
