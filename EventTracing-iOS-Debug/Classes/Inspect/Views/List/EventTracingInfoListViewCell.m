//
//  EventTracingInfoListViewCell.m
//  EventTracingDebug
//
//  Created by jiangxiaofei on 2021/9/18.
//

#import "EventTracingInfoListViewCell.h"
#import "UIColor+ETInspect.h"
#import "EventTracingInfoSectionData.h"
#import "EventTracingInfoListViewLayout.h"
#import <BlocksKit/BlocksKit+UIKit.h>

@implementation EventTracingInfoListViewDecorationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 8.0;
        self.backgroundColor = [UIColor et_colorWithHexString:@"#FF5B5B" alpha:0.1];
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    if ([layoutAttributes isKindOfClass:[EventTracingInfoListViewLayoutAttributes class]]) {
        EventTracingInfoListViewLayoutAttributes *attri = (EventTracingInfoListViewLayoutAttributes *)layoutAttributes;
        self.backgroundColor = [UIColor et_colorWithHexString:attri.backgroundHexColor alpha:0.1];
    }
}

@end


@interface EventTracingInfoListViewCell ()

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation EventTracingInfoListViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.textLabel];
        self.contentView.clipsToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize labelSize = [self.textLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.bounds), CGFLOAT_MAX)];
    self.textLabel.frame = (CGRect){ CGPointZero, labelSize };
}

- (void)refreshWithDataItem:(EventTracingInfoDataItem *)dataItem {
    
    NSString *colorString = dataItem.colorString ?: dataItem.sectionData.colorString;
    self.textLabel.textColor = colorString ? [UIColor et_colorWithHexString:colorString] : [UIColor et_colorWithHexString:@"#333333"];
    self.textLabel.text = dataItem.description;
    if (dataItem.fontItalic) {
        self.textLabel.font = [UIFont italicSystemFontOfSize:14];
    } else {
        self.textLabel.font = [UIFont systemFontOfSize:14 weight:dataItem.fontWeight];
    }
    
    self.textLabel.alpha = dataItem.alpha;
    
    [self setNeedsLayout];
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.numberOfLines = 0;
        _textLabel.textColor = [UIColor et_colorWithHexString:@"#333333"];
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _textLabel;
}

@end
