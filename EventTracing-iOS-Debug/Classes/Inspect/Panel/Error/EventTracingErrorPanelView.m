//
//  EventTracingErrorPanelView.m
//  EventTracingDebug
//
//  Created by Smallfly on 2021/9/21.
//

#import "EventTracingErrorPanelView.h"
#import "EventTracingInfoListView.h"
#import "EventTracingPanelCloseView.h"
#import "UIColor+ETInspect.h"

@interface EventTracingErrorPanelView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cpyButton;
@property (nonatomic, strong) EventTracingInfoListView *listView;
@property (nonatomic, strong) EventTracingPanelCloseView *closeView;

@end

@implementation EventTracingErrorPanelView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.cpyButton];
        [self addSubview:self.listView];
        [self addSubview:self.closeButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(16, 0, CGRectGetWidth(self.bounds) / 2, 50);
    
    [self.cpyButton sizeToFit];
    self.cpyButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - 16 - CGRectGetWidth(self.cpyButton.bounds), 0, CGRectGetWidth(self.cpyButton.bounds), 50);
    
    CGFloat bottom = [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
    self.closeView.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - bottom - 40, CGRectGetWidth(self.bounds), 40);
    
    self.listView.frame = CGRectMake(0,
                                     CGRectGetMaxY(self.cpyButton.frame),
                                     CGRectGetWidth(self.bounds),
                                     CGRectGetMinY(self.closeView.frame) - CGRectGetMaxY(self.cpyButton.frame));
    
}

- (void)refreshWithSectionDatas:(NSArray<EventTracingInfoSectionData *> *)sectionDatas {
    [self.listView refreshWithSectionDatas:sectionDatas];
}

#pragma mark - Actions

- (void)cpyButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(errorPanelView:onClickCopyButton:)]) {
        [self.delegate errorPanelView:self onClickCopyButton:sender];
    }
}

#pragma mark - Getters

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"Error";
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor et_colorWithHexString:@"#333333"];
        _titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    }
    return _titleLabel;
}

- (UIButton *)cpyButton {
    if (!_cpyButton) {
        _cpyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cpyButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cpyButton setTitle:@"复制" forState:UIControlStateNormal];
        [_cpyButton setTitleColor:[UIColor et_colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [_cpyButton addTarget:self action:@selector(cpyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cpyButton;
}

- (EventTracingInfoListView *)listView {
    if (!_listView) {
        _listView = [EventTracingInfoListView new];
    }
    return _listView;
}

- (EventTracingPanelCloseView *)closeButton {
    if (!_closeView) {
        _closeView = [EventTracingPanelCloseView new];
        
        __weak typeof(self) weakSelf = self;
        _closeView.closeActionBlock = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if ([strongSelf.delegate respondsToSelector:@selector(errorPanelView:onClickCloseButton:)]) {
                [strongSelf.delegate errorPanelView:strongSelf onClickCloseButton:strongSelf.closeView.closeButton];
            }
        };
    }
    return _closeView;
}

@end
