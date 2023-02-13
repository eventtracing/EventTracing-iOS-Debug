//
//  EventTracingInspectBadgeView.m
//  EventTracingDebug
//
//  Created by jiangxiaofei on 2021/9/23.
//

#import "EventTracingInspectBadgeView.h"

#define EventTracingInspectBadgeViewHeight 16.0

@implementation EventTracingInspectBadgeView {
    UILabel *_label;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        self.layer.cornerRadius = 8.0;
        self.layer.masksToBounds = YES;
        
        _label = [UILabel new];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:10];
        _label.textColor = [UIColor whiteColor];
        [self addSubview:_label];
    }
    return self;
}

- (void)sizeToFit {
    self.frame = (CGRect) {
        CGPointZero,
        {CGRectGetWidth(_label.bounds) + 12,
            EventTracingInspectBadgeViewHeight}
    };
}

- (void)setCountBadge:(NSUInteger)countBadge {
    _countBadge = countBadge;
    _label.text = @(countBadge).stringValue;
    
    [_label sizeToFit];
    CGRect labelFrame = _label.frame;
    labelFrame.origin = (CGPoint){6, ((EventTracingInspectBadgeViewHeight - CGRectGetHeight(_label.bounds)) / 2)};
    _label.frame = labelFrame;
}

@end
