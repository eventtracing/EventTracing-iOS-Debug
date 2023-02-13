//
//  EventTracing2DContainerViewController.m
//  EventTracingDebug
//
//  Created by jiangxiaofei on 2021/9/14.
//

#import "EventTracing2DContainerViewController.h"
#import "EventTracingBasePanelViewController.h"
#import "EventTracingInspectEngine+TwoD.h"
#import "EventTracingFuncPanelViewController.h"
#import "EventTracingErrorPanelViewController.h"

#import "EventTracingInfoSectionData.h"

@interface EventTracing2DContainerViewController ()
@property (nonatomic, strong, readwrite) EventTracingInspect2DViewController *inspectViewController;

@property (nonatomic, strong) EventTracingFuncPanelViewController *panelViewController;
@property (nonatomic, strong) EventTracingErrorPanelViewController *errorPanelViewController;
@end

@implementation EventTracing2DContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addChildViewController:self.inspectViewController];
    [self.view addSubview:self.inspectViewController.view];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.inspectViewController.view.frame = self.view.bounds;
}

- (void)showFuncPanel {
    [[EventTracingInspectEngine sharedInstance] inspectWindowBecomeKeyWindow];
    [self.panelViewController show:YES];
}

- (void)showErrorPanel {
    [[EventTracingInspectEngine sharedInstance] inspectWindowBecomeKeyWindow];
    [self.errorPanelViewController show:YES];
}

- (void)dismissPanel {
    [self.panelViewController dismiss:YES];
    [self.errorPanelViewController dismiss:YES];
}

#pragma mark - getters
- (EventTracingInspect2DViewController *)inspectViewController {
    if (!_inspectViewController) {
        _inspectViewController = EventTracingInspect2DViewController.new;
    }
    return _inspectViewController;
}

- (EventTracingFuncPanelViewController *)panelViewController {
    if (!_panelViewController) {
        _panelViewController = [EventTracingFuncPanelViewController new];
    }
    return _panelViewController;
}

- (EventTracingErrorPanelViewController *)errorPanelViewController {
    if (!_errorPanelViewController) {
        _errorPanelViewController = [EventTracingErrorPanelViewController new];
    }
    return _errorPanelViewController;
}

@end
