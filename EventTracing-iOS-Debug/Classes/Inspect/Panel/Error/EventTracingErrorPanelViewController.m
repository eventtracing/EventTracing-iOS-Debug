//
//  EventTracingErrorPanelViewController.m
//  EventTracingDebug
//
//  Created by Smallfly on 2021/9/21.
//

#import "EventTracingErrorPanelViewController.h"
#import "EventTracingErrorPanelView.h"
#import "EventTracingInfoSectionData.h"
#import <BlocksKit/BlocksKit.h>
#import "EventTracingInspectEngine+Private.h"

@interface EventTracingErrorPanelViewController () <EventTracingErrorPanelViewDelegate>
@property (nonatomic, strong) EventTracingErrorPanelView *panelView;

@property (nonatomic, copy) NSArray<EventTracingInfoSectionData *> *sectionDatas;
@end

@implementation EventTracingErrorPanelViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupPanelView:self.panelView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)show:(BOOL)animated {
    [super show:animated];
    
    NSDictionary<NSString *, EventTracingErrorGroupData *> *errorGroupDatas = [EventTracingInspectEngine sharedInstance].errorGroupDatas.copy;
    NSArray<NSString *> *identifiers = [errorGroupDatas.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        EventTracingErrorGroupData *groupData1 = [errorGroupDatas objectForKey:obj1];
        EventTracingErrorGroupData *groupData2 = [errorGroupDatas objectForKey:obj2];
        
        return groupData1.lastUpdatedTime < groupData2.lastUpdatedTime;
    }];
    self.sectionDatas = [identifiers bk_map:^id(NSString *obj) {
        EventTracingErrorGroupData *groupData = [errorGroupDatas objectForKey:obj];
        NSString *title = [NSString stringWithFormat:@"%@(%@)", groupData.dataItem.key, @(groupData.count).stringValue];
        NSMutableArray<EventTracingInfoDataItem *> *items = @[
            [[EventTracingInfoDataItem alloc] initWithKey:@"key" value:groupData.dataItem.key],
            [[EventTracingInfoDataItem alloc] initWithKey:@"code" value:@(groupData.dataItem.code).stringValue]
        ].mutableCopy;
        
        [groupData.dataItem.content enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            [items addObject:[[EventTracingInfoDataItem alloc] initWithKey:key value:obj]];
        }];
        EventTracingInfoSectionData *sectionData = [[EventTracingInfoSectionData alloc] initWithTitle:title items:items];
        sectionData.colorString = @"#333333";
        sectionData.bgColorString = @"#FF5B5B";
        return sectionData;
    }];
    
    [self.panelView refreshWithSectionDatas:self.sectionDatas];
}

#pragma mark - EventTracingErrorPanelViewDelegate

- (void)errorPanelView:(EventTracingErrorPanelView *)panelView onClickCopyButton:(id)sender {
    if (panelView.listView.selectedIndex < self.sectionDatas.count) {
        NSString *jsonString = [self.sectionDatas objectAtIndex:panelView.listView.selectedIndex].JSONString;
        if (!jsonString) return;
        
        [UIPasteboard generalPasteboard].string = jsonString;
    }
}

- (void)errorPanelView:(EventTracingErrorPanelView *)panelView onClickCloseButton:(id)sender {
    [self dismiss:YES];
}

- (EventTracingErrorPanelView *)panelView {
    if (!_panelView) {
        _panelView = [EventTracingErrorPanelView new];
        _panelView.delegate = self;
    }
    return _panelView;
}

@end
