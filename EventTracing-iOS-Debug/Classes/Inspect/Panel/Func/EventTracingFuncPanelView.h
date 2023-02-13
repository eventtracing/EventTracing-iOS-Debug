//
//  EventTracingFuncPanelView.h
//  EventTracingDebug
//
//  Created by Smallfly on 2021/9/10.
//

#import <UIKit/UIKit.h>
#import "EventTracingPanelViewModel.h"

NS_ASSUME_NONNULL_BEGIN
@class EventTracingFuncPanelView;
@protocol EventTracingFuncPanelViewDelegate <NSObject>

@optional
- (void)panelView:(EventTracingFuncPanelView *)panelView onClickShowContextBtn:(id)sender;
- (void)panelView:(EventTracingFuncPanelView *)panelView oidSwitchDidOn:(BOOL)isOn;
- (void)panelView:(EventTracingFuncPanelView *)panelView onClickCloseButton:(id)sender;

- (void)panelView:(EventTracingFuncPanelView *)panelView didSelectedItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)panelView:(EventTracingFuncPanelView *)panelView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface EventTracingFuncPanelView : UIView

@property (nonatomic, assign) BOOL switchOn;
@property (nonatomic, weak) id<EventTracingFuncPanelViewDelegate> delegate;

- (void)updateWithViewModel:(EventTracingPanelViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
