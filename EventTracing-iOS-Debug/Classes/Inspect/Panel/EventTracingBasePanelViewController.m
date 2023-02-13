//
//  EventTracingBasePanelViewController.m
//  AFNetworking
//
//  Created by dl on 2021/9/27.
//

#import "EventTracingBasePanelViewController.h"
#import <BlocksKit/UIView+BlocksKit.h>
#import <BlocksKit/BlocksKit.h>
#import <Masonry/Masonry.h>
#import "EventTracingInspectEngine+Private.h"
#import "EventTracingInspectEngine+TwoD.h"
#import "UIColor+ETInspect.h"

typedef NS_ENUM(NSInteger, EventTracingPanelAppearance) {
    EventTracingPanelAppearanceNone,
    EventTracingPanelAppearanceWillAppear,
    EventTracingPanelAppearanceDidAppear,
    EventTracingPanelAppearanceWillDisappear,
    EventTracingPanelAppearanceDidDisappear
};

static NSHashTable<EventTracingBasePanelViewController *> *showingPanels;

@interface EventTracingBasePanelViewController ()
@property (nonatomic, strong) UIView *exitBgView;
@property (nonatomic, strong) UIView *panelContainerView;

@property (nonatomic, assign) EventTracingPanelAppearance panelAppearance;
@end

@implementation EventTracingBasePanelViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        _panelAppearance = EventTracingPanelAppearanceNone;
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            showingPanels = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
        });
        
        [showingPanels addObject:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.panelContainerView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.exitBgView];
    [self.view addSubview:self.panelContainerView];
    
    self.exitBgView.alpha = 0.f;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat panelViewHeight = [self pannelViewHeight];
    CGFloat selfViewHeight = self.view.bounds.size.height;
    self.exitBgView.frame = self.view.bounds;
    
    if (self.panelAppearance != EventTracingPanelAppearanceWillAppear
        && self.panelAppearance != EventTracingPanelAppearanceWillDisappear) {
        return;
    }
    
    BOOL willShow = self.panelAppearance == EventTracingPanelAppearanceWillAppear;
    if (willShow) {
        self.exitBgView.alpha = 0.f;
        self.panelContainerView.frame = CGRectMake(0.f, selfViewHeight, self.view.bounds.size.width, panelViewHeight);
    }
    
    [UIView animateWithDuration:.2f animations:^{
        self.exitBgView.alpha = willShow ? 1.f : 0.f;
        
        CGFloat panelViewTop = selfViewHeight - (willShow ? panelViewHeight : 0);
        self.panelContainerView.frame = CGRectMake(0.f, panelViewTop, self.view.bounds.size.width, panelViewHeight);
    } completion:^(BOOL finished) {
        [self _doAppearanceDidUpdated];
    }];
}

- (void) _doAppearanceDidUpdated {
    if (self.panelAppearance == EventTracingPanelAppearanceWillAppear) {
        self.panelAppearance = EventTracingPanelAppearanceDidAppear;
    }
    
    if (self.panelAppearance == EventTracingPanelAppearanceWillDisappear) {
        self.panelAppearance = EventTracingPanelAppearanceDidDisappear;
        
        [self dismissViewControllerAnimated:NO completion:^{
            BOOL hasShowingPanel = [showingPanels.allObjects bk_select:^BOOL(EventTracingBasePanelViewController *obj) {
                return obj.panelAppearance != EventTracingPanelAppearanceDidDisappear && obj.panelAppearance != EventTracingPanelAppearanceNone;
            }].count > 0;
            if (!hasShowingPanel && ![EventTracingInspectEngine sharedInstance].isInspectUIEnable) {
                [[EventTracingInspectEngine sharedInstance] inspectWindowResignKeyWindow];
            }
        }];
    }
}

#pragma mark - public
- (void)show:(BOOL)animated {
    [self show:animated onViewController:nil];
}

- (void)show:(BOOL)animated onViewController:(UIViewController * _Nullable)viewController {
    UIViewController *baseViewController = viewController ?: [EventTracingInspectEngine sharedInstance].inspectorWindow.rootViewController;
    
    if (baseViewController.presentedViewController) {
        return;
    }
    
    if (self.panelAppearance != EventTracingPanelAppearanceNone && self.panelAppearance != EventTracingPanelAppearanceDidDisappear) {
        return;
    }
    
    [[EventTracingInspectEngine sharedInstance] inspectWindowBecomeKeyWindow];
    [baseViewController presentViewController:self animated:NO completion:nil];
    
    self.panelAppearance = EventTracingPanelAppearanceWillAppear;
    [self.view setNeedsLayout];
}

- (void)dismiss:(BOOL)animated {
    self.panelAppearance = EventTracingPanelAppearanceWillDisappear;
    [self.view setNeedsLayout];
}

- (CGFloat)pannelViewHeight {
    return 0.6f * self.view.bounds.size.height;
}

- (void)setupPanelView:(UIView *)panelView {
    panelView.backgroundColor = [UIColor et_colorWithHex:0xF5F6F7];
    panelView.layer.cornerRadius = 25;
    panelView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    
    [self.panelContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.panelContainerView addSubview:panelView];
    [panelView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.width.height.equalTo(self.panelContainerView);
    }];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

#pragma mark - getters
- (UIView *)exitBgView {
    if (!_exitBgView) {
        _exitBgView = [[UIView alloc] init];
        _exitBgView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.3f];
        __weak typeof(self) __weakSelf = self;
        [_exitBgView bk_whenTapped:^{
            __strong typeof(__weakSelf) __strongSelf = __weakSelf;
            [__strongSelf dismiss:YES];
        }];
    }
    return _exitBgView;
}

@end
