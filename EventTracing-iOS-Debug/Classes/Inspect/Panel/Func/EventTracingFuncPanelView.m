//
//  EventTracingFuncPanelView.m
//  EventTracingDebug
//
//  Created by Smallfly on 2021/9/10.
//

#import "EventTracingFuncPanelView.h"
#import "EventTracingFuncPanelSwitchView.h"
#import "EventTracingFuncPanelCollectionViewCell.h"
#import "EventTracingPanelViewModel.h"
#import "EventTracingPanelCloseView.h"

#import "UIColor+ETInspect.h"

@interface EventTracingFuncPanelView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UILabel *funcTitle;
@property (nonatomic, strong) UIButton *showContextBtn;

@property (nonatomic, strong) EventTracingFuncPanelSwitchView *oidSwitchView;

@property (nonatomic, strong) UIButton *localDataButton;
@property (nonatomic, strong) UIButton *remoteDataButton;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) EventTracingPanelCloseView *closeView;

@property (nonatomic, strong) EventTracingPanelViewModel *viewModel;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation EventTracingFuncPanelView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.funcTitle];
        [self addSubview:self.showContextBtn];
        [self addSubview:self.oidSwitchView];
        [self addSubview:self.localDataButton];
        [self addSubview:self.remoteDataButton];
        [self addSubview:self.collectionView];
        [self addSubview:self.closeView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat padding = 16;
    self.funcTitle.frame = CGRectMake(padding, 18, 80, 16);
    self.showContextBtn.frame = CGRectMake(CGRectGetWidth(self.bounds) - CGRectGetWidth(self.showContextBtn.frame) - padding, 0.f, CGRectGetWidth(self.showContextBtn.frame), 52.f);
    
    self.oidSwitchView.frame = CGRectMake(padding, CGRectGetMaxY(self.funcTitle.frame) + 18, CGRectGetWidth(self.bounds) - 2 * padding, 50);
    
    [self.localDataButton sizeToFit];
    self.localDataButton.frame = (CGRect) {
        CGPointMake(padding, CGRectGetMaxY(self.oidSwitchView.frame) + 18),
        self.localDataButton.frame.size
    };
    
    [self.remoteDataButton sizeToFit];
    self.remoteDataButton.frame = (CGRect) {
        CGPointMake(CGRectGetMaxX(self.localDataButton.frame) + padding, CGRectGetMinY(self.localDataButton.frame)),
        self.remoteDataButton.frame.size
    };
    
    CGFloat bottom = [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
    self.closeView.frame = CGRectMake(0, CGRectGetMaxY(self.bounds) - 40 - bottom , CGRectGetWidth(self.bounds), 40);
    
    CGFloat collectionViewHeight = CGRectGetMinY(self.closeView.frame) - CGRectGetMaxY(self.localDataButton.frame);
    self.collectionView.frame = CGRectMake(padding, CGRectGetMaxY(self.localDataButton.frame) + 10, CGRectGetWidth(self.oidSwitchView.bounds), collectionViewHeight);
}

- (void)updateWithViewModel:(EventTracingPanelViewModel *)viewModel {
    _viewModel = viewModel;
    _viewModel.remote = NO;
    self.localDataButton.selected = YES;
    
    [self.collectionView reloadData];
}

- (void)setSwitchOn:(BOOL)switchOn {
    self.oidSwitchView.switchControl.on = switchOn;
}

#pragma mark - Action
- (void)showContext:(id)sender {
    if ([self.delegate respondsToSelector:@selector(panelView:onClickShowContextBtn:)]) {
        [self.delegate panelView:self onClickShowContextBtn:sender];
    }
}

- (void)oidSwitchAction:(UISwitch *)sender {
    if ([self.delegate respondsToSelector:@selector(panelView:oidSwitchDidOn:)]) {
        [self.delegate panelView:self oidSwitchDidOn:self.oidSwitchView.switchControl.isOn];
    }
}

- (void)localDataButtonAction:(UIButton *)sender {
    _viewModel.remote = NO;
    self.localDataButton.selected = YES;
    self.remoteDataButton.selected = NO;
    [self.collectionView reloadData];
}

- (void)remoteDataButtonAction:(UIButton *)sender {
    _viewModel.remote = YES;
    self.localDataButton.selected = NO;
    self.remoteDataButton.selected = YES;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _viewModel.dataItems.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EventTracingFuncPanelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EventTracingFuncPanelCollectionViewCell" forIndexPath:indexPath];
    NSArray *items = _viewModel.dataItems;
    EventTracingPanelDataItem *dataItem = [items objectAtIndex:indexPath.row];
    [cell configWithModel:dataItem];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:_selectedIndexPath];
    if (cell && cell.isSelected) {
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        if ([self.delegate respondsToSelector:@selector(panelView:didDeselectItemAtIndexPath:)]) {
            [self.delegate panelView:self didDeselectItemAtIndexPath:indexPath];
        }
        _selectedIndexPath = nil;
        return;
    }
    _selectedIndexPath = indexPath;
    
    if ([self.delegate respondsToSelector:@selector(panelView:didSelectedItemAtIndexPath:)]) {
        [self.delegate panelView:self didSelectedItemAtIndexPath:indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(panelView:didDeselectItemAtIndexPath:)]) {
        [self.delegate panelView:self didDeselectItemAtIndexPath:indexPath];
    }
}

