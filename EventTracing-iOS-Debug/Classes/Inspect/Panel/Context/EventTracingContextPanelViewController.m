//
//  EventTracingContextPanelViewController.m
//  EventTracingDebug
//
//  Created by dl on 2021/11/11.
//

#import "EventTracingContextPanelViewController.h"
#import "EventTracingPanelCloseView.h"
#import "UIColor+ETInspect.h"
#import "EventTracingInfoListViewCell.h"
#import "EventTracingInfoDataItem.h"
#import <BlocksKit/BlocksKit.h>
#import <EVentTracing/EventTracing.h>
#import "EventTracingInfoListView.h"
#import "EventTracingInspectNodeInfoUtil.h"
#import <Masonry/Masonry.h>
#import <EventTracing/EventTracingMultiReferPatch.h>

#define CONTENT_WIDTH (CGRectGetWidth(self.collectionView.bounds) - 2 * 16.0)
#define CELL_WIDTH (CONTENT_WIDTH - 54.0)

@interface EventTracingContextPanelViewController ()
@property (nonatomic, strong) UIView *panelView;
@property (nonatomic, strong) UILabel *funcTitle;
@property (nonatomic, strong) UIButton *cpyBtn;

@property (nonatomic, strong) EventTracingInfoListView *listView;
@property (nonatomic, strong) UILabel *tmpCacheLabel;
@property (nonatomic, strong) EventTracingPanelCloseView *closeView;

@property (nonatomic, strong) NSArray<EventTracingInfoSectionData *> *sectionDatas;
@end

@implementation EventTracingContextPanelViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.panelView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.panelView addSubview:self.funcTitle];
    [self.panelView addSubview:self.cpyBtn];
    [self.panelView addSubview:self.listView];
    [self.panelView addSubview:self.closeView];
    
    [self setupPanelView:self.panelView];
    
    [self.funcTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@16.f);
        make.centerY.equalTo(self.panelView.mas_top).offset(18.f + 8.f);
    }];
    [self.cpyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(@-16.f);
        make.centerY.equalTo(self.funcTitle);
    }];
    [self.closeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.panelView);
        make.height.mas_equalTo(@40.f);
    }];
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.panelView);
        make.top.equalTo(self.funcTitle.mas_bottom).offset(16.f);
        make.bottom.mas_equalTo(self.closeView.mas_top);
    }];
    
    [self setupData];
    [self.listView refreshWithSectionDatas:self.sectionDatas];
}

- (void)setupData {
    /// MARK: 内部重要参数
    NSString *multirefers = [[EventTracingMultiReferPatch sharedPatch].multiRefers componentsJoinedByString:@","];
    NSArray<EventTracingInfoDataItem *> *internalParams = [@[
        @{@"key": @"_hsrefer", @"value": [EventTracingEngine sharedInstance].context.hsrefer ?: @""},
        @{@"key": @"_multirefer", @"value": multirefers ?: @""},
        @{@"key": @"_pgstep", @"value": @([EventTracingEngine sharedInstance].context.pgstep).stringValue},
    ] bk_map:^id(NSDictionary *obj) {
        return [[EventTracingInfoDataItem alloc] initWithKey:obj[@"key"] value:obj[@"value"]];
    }];
    EventTracingInfoSectionData *internalSectionData = [[EventTracingInfoSectionData alloc] initWithTitle:@"内部重要参数" items:internalParams];
    internalSectionData.colorString = @"#FF5B5B";
    
    /// MARK: RootPage
    EventTracingVTreeNode *rootPageNode = [[EventTracingEngine sharedInstance].context.currentVTree findToppestRightPageNode];
    EventTracingInfoSectionData *rootPageNodeSectionData = [EventTracingInspectNodeInfoUtil sectionDataFromNode:rootPageNode];
    rootPageNodeSectionData.title = [NSString stringWithFormat:@"RootPage节点[%@]", rootPageNode.oid ?: @"无"];
    rootPageNodeSectionData.colorString = @"#00B894";
    
    /// MARK: 公参
    NSMutableArray<EventTracingInfoDataItem *> *publicParams = @[].mutableCopy;
    [[[EventTracingEngine sharedInstance] publicParamsForView:nil] enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {
        [publicParams addObject:[[EventTracingInfoDataItem alloc] initWithKey:key value:obj]];
    }];
    EventTracingInfoSectionData *publicSectionData = [[EventTracingInfoSectionData alloc] initWithTitle:@"公参" items:publicParams];
    publicSectionData.colorString = @"#FF9E38";
    
    self.sectionDatas = @[ internalSectionData, rootPageNodeSectionData, publicSectionData ];
}

- (void)cpyButtonAction:(id)sender {
    if (self.listView.selectedIndex < self.sectionDatas.count) {
        EventTracingInfoSectionData *selectedItem = [self.sectionDatas objectAtIndex:_listView.selectedIndex];
        NSString *jsonString = selectedItem.JSONString;
        if (!jsonString) {
            return;
        }
        
        [UIPasteboard generalPasteboard].string = jsonString;
    }
}

#pragma mark getters

- (UILabel *)funcTitle {
    if (!_funcTitle) {
        _funcTitle = [UILabel new];
        _funcTitle.textColor = [UIColor et_colorWithHex:0x333333];
        _funcTitle.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        _funcTitle.text = @"上下文";
    }
    return _funcTitle;
}

- (UIButton *)cpyBtn {
    if (!_cpyBtn) {
        _cpyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cpyBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 6);
        _cpyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cpyBtn setTitle:@"复制" forState:UIControlStateNormal];
        [_cpyBtn setTitleColor:[UIColor et_colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [_cpyBtn addTarget:self action:@selector(cpyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cpyBtn;
}

- (EventTracingInfoListView *)listView {
    if (!_listView) {
        _listView = [EventTracingInfoListView new];
    }
    return _listView;
}

- (EventTracingPanelCloseView *)closeView {
    if (!_closeView) {
        _closeView = [EventTracingPanelCloseView new];
        __weak typeof(self) weakSelf = self;
        _closeView.closeActionBlock = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf dismiss:YES];
        };
    }
    return _closeView;
}

- (UILabel *)tmpCacheLabel {
    if (!_tmpCacheLabel) {
        _tmpCacheLabel = [UILabel new];
        _tmpCacheLabel.numberOfLines = 0;
        _tmpCacheLabel.font = [UIFont systemFontOfSize:14];
        _tmpCacheLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _tmpCacheLabel;
}

@end
