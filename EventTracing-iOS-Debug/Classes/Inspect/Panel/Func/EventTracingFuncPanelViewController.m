//
//  EventTracingFuncPanelViewController.m
//  EventTracingDebug
//
//  Created by jiangxiaofei on 2021/9/9.
//

#import "EventTracingFuncPanelViewController.h"
#import "EventTracingFuncPanelView.h"
#import "EventTracingPanelViewModel.h"
#import "UIView+ETBadge.h"
#import "EventTracingInspectEngine+Private.h"
#import "EventTracingInspectEngine+TwoD.h"
#import "EventTracingContextPanelViewController.h"

#import <EventTracing/EventTracingEngine.h>

@interface EventTracingFuncPanelViewController () <EventTracingFuncPanelViewDelegate>
@property (nonatomic, strong) EventTracingFuncPanelView *panelView;
@property (nonatomic, strong) EventTracingPanelViewModel *viewModel;
@end

@implementation EventTracingFuncPanelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupPanelView:self.panelView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.panelView.switchOn = [EventTracingInspectEngine sharedInstance].inspectUIEnable;
}

#pragma mark - EventTracingFuncPanelViewDelegate
- (void)panelView:(EventTracingFuncPanelView *)panelView onClickShowContextBtn:(id)sender {
    EventTracingContextPanelViewController *contextPanel = [[EventTracingContextPanelViewController alloc] init];
    [contextPanel show:YES onViewController:self];
}

- (void)panelView:(EventTracingFuncPanelView *)panelView oidSwitchDidOn:(BOOL)isOn {
    if (isOn) {
        [[EventTracingInspectEngine sharedInstance] beginInspectUI];
    } else {
        [[EventTracingInspectEngine sharedInstance] endInspectUI];
    }
}

- (void)panelView:(EventTracingFuncPanelView *)panelView onClickCloseButton:(id)sender {
    [self dismiss:YES];
}

- (void)panelView:(EventTracingFuncPanelView *)panelView didSelectedItemAtIndexPath:(NSIndexPath *)indexPath {
    EventTracingPanelDataItem *dataItem = [_viewModel.dataItems objectAtIndex:indexPath.row];
    [[EventTracingInspectEngine sharedInstance] selectedEventIds:dataItem.eventIds name:dataItem.title];
}

- (void)panelView:(EventTracingFuncPanelView *)panelView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    [[EventTracingInspectEngine sharedInstance] selectedEventIds:@[] name:@"埋点调试"];
}

#pragma mark private
- (void)_setupDataItems {
    _viewModel = [EventTracingPanelViewModel new];
    
    [_viewModel addItemTitle:@"点击次数" imageName:@"et_debug_click_pv" eventIds:@[ET_EVENT_ID_E_CLCK] remote:NO];
    [_viewModel addItemTitle:@"曝光次数" imageName:@"et_debug_impress_pv" eventIds:@[ET_EVENT_ID_E_VIEW, ET_EVENT_ID_P_VIEW] remote:NO];
}

#pragma mark - getters
- (EventTracingFuncPanelView *)panelView {
    if (!_panelView) {
        _panelView = [EventTracingFuncPanelView new];
        _panelView.delegate = self;
        
        [self _setupDataItems];
        [_panelView updateWithViewModel:_viewModel];
    }
    return _panelView;
}

@end
