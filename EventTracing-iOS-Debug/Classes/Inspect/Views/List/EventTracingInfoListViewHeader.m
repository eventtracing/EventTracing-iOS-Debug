//
//  EventTracingInfoListViewHeader.m
//  EventTracingDebug
//
//  Created by dl on 2021/11/10.
//

#import "EventTracingInfoListViewHeader.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "UIColor+ETInspect.h"
#import "UIImage+FromBundle.h"

@interface EventTracingInfoListViewHeader ()

@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIButton *unfoldBtn;
@property (nonatomic, strong) UIView *separatorView;

@property (nonatomic, assign) NSInteger section;

@end

@implementation EventTracingInfoListViewHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.numberLabel];
        [self addSubview:self.textLabel];
        [self addSubview:self.unfoldBtn];
        [self addSubview:self.separatorView];
        
        __weak typeof(self) weakSelf = self;
        [self bk_whenTapped:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf unfoldBtnAction:strongSelf.unfoldBtn];
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.numberLabel sizeToFit];
    self.numberLabel.frame = (CGRect){
        (CGPoint){32, (CGRectGetHeight(self.bounds) - CGRectGetHeight(self.numberLabel.bounds)) / 2},
        self.numberLabel.frame.size
    };
    
    CGFloat btnSize = 40;
    self.unfoldBtn.frame = CGRectMake(CGRectGetWidth(self.bounds) - 20 - btnSize,
                                      (CGRectGetHeight(self.bounds) - btnSize) / 2,
                                      btnSize, btnSize);

    CGFloat textLabelLeft = CGRectGetMaxX(self.numberLabel.frame) + 8;
    self.textLabel.frame = CGRectMake(textLabelLeft,
                                      0,
                                      CGRectGetMinX(self.unfoldBtn.frame) - textLabelLeft,
                                      CGRectGetHeight(self.bounds));
    
    CGFloat separatorHeight = 1.0 / UIScreen.mainScreen.scale;
    self.separatorView.frame = CGRectMake(38, CGRectGetHeight(self.bounds) - separatorHeight, CGRectGetWidth(self.bounds) - 54, separatorHeight);
}

- (void)refreshWithSectionData:(EventTracingInfoSectionData *)sectionData
                     serialNum:(NSInteger)serialNum
                       section:(NSInteger)section
                        unfold:(BOOL)unfold {
    if (sectionData.colorString) {
        _textLabel.textColor = [UIColor et_colorWithHexString:sectionData.colorString];
        _numberLabel.textColor = [_textLabel.textColor colorWithAlphaComponent:0.7];
    }
    _numberLabel.text = @(serialNum).stringValue;
    _textLabel.text = sectionData.title;
    _unfoldBtn.selected = unfold;
    _section = section;
    _separatorView.hidden = !unfold;
    
    [self setNeedsLayout];
}

- (void)unfoldBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(listViewHeader:didClickUnFoldSection:unfold:)]) {
        [self.delegate listViewHeader:self didClickUnFoldSection:_section unfold:sender.selected];
    }
}

#pragma mark - Getter

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [UILabel new];
        _numberLabel.font = [UIFont systemFontOfSize:14];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numberLabel;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _textLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _textLabel;
}

- (UIButton *)unfoldBtn {
    if (!_unfoldBtn) {
        _unfoldBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_unfoldBtn setImage:[UIImage et_imageNamed:@"et_debug_unfold"] forState:UIControlStateNormal];
        [_unfoldBtn setImage:[UIImage et_imageNamed:@"et_debug_fold"] forState:UIControlStateSelected];
        [_unfoldBtn addTarget:self action:@selector(unfoldBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _unfoldBtn;
}

- (UIView *)separatorView {
    if (!_separatorView) {
        _separatorView = [UIView new];
        _separatorView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.05];
    }
    return _separatorView;
}

@end
