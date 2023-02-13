//
//  EventTracingInspectControlBar.m
//  EventTracing
//
//  Created by dl on 2021/5/13.
//

#import "EventTracingInspectControlBar.h"
#import <BlocksKit/BlocksKit.h>
#pragma clang diagnostic ignored "-Wincomplete-umbrella"
#import <BlocksKit/UIControl+BlocksKit.h>
#pragma clang diagnostic pop
#import "UIColor+ETInspect.h"

#import "EventTracingInspect2DDefines.h"

CGFloat const barMargin = 16.0;
CGFloat const barHeight = 39.0;

@interface EventTracingInspectControlBar ()

@property (nonatomic, strong) UIVisualEffectView *bgView;
@property (nonatomic, strong) UIView *leftTopDotView;
@property (nonatomic, strong) UIButton *indicatorButton;
@property (nonatomic, strong) UIView *separator;
@property (nonatomic, strong) UIButton *errorButton;
@property (nonatomic, strong) UILabel *errorLabel;

@end

@implementation EventTracingInspectControlBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgView];

        [self addSubview:self.leftTopDotView];
        [self addSubview:self.indicatorButton];
        [self addSubview:self.separator];
        [self addSubview:self.errorButton];

        [self addSubview:self.errorLabel];
        [self.errorLabel sizeToFit];
        
        self.layer.shadowRadius = 16.f;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeZero;
        self.layer.shadowOpacity = 0.4f;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.bgView.frame = self.bounds;
    
    self.leftTopDotView.frame = (CGRect) {
        CGPointMake(4.f, 4.f),
        CGSizeMake(8.f, 8.f)
    };
    
    self.indicatorButton.center = (CGPoint) {
        barMargin + CGRectGetWidth(self.indicatorButton.bounds) / 2.0,
        CGRectGetMidY(self.bounds)
    };
    self.separator.center = (CGPoint) {
        CGRectGetMaxX(self.indicatorButton.frame) + barMargin,
        CGRectGetMidY(self.bounds)
    };
    self.errorButton.center = (CGPoint) {
        CGRectGetWidth(self.bounds) - barMargin - CGRectGetWidth(self.errorButton.bounds) / 2.0,
        CGRectGetMidY(self.bounds)
    };
    
    [self.errorLabel sizeToFit];
    self.errorLabel.frame = CGRectMake(0, 0,
                                       CGRectGetWidth(self.errorLabel.bounds) + 8,
                                       CGRectGetHeight(self.errorLabel.bounds) + 4);
    self.errorLabel.center = (CGPoint) {
        CGRectGetMaxX(self.errorButton.frame),
        CGRectGetMinY(self.errorButton.frame) + CGRectGetHeight(self.errorLabel.bounds) / 2.0
    };
    
    self.errorLabel.layer.cornerRadius = CGRectGetHeight(self.errorLabel.bounds) / 2.0;
}

- (CGSize)sizeThatFits:(CGSize)size {
    [self.indicatorButton sizeToFit];
    [self.errorButton sizeToFit];
    
    CGFloat contentWidth = CGRectGetWidth(self.indicatorButton.bounds) + CGRectGetWidth(self.errorButton.bounds) + barMargin * 4;
    return CGSizeMake(MIN(contentWidth, size.width), barHeight);
}

- (void)updateLeftItemName:(NSString *)itemName highlight:(BOOL)highlight {
    UIFontWeight weight = highlight ? UIFontWeightMedium : UIFontWeightRegular;
    _indicatorButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:weight];
    
    _indicatorButton.selected = highlight;
    [_indicatorButton setTitle:itemName forState:UIControlStateNormal];
    [_indicatorButton setTitle:itemName forState:UIControlStateSelected];
}

- (void)updateErrorItemWithCount:(NSUInteger)count {
    NSString *countText = count > 99 ? @"99+" : @(count).stringValue;
    self.errorLabel.text = countText;
    self.errorLabel.hidden = 0 == count;
    [self.errorLabel sizeToFit];
}

- (void)updateInspectUIStatus:(BOOL)inspectUIEnable {
    _leftTopDotView.backgroundColor = inspectUIEnable ? [UIColor et_colorWithHexString:@"#00B894"] : [UIColor et_colorWithHexString:@"#999999"];
}

#pragma mark - Action

- (void)indicatorButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(controlBar:didClickIndicatorBtn:)]) {
        [self.delegate controlBar:self didClickIndicatorBtn:sender];
    }
}

- (void)errorButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(controlBar:didClickErrorBtn:)]) {
        [self.delegate controlBar:self didClickErrorBtn:sender];
    }
}

#pragma mark - setters & getters

- (UIVisualEffectView *)bgView {
    if (!_bgView) {
        UIVisualEffect *ef = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _bgView = [[UIVisualEffectView alloc] initWithEffect:ef];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 8.f;
        _bgView.backgroundColor = [UIColor et_colorWithHexString:@"#F5F6F7"];
    }
    return _bgView;
}
- (UIView *)leftTopDotView {
    if (!_leftTopDotView) {
        _leftTopDotView = [UIView new];
        _leftTopDotView.backgroundColor = [UIColor et_colorWithHexString:@"#FF3A3A"];
        _leftTopDotView.backgroundColor = [UIColor et_colorWithHexString:@"#999999"];
        _leftTopDotView.layer.cornerRadius = 4.f;
    }
    return _leftTopDotView;
}

- (UIButton *)indicatorButton {
    if (!_indicatorButton) {
        _indicatorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _indicatorButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _indicatorButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_indicatorButton setTitle:@"埋点调试" forState:UIControlStateNormal];
        [_indicatorButton setTitleColor:[UIColor et_colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [_indicatorButton setTitleColor:[UIColor et_colorWithHexString:@"#FF3A3A"] forState:UIControlStateSelected];
        [_indicatorButton addTarget:self action:@selector(indicatorButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _indicatorButton;
}

- (UIButton *)errorButton {
    if (!_errorButton) {
        _errorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _errorButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _errorButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_errorButton setTitle:@"Error" forState:UIControlStateNormal];
        [_errorButton setTitleColor:[UIColor et_colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [_errorButton addTarget:self action:@selector(errorButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _errorButton;
}

- (UILabel *)errorLabel {
    if (!_errorLabel) {
        _errorLabel = [UILabel new];
        _errorLabel.hidden = YES;
        _errorLabel.font = [UIFont systemFontOfSize:10];
        _errorLabel.textAlignment = NSTextAlignmentCenter;
        _errorLabel.textColor = [UIColor whiteColor];
        _errorLabel.backgroundColor = [UIColor et_colorWithHexString:@"#FF3A3A"];
        _errorLabel.layer.cornerRadius = 7;
        _errorLabel.layer.masksToBounds = YES;
    }
    return _errorLabel;
}

- (UIView *)separator {
    if (!_separator) {
        _separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ETinspect2DOnPixel, 15)];
        _separator.backgroundColor = [UIColor colorWithWhite:0 alpha:0.05];
    }
    return _separator;
}

@end