#pragma mark - Getter

- (UILabel *)funcTitle {
    if (!_funcTitle) {
        _funcTitle = [UILabel new];
        _funcTitle.textColor = [UIColor et_colorWithHex:0x333333];
        _funcTitle.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        _funcTitle.text = @"功能行";
    }
    return _funcTitle;
}

- (UIButton *)showContextBtn {
    if (!_showContextBtn) {
        _showContextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _showContextBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_showContextBtn setTitle:@"查看上下文" forState:UIControlStateNormal];
        [_showContextBtn setTitleColor:[UIColor et_colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [_showContextBtn addTarget:self action:@selector(showContext:) forControlEvents:UIControlEventTouchUpInside];
        [_showContextBtn sizeToFit];
    }
    return _showContextBtn;
}

- (EventTracingFuncPanelSwitchView *)oidSwitchView {
    if (!_oidSwitchView) {
        _oidSwitchView = [EventTracingFuncPanelSwitchView new];
        [_oidSwitchView.switchControl addTarget:self action:@selector(oidSwitchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _oidSwitchView;
}

- (UIButton *)localDataButton {
    if (!_localDataButton) {
        _localDataButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _localDataButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        [_localDataButton setTitle:@"本地数据" forState:UIControlStateNormal];
        [_localDataButton setTitleColor:[UIColor et_colorWithHexString:@"#333333"] forState:UIControlStateSelected];
        [_localDataButton setTitleColor:[[UIColor et_colorWithHexString:@"#333333"] colorWithAlphaComponent:0.6f] forState:UIControlStateNormal];
        [_localDataButton addTarget:self action:@selector(localDataButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _localDataButton;
}

- (UIButton *)remoteDataButton {
    if (!_remoteDataButton) {
        _remoteDataButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _remoteDataButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        [_remoteDataButton setTitle:@"云端数据" forState:UIControlStateNormal];
        [_remoteDataButton setTitleColor:[UIColor et_colorWithHexString:@"#333333"] forState:UIControlStateSelected];
        [_remoteDataButton setTitleColor:[[UIColor et_colorWithHexString:@"#333333"] colorWithAlphaComponent:0.6f] forState:UIControlStateNormal];
        [_remoteDataButton addTarget:self action:@selector(remoteDataButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _remoteDataButton;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flow = [UICollectionViewFlowLayout new];
        flow.minimumInteritemSpacing = 16;
        flow.minimumLineSpacing = 24;
        flow.itemSize = CGSizeMake(66, 72);
        flow.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:EventTracingFuncPanelCollectionViewCell.class forCellWithReuseIdentifier:@"EventTracingFuncPanelCollectionViewCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (EventTracingPanelCloseView *)closeView {
    if (!_closeView) {
        _closeView = [EventTracingPanelCloseView new];
        __weak typeof(self) weakSelf = self;
        _closeView.closeActionBlock = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if ([strongSelf.delegate respondsToSelector:@selector(panelView:onClickCloseButton:)]) {
                [strongSelf.delegate panelView:strongSelf onClickCloseButton:strongSelf.closeView.closeButton];
            }
        };
    }
    return _closeView;
}

@end
