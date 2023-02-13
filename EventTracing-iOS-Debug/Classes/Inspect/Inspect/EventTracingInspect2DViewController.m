//
//  EventTracingInspect2DViewController.m
//  EventTracing
//
//  Created by dl on 2021/5/12.
//

#import "EventTracingInspect2DViewController.h"
#import "CALayer+ETInspect.h"
#import <BlocksKit/BlocksKit.h>
#import "EventTracingInspect2DNodeLayerView.h"
#import "EventTracingInspectNodeInfoPanelView.h"
#import "EventTracingInspectEngine+TwoD.h"

#import <EventTracing/EventTracing.h>

#pragma clang diagnostic ignored "-Wincomplete-umbrella"
#import <EventTracing/NSArray+ETEnumerator.h>
#import <BlocksKit/UIControl+BlocksKit.h>
#pragma clang diagnostic pop

@interface EventTracingInspect2DViewController () <EventTracingInspectNodeInfoPanelViewDelegate>
@property(nonatomic, strong) EventTracingInspect2DNodeLayerView *nodeLayerView;

@property(nonatomic, strong) UIView *panelBgView;
@property(nonatomic, strong) EventTracingInspectNodeInfoPanelView *nodeInfoPanelView;
@end

@implementation EventTracingInspect2DViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.nodeLayerView];
    [self.view addSubview:self.panelBgView];
    [self.view addSubview:self.nodeInfoPanelView];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleTapRecognizer:)];
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.nodeLayerView.frame = self.view.bounds;
    self.panelBgView.frame = self.view.bounds;
    [self _layoutPanelView];
}

#pragma mark - public
- (void)clearInspectUI {
    [self closePannelView];
    [self.nodeLayerView clear];
}

- (void)closePannelView {
    self.panelBgView.hidden = YES;
    self.nodeInfoPanelView.hidden = YES;
}

- (void)showPannelView {
    self.panelBgView.hidden = NO;
    self.nodeInfoPanelView.hidden = NO;
}

#pragma mark - private
- (void)_layoutPanelView {
    CGRect contentRect = self.nodeInfoPanelView.node.visibleRect;
    if (CGRectEqualToRect(contentRect, CGRectNull)) {
        self.nodeInfoPanelView.frame = CGRectZero;
        return;
    }
    
    CGSize containerSize = self.view.bounds.size;
    CGFloat screenInset = 10;
    
    CGSize panelSize = CGSizeMake(containerSize.width - 2.f * screenInset, containerSize.height * 0.5);
    CGFloat panelMargin = 10;
    
    CGFloat panelY = ({
        CGFloat y = 0;
        
        CGFloat panelMinY = screenInset;
        if (@available(iOS 11.0, *)) {
            panelMinY = self.view.safeAreaInsets.top;
        }
        
        CGFloat panelMinBottomNeeded = screenInset;
        if (@available(iOS 11.0, *)) {
            panelMinBottomNeeded = self.view.safeAreaInsets.bottom;
        }
        panelMinBottomNeeded += panelSize.height;
        
        if (contentRect.origin.y - panelSize.height >= panelMinY) {
            // 放到目标上方
            y = contentRect.origin.y - panelMargin - panelSize.height;
        } else {
            CGFloat targetBottom = containerSize.height - CGRectGetMaxY(contentRect);
            if (targetBottom > panelMinBottomNeeded) {
                // 放到目标下方
                y = CGRectGetMaxY(contentRect) + panelMargin;
            } else {
                // 放到目标内部的上方
                y = contentRect.origin.y + panelMargin;
                if (@available(iOS 11.0, *)) {
                    y = MAX(y, self.view.safeAreaInsets.top);
                }
            }
        }
        
        y;
    });
    
    CGFloat panelX = ({
        CGFloat x = 0;
        // 先尝试和目标居中
        x = CGRectGetMidX(contentRect) - panelSize.width / 2.0;
        if (x <= 0) {
            // 如果超出了左边屏幕，则挪到距离屏幕左边
            x = screenInset;
        } else if (x + panelSize.width > containerSize.width) {
            // 如果超出了右边屏幕，则挪到距离屏幕右边 labelMargin 的距离
            x = containerSize.width - screenInset - panelSize.width;
        }
        x;
    });
    self.nodeInfoPanelView.frame = CGRectMake(panelX, panelY, panelSize.width, panelSize.height);
}

#pragma mark - event
- (void)_handleTapRecognizer:(UITapGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self.view];
    EventTracingVTreeNode *node = [[EventTracingEngine sharedInstance].context.currentVTree hitTest:point];
    EventTracingVTree *VTree = node.VTree;
    
    if (!node || !VTree) {
        [self clearInspectUI];
        return;
    }
    
    [self _doShowInspectWithNode:node inVTree:VTree];
}

- (void)_doShowInspectWithNode:(EventTracingVTreeNode *)node inVTree:(EventTracingVTree *)VTree {
    [self showPannelView];
    [self.nodeLayerView drawWithVTree:VTree highlightNode:node];
    [self.nodeInfoPanelView refreshWithNode:node];
    
    [self.view setNeedsLayout];
}

#pragma mark - EventTracingInspectNodeInfoPanelViewDelegate
- (void)panelView:(EventTracingInspectNodeInfoPanelView *)panelView didClickCloseBtn:(id)sender {
    [self closePannelView];
}

#pragma mark - getters
- (EventTracingInspect2DNodeLayerView *)nodeLayerView {
    if (!_nodeLayerView) {
        _nodeLayerView = [[EventTracingInspect2DNodeLayerView alloc] init];
        _nodeLayerView.userInteractionEnabled = NO;
    }
    return _nodeLayerView;
}
- (UIView *)panelBgView {
    if (!_panelBgView) {
        _panelBgView = [UIView new];
        _panelBgView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.16f];
        _panelBgView.hidden = YES;
    }
    return _panelBgView;
}
- (EventTracingInspectNodeInfoPanelView *)nodeInfoPanelView {
    if (!_nodeInfoPanelView) {
        _nodeInfoPanelView = [[EventTracingInspectNodeInfoPanelView alloc] init];
        _nodeInfoPanelView.hidden = YES;
        _nodeInfoPanelView.delegate = self;
    }
    return _nodeInfoPanelView;
}

@end
