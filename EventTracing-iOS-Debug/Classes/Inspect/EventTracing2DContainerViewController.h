//
//  EventTracing2DContainerViewController.h
//  EventTracingDebug
//
//  Created by jiangxiaofei on 2021/9/14.
//

#import <UIKit/UIKit.h>
#import "EventTracingInspect2DViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface EventTracing2DContainerViewController : UIViewController

@property (nonatomic, strong, readonly) EventTracingInspect2DViewController *inspectViewController;

- (void)showFuncPanel;
- (void)showErrorPanel;
- (void)dismissPanel;

@end

NS_ASSUME_NONNULL_END
