//
//  EventTracingInspectControlBar.h
//  EventTracing
//
//  Created by dl on 2021/5/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class EventTracingInspectControlBar;
@protocol EventTracingInspectControlBarDelegate <NSObject>

- (void)controlBar:(EventTracingInspectControlBar *)controlBar didClickIndicatorBtn:(id)sender;
- (void)controlBar:(EventTracingInspectControlBar *)controlBar didClickErrorBtn:(id)sender;

@end

typedef NS_ENUM(NSUInteger, EventTracingInspectControlBarAlign) {
    EventTracingInspectControlBarAlignTopLeft,
    EventTracingInspectControlBarAlignTopRight,
    EventTracingInspectControlBarAlignBottomLeft,
    EventTracingInspectControlBarAlignBottomRight
};

@interface EventTracingInspectControlBar : UIView

@property(nonatomic, weak) id<EventTracingInspectControlBarDelegate> delegate;

- (void)updateLeftItemName:(NSString *)itemName highlight:(BOOL)highlight;
- (void)updateErrorItemWithCount:(NSUInteger)count;
- (void)updateInspectUIStatus:(BOOL)inspectUIEnable;

@end

NS_ASSUME_NONNULL_END
