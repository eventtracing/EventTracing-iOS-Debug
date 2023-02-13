//
//  EventTracingInspectNodeInfoPanelView.m
//  EventTracing
//
//  Created by dl on 2021/6/11.
//

#import "EventTracingInspectNodeInfoPanelView.h"
#import <BlocksKit/BlocksKit.h>
#import <Masonry/Masonry.h>
#import "UIColor+ETInspect.h"
#import "UIImage+FromBundle.h"
#import "EventTracingInfoListView.h"
#import "EventTracingInspectNodeInfoUtil.h"

@interface EventTracingInspectNodeInfoPanelView (){
    CGFloat _panelContentsMarginTop;
    CGFloat _panelInsetTop;
    CGFloat _panelInsetBottom;
}
@property(nonatomic, strong, readwrite) EventTracingVTreeNode *node;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, strong) UIButton *cpyButton;
@property (nonatomic, strong) EventTracingInfoListView *listView;

@property (nonatomic, copy) NSArray<EventTracingInfoSectionData *> *sectionDatas;

@end

@implementation EventTracingInspectNodeInfoPanelView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 8;
        self.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.15].CGColor;
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowOffset = CGSizeMake(3, 3);

        _listView = [EventTracingInfoListView new];
        [self addSubview:self.listView];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.closeButton];
        [self addSubview:self.separatorView];
        [self addSubview:self.cpyButton];
    }
    return self;
}

- (void)refreshWithNode:(EventTracingVTreeNode *)node {
    self.node = node;

    NSArray *sectionDatas = [EventTracingInspectNodeInfoUtil recursionSectionDataFromNode:node];
    [self.listView refreshWithSectionDatas:sectionDatas];
    self.sectionDatas = sectionDatas.copy;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.closeButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - 50.f, 0.f, 50.f, 50.f);
    self.titleLabel.frame = (CGRect){ (CGPoint){16, 0.f}, CGSizeMake(self.bounds.size.width - 2.f * 16.f - 50.f, 50.f) };
    
    self.separatorView.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - 50, CGRectGetWidth(self.bounds), 1.0 / UIScreen.mainScreen.scale);
    self.listView.frame = CGRectMake(0.f,
                                     CGRectGetMaxY(self.titleLabel.frame),
                                     CGRectGetWidth(self.bounds),
                                     CGRectGetMinY(self.separatorView.frame) - CGRectGetMaxY(self.titleLabel.frame));
    self.cpyButton.frame = CGRectMake(0, CGRectGetMaxY(self.separatorView.frame), CGRectGetWidth(self.bounds), 50 - CGRectGetHeight(self.separatorView.bounds));
}

#pragma mark - Actions

- (void)closeButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(panelView:didClickCloseBtn:)]) {
        [self.delegate panelView:self didClickCloseBtn:sender];
    }
}

// 复制当前选中节点埋点信息
- (void)cpyButtonAction {
    if (self.listView.selectedIndex < self.sectionDatas.count) {
        EventTracingInfoSectionData *selectedItem = [self.sectionDatas objectAtIndex:_listView.selectedIndex];
        NSString *jsonString = selectedItem.JSONString;
        if (!jsonString) {
            return;
        }
        
        [UIPasteboard generalPasteboard].string = jsonString;
    }
}

#pragma mark - getters

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor et_colorWithHexString:@"#333333"];
        _titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        _titleLabel.text = @"对象链路";
    }
    return _titleLabel;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage et_imageNamed:@"et_debug_close"]];
        icon.backgroundColor = [UIColor colorWithWhite:0 alpha:0.05];
        icon.layer.cornerRadius = 9;
        icon.layer.masksToBounds = YES;
        
        [_closeButton addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(_closeButton);
            make.size.mas_equalTo(CGSizeMake(18.f, 18.f));
        }];
    }
    return _closeButton;
}

- (UIButton *)cpyButton {
    if (!_cpyButton) {
        _cpyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cpyButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 6);
        _cpyButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cpyButton setTitle:@"复制" forState:UIControlStateNormal];
        [_cpyButton setTitleColor:[UIColor et_colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [_cpyButton setImage:[UIImage et_imageNamed:@"et_debug_copy"] forState:UIControlStateNormal];
        [_cpyButton addTarget:self action:@selector(cpyButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cpyButton;
}

- (UIView *)separatorView {
    if (!_separatorView) {
        _separatorView = [UIView new];
        _separatorView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.05];
    }
    return _separatorView;
}

@end
