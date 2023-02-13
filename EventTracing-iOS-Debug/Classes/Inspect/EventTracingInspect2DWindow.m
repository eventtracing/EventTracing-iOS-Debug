//
//  EventTracingInspect2DWindow.m
//  BlocksKit
//
//  Created by dl on 2021/5/12.
//

#import "EventTracingInspect2DWindow.h"
#import "EventTracing2DContainerViewController.h"
#import "EventTracingInspectEngine+TwoD.h"

NSString * const kEventTracingInspectControlBarPositionKey = @"kEventTracingInspectControlBarPositionKey";
@interface EventTracingInspect2DWindow () <EventTracingInspectControlBarDelegate>
@property(nonatomic, strong) EventTracing2DContainerViewController *viewController;

@property(nonatomic, assign) CGPoint controBarPosition;

@property(nonatomic, assign) CGPoint startPanPoint;
@property(nonatomic, assign) CGPoint controBarDraggingOffset;

@property(nonatomic, strong, readwrite) EventTracingInspectControlBar *inspectControlBar;
@end

@implementation EventTracingInspect2DWindow

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.viewController = [EventTracing2DContainerViewController new];
        self.rootViewController = self.viewController;
 
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self addSubview:self.inspectControlBar];
        });
    }
    return self;
}

- (void)layoutSubviews {
    CGPoint controBarPosition = self.controBarPosition;
    BOOL atLeft = controBarPosition.x < CGRectGetWidth(self.bounds) / 2.f;
    
    if (!CGPointEqualToPoint(self.controBarDraggingOffset, CGPointZero)) {
        controBarPosition.x += self.controBarDraggingOffset.x;
        controBarPosition.y += self.controBarDraggingOffset.y;
    }
    
    CGSize inspectControlBarSize = [self.inspectControlBar sizeThatFits:CGSizeMake(CGRectGetWidth(self.bounds) * 0.8f, CGFLOAT_MAX)];
    CGPoint inspectControlBarOrigin = controBarPosition;
    if (!atLeft) {
        inspectControlBarOrigin = CGPointMake(controBarPosition.x - inspectControlBarSize.width, controBarPosition.y);
    }
    self.inspectControlBar.frame = (CGRect){inspectControlBarOrigin, inspectControlBarSize};

    [super layoutSubviews];
}

#pragma mark - event
- (void)_didPan:(UIPanGestureRecognizer *)pan {
    UIGestureRecognizerState state = pan.state;
    if (state == UIGestureRecognizerStateBegan) {
        self.startPanPoint = [pan locationInView:self];
    }
    else if (state == UIGestureRecognizerStateChanged) {
        CGPoint location = [pan locationInView:self];
        self.controBarDraggingOffset = CGPointMake(location.x - self.startPanPoint.x, location.y - self.startPanPoint.y);
        
        [self setNeedsLayout];
    }
    else {
        CGPoint controBarPosition = self.controBarPosition;
        controBarPosition.y += self.controBarDraggingOffset.y;
        controBarPosition.y = MIN(MAX(controBarPosition.y, 40.f), CGRectGetHeight(self.bounds) - CGRectGetHeight(self.inspectControlBar.bounds) - 40.f);
        
        CGPoint location = [pan locationInView:self];
        CGFloat selfWidth = CGRectGetWidth(self.bounds);
        if (location.x > selfWidth / 2.f) {
            controBarPosition.x = selfWidth;
        } else {
            controBarPosition.x = 0.f;
        }
        
        self.controBarDraggingOffset = CGPointZero;
        
        [[NSUserDefaults standardUserDefaults] setObject:NSStringFromCGPoint(controBarPosition) forKey:kEventTracingInspectControlBarPositionKey];
        
        [UIView animateWithDuration:0.2f animations:^{
            [self setNeedsLayout];
            [self layoutIfNeeded];
        }];
    }
}

#pragma mark - EventTracingInspectControlBarDelegate
- (void)controlBar:(EventTracingInspectControlBar *)controlBar didClickIndicatorBtn:(id)sender {
    [self.viewController showFuncPanel];
}

- (void)controlBar:(EventTracingInspectControlBar *)controlBar didClickErrorBtn:(id)sender {
    [self.viewController showErrorPanel];
}

#pragma mark - getters
- (CGPoint)controBarPosition {
    CGPoint controBarPosition = CGPointMake(0.f, CGRectGetHeight(self.bounds) - 150.f);
    NSString *pointValue = [[NSUserDefaults standardUserDefaults] objectForKey:kEventTracingInspectControlBarPositionKey];
    if (pointValue.length) {
        controBarPosition = CGPointFromString(pointValue);
    }
    return controBarPosition;
}

- (EventTracingInspectControlBar *)inspectControlBar {
    if (!_inspectControlBar) {
        _inspectControlBar = [EventTracingInspectControlBar new];
        _inspectControlBar.delegate = self;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_didPan:)];
        [_inspectControlBar addGestureRecognizer:pan];
    }
    return _inspectControlBar;
}

@end
