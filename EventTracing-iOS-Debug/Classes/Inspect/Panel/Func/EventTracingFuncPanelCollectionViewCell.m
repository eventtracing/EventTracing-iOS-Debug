//
//  EventTracingFuncPanelCollectionViewCell.m
//  EventTracingDebug
//
//  Created by Smallfly on 2021/9/12.
//

#import "EventTracingFuncPanelCollectionViewCell.h"
#import "UIColor+ETInspect.h"
#import "UIImage+FromBundle.h"
#import "EventTracingPanelViewModel.h"

@interface EventTracingFuncPanelCollectionViewCell ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *imageBackgroundView;
@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) EventTracingPanelDataItem *dataItem;
@end

@implementation EventTracingFuncPanelCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [UIImageView new];

        _imageBackgroundView = [UIView new];
        _imageBackgroundView.layer.cornerRadius = 25;
        _imageBackgroundView.layer.masksToBounds = YES;
        _imageBackgroundView.backgroundColor = [UIColor whiteColor];
        [_imageBackgroundView addSubview:_imageView];
        [self.contentView addSubview:_imageBackgroundView];

        _textLabel = [UILabel new];
        _textLabel.font = [UIFont systemFontOfSize:11];
        _textLabel.textColor = [UIColor et_colorWithHex:0x333333];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_textLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _imageBackgroundView.frame = CGRectMake(8, 0, 50, 50);
    _imageView.frame = CGRectMake(0, 0, 32, 32);
    _imageView.center = CGPointMake(25, 25);
    
    [_textLabel sizeToFit];
    _textLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds) - 6);
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    NSString *hexColor = selected ? @"#FF3A3A" : @"#333333";
    _imageView.image = [[UIImage et_imageNamed:_dataItem.imageName] et_imageWithTintColor:[UIColor et_colorWithHexString:hexColor]];
    
    _textLabel.textColor = [UIColor et_colorWithHexString:hexColor];
    
    UIFontWeight weight = selected ? UIFontWeightMedium : UIFontWeightRegular;
    _textLabel.font = [UIFont systemFontOfSize:11.0 weight:weight];
    [_textLabel sizeToFit];
}

- (void)configWithModel:(EventTracingPanelDataItem *)model {
    _textLabel.text = model.title;
    _dataItem = model;
    
    _imageView.image = [[UIImage et_imageNamed:_dataItem.imageName] et_imageWithTintColor:[UIColor et_colorWithHexString:@"#333333"]];
}

@end
