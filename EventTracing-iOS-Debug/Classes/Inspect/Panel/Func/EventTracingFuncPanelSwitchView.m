//
//  EventTracingFuncPanelSwitchView.m
//  EventTracingDebug
//
//  Created by jiangxiaofei on 2021/9/10.
//

#import "EventTracingFuncPanelSwitchView.h"
#import "UIColor+ETInspect.h"
#import "UIImage+FromBundle.h"

@interface EventTracingFuncPanelSwitchView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation EventTracingFuncPanelSwitchView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 12.0;
        self.layer.masksToBounds = YES;
        
        UIImage *image = [UIImage et_imageNamed:@"et_debug_oid"];
        _imageView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:_imageView];
        
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        _titleLabel.textColor = [UIColor colorWithWhite:0 alpha:0.8];
        _titleLabel.text = @"标识对象";
        [self addSubview:_titleLabel];
        
        _switchControl = [UISwitch new];
        _switchControl.on = NO;
        _switchControl.onTintColor = [UIColor et_colorWithHexString:@"#FF3A3A"];
        [self addSubview:_switchControl];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_imageView sizeToFit];
    _imageView.center = CGPointMake(16 + CGRectGetWidth(_imageView.bounds) / 2, CGRectGetMidY(self.bounds));

    [_titleLabel sizeToFit];
    _titleLabel.center = CGPointMake(12 + CGRectGetMaxX(_imageView.frame) + CGRectGetWidth(_titleLabel.bounds) / 2, CGRectGetMidY(self.bounds));

    [_switchControl sizeToFit];
    _switchControl.center = CGPointMake(CGRectGetWidth(self.bounds) - CGRectGetWidth(_switchControl.bounds) / 2 - 16, CGRectGetMidY(self.bounds));
}

@end
