//
//  EventTracingBasePanelViewController.h
//  AFNetworking
//
//  Created by dl on 2021/9/27.
//

#import <UIKit/UIKit.h>
#import "EventTracing2DContainerViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface EventTracingBasePanelViewController : UIViewController

- (void)show:(BOOL)animated;
- (void)show:(BOOL)animated onViewController:(UIViewController * _Nullable)viewController;
- (void)dismiss:(BOOL)animated;

// needs overwrite
- (CGFloat)pannelViewHeight;

- (void)setupPanelView:(UIView *)panelView;

@end

NS_ASSUME_NONNULL_END
