//
//  EventTracingInspectNodeInfoUtil.m
//  EventTracingDebug
//
//  Created by dl on 2021/11/11.
//

#import "EventTracingInspectNodeInfoUtil.h"
#import "EventTracingInfoDataItem.h"
#import <EventTracing/EventTracing.h>

#pragma clang diagnostic ignored "-Wincomplete-umbrella"
#import <EventTracing/NSArray+ETEnumerator.h>
#pragma clang diagnostic pop

@implementation EventTracingInspectNodeInfoUtil

+ (NSArray<EventTracingInfoSectionData *> *)recursionSectionDataFromNode:(EventTracingVTreeNode *)node {
    NSMutableArray *sectionDatas = [NSMutableArray array];
    [@[node] et_enumerateObjectsUsingBlock:^NSArray * _Nonnull(EventTracingVTreeNode *  _Nonnull obj, BOOL * _Nonnull stop) {
        EventTracingInfoSectionData *sectionData = [self sectionDataFromNode:obj];
        [sectionDatas addObject:sectionData];
        return ((obj.parentNode && !obj.parentNode.isRoot) ? @[obj.parentNode] : nil);
    }];
    return sectionDatas;
}

+ (EventTracingInfoSectionData *)sectionDataFromNode:(EventTracingVTreeNode *)node {
    NSMutableArray<EventTracingInfoDataItem *> *items = @[].mutableCopy;
    if (!node) {
        return [[EventTracingInfoSectionData alloc] initWithTitle:@"" items:items.copy];
    }
    
    // 节点配置信息
    [self buildNodeConfigData:node builder:^(NSString *key, NSString *value) {
        EventTracingInfoDataItem *item = [[EventTracingInfoDataItem alloc] initWithKey:key value:value];
        item.fontWeight = UIFontWeightMedium;
        item.alpha = 1.f;
        [items addObject:item];
    }];

    [self buildNodeParamsData:node builder:^(NSString *key, NSString *value) {
        EventTracingInfoDataItem *item = [[EventTracingInfoDataItem alloc] initWithKey:key value:value];
        item.fontWeight = UIFontWeightRegular;
        item.alpha = .8f;
        [items addObject:item];
    }];

    [self buildNodeCalculateData:node builder:^(NSString *key, NSString *value) {
        EventTracingInfoDataItem *item = [[EventTracingInfoDataItem alloc] initWithKey:key value:value];
        item.fontWeight = UIFontWeightRegular;
        item.alpha = .6f;
        item.fontItalic = YES;
        [items addObject:item];
    }];
    
    return [[EventTracingInfoSectionData alloc] initWithTitle:node.oid items:items.copy];
}

+ (void)buildNodeConfigData:(EventTracingVTreeNode *)node builder:(void(^)(NSString *key, NSString *value))builder {
    // virtual node
    if (node.isVirtualNode) {
        builder(@"virtual", @"YES(visible_rect是子节点的并集)");
    }
    // parent virtual node
    if (node.parentNode.isVirtualNode) {
        builder(@"parent_virtual", @"YES(父节点是虚拟节点)");
    }

    NSString *(^formatFloat)(CGFloat) = ^NSString *(CGFloat value) {
        if (fmodf(value, 1) == 0) {
            return [NSString stringWithFormat:@"%.0f", value];
        }
        return [NSString stringWithFormat:@"%.1f", value];
    };

    // 可见区域
    builder(@"visible_rect", [NSString stringWithFormat:@"{x: %@, y: %@, w: %@, h: %@}",
                                                        formatFloat(node.visibleRect.origin.x),
                                                        formatFloat(node.visibleRect.origin.y),
                                                        formatFloat(node.visibleRect.size.width),
                                                        formatFloat(node.visibleRect.size.height)]);
    
    builder(@"impressMaxRatio", @(node.impressMaxRatio).stringValue);
    
    // 级联忽略 refer
    builder(@"ignoreReferCascade", @(node.ignoreRefer).stringValue);

    // 可见区域的 insets
    UIEdgeInsets visibleEdgeInsets = node.view.et_visibleEdgeInsets;
    if (!UIEdgeInsetsEqualToEdgeInsets(visibleEdgeInsets, UIEdgeInsetsZero)) {
        builder(@"insets", [NSString stringWithFormat:@"{t: %@, r: %@, b: %@, l: %@}",
                                                      formatFloat(visibleEdgeInsets.top),
                                                      formatFloat(visibleEdgeInsets.right),
                                                      formatFloat(visibleEdgeInsets.bottom),
                                                      formatFloat(visibleEdgeInsets.left)]);
    }

    // page
    if (node.isPageNode) {
        BOOL isRootpageNode = node == [node.VTree findRootPageNodeFromNode:node];
        builder(@"page", (isRootpageNode ? @"rootpage" : @"subpage"));
    }

    // visible stategy
    if (node.view.et_visibleRectCalculateStrategy == ETNodeVisibleRectCalculateStrategyRecursionOnViewTree) {
        builder(@"visible_strategy", @"[RecursionOnViewTree]依赖原始view层级");
    }

    // blocked
    if (node.blockedBySubPage) {
        builder(@"blocked", @"不可见: 被子page遮挡");
    }

    if (node.view.et_isAutoMountOnCurrentRootPageEnable) {
        builder(@"logical_mount", @"Auto(自动挂载到当前rootpage)");
    } else if (node.view.et_logicalParentView != nil) {
        builder(@"logical_mount", @"Manual(手动挂载)");
    }

    // disable buildin log
    if (node.buildinEventLogDisableStrategy != ETNodeBuildinEventLogDisableStrategyNone) {
        NSMutableString *buildinDisableLogString = @"".mutableCopy;
        if (node.buildinEventLogDisableStrategy & ETNodeBuildinEventLogDisableStrategyImpress) {
            [buildinDisableLogString appendFormat:@"[impress]"];
        }
        if (node.buildinEventLogDisableStrategy & ETNodeBuildinEventLogDisableStrategyImpressend) {
            [buildinDisableLogString appendFormat:@"[impressend]"];
        }
        if (node.buildinEventLogDisableStrategy & ETNodeBuildinEventLogDisableStrategyClick) {
            [buildinDisableLogString appendFormat:@"[click]"];
        }
        builder(@"disable_buildin_log", buildinDisableLogString);
    }

    if (node.position > 0) {
        builder(@"position", @(node.position).stringValue);
    }

    if (node.toids.count) {
        builder(@"toids", [node.toids componentsJoinedByString:@","]);
    }
}

+ (void)buildNodeParamsData:(EventTracingVTreeNode *)node builder:(void(^)(NSString *key, NSString *value))builder {
    [node.nodeStaticParams enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        builder([NSString stringWithFormat:@"[Static]%@", key], obj);
    }];

    [node.nodeDynamicParams enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        builder([NSString stringWithFormat:@"[Dynamic]%@", key], obj);
    }];
}

+ (void)buildNodeCalculateData:(EventTracingVTreeNode *)node builder:(void(^)(NSString *key, NSString *value))builder {
    // spm
    builder(@"spm", node.spm ?: @"");
    // scm
    builder(@"scm", node.scm ?: @"");

    // pgrefer(page节点)
    if (node.pgrefer) {
        builder(@"pgrefer", node.pgrefer);
    }

    // actseq
    if (node.isPageNode) {
        EventTracingVTreeNode *rootPageNode = [node.VTree findRootPageNodeFromNode:node];
        if ([rootPageNode et_isEqualToDiffableObject:node]) {
            builder(@"actseq", @(node.actseq).stringValue);
        }
    }
}

@end
