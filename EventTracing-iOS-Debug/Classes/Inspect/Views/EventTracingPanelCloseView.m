//
//  EventTracingPanelCloseView.m
//  EventTracingDebug
//
//  Created by Smallfly on 2021/9/21.
//

#import "EventTracingPanelCloseView.h"
#import "UIColor+ETInspect.h"

@interface EventTracingPanelCloseView ()

@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation EventTracingPanelCloseView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.separatorView];
        [self addSubview:self.closeButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // todo
    self.separatorView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 1);
    self.closeButton.frame = CGRectMake(0,
                                        CGRectGetMaxY(self.separatorView.frame),
                                        CGRectGetWidth(self.bounds),
                                        CGRectGetHeight(self.bounds) - CGRectGetHeight(self.separatorView.bounds));
}

- (void)closeAction:(id)sender {
    if (self.closeActionBlock) {
        self.closeActionBlock();
    }
}

- (UIView *)separatorView {
    if (!_separatorView) {
        _separatorView = [UIView new];
        _separatorView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.05];
    }
    return _separatorView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor et_colorWithHex:0x333333] forState:UIControlStateNormal];
        _closeButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _closeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

@end
