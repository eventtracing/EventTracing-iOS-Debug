//
//  EventTracingInspect2DNodeLayerView.m
//  EventTracing
//
//  Created by dl on 2021/6/10.
//

#import "EventTracingInspect2DNodeLayerView.h"
#import "EventTracingInspect2DDefines.h"
#import "UIColor+ETInspect.h"
#import "CALayer+ETInspect.h"

#pragma clang diagnostic ignored "-Wincomplete-umbrella"
#import <EventTracing/NSArray+ETEnumerator.h>
#pragma clang diagnostic pop

@interface EventTracingInspect2DNodeLayerView ()
@property(nonatomic, strong, readwrite) NEEventTracingVTree *VTree;
@property(nonatomic, strong, readwrite) NEEventTracingVTreeNode *highlightNode;

@property(nonatomic, strong) NSMutableArray<CALayer *> *dequeueNodeLayers;
@property(nonatomic, strong) NSMutableArray<CALayer *> *showingNodeLayers;

@property(nonatomic, strong) NSMutableArray<CATextLayer *> *dequeueNodeTagLayers;
@property(nonatomic, strong) NSMutableArray<CATextLayer *> *showingNodeTagLayers;

@property (nonatomic, assign) CGRect lastLayerFrame;
@property (nonatomic, assign) CGRect lastTagFrame;
@end

@implementation EventTracingInspect2DNodeLayerView

- (instancetype)init {
    self = [super init];
    if (self) {
        _dequeueNodeLayers = @[].mutableCopy;
        _showingNodeLayers = @[].mutableCopy;
        
        _dequeueNodeTagLayers = @[].mutableCopy;
        _showingNodeTagLayers = @[].mutableCopy;
    }
    return self;
}

- (void)drawWithVTree:(NEEventTracingVTree *)VTree highlightNode:(NEEventTracingVTreeNode *)node {
    self.VTree = VTree;
    self.highlightNode = node;
    
    self.lastTagFrame = CGRectNull;
    self.lastLayerFrame = CGRectNull;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    [self clear];
    
    if (!node) {
        return;
    }
    
    NSMutableArray<NEEventTracingVTreeNode *> *nodes = @[].mutableCopy;
    [@[node] ne_et_enumerateObjectsUsingBlock:^NSArray<NEEventTracingVTreeNode *> * _Nonnull(NEEventTracingVTreeNode * _Nonnull obj, BOOL * _Nonnull stop) {
        [nodes insertObject:obj atIndex:0];
        return ((obj.parentNode && !obj.parentNode.isRoot) ? @[obj.parentNode] : nil);
    }];
    
    [nodes enumerateObjectsUsingBlock:^(NEEventTracingVTreeNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *colorString = ETinspect2DLayerColorAt(obj.depth - 1);
        CALayer *layer = [self _addLayerForNode:obj colorString:colorString];
        
        // 当前选中节点背景
        if ([obj ne_et_isEqualToDiffableObject:node]) {
            layer.backgroundColor = [[UIColor et_colorWithHexString:@"#0091FF"] et_colorByMultiplyAlpha:0.3f].CGColor;
        }
        
        // 当前选中节点父节点背景
        if ([obj ne_et_isEqualToDiffableObject:node.parentNode]) {
            layer.backgroundColor = [[UIColor et_colorWithHexString:@"#0091FF"] et_colorByMultiplyAlpha:0.1f].CGColor;
        }

        // 添加角标
        [self _addTagLayerForNode:obj colorString:colorString visibleRect:self.lastLayerFrame];
    }];
    
    [CATransaction commit];
}

- (void)clear {
    [self.showingNodeLayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperlayer];
        [self.dequeueNodeLayers addObject:obj];
    }];
    [self.showingNodeLayers removeAllObjects];
    
    [self.showingNodeTagLayers enumerateObjectsUsingBlock:^(CATextLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperlayer];
        [self.dequeueNodeTagLayers insertObject:obj atIndex:0];
    }];
    [self.showingNodeTagLayers removeAllObjects];
}

#pragma mark - Layer

- (CGRect)_adjustLayerRect:(CGRect)originRect refRect:(CGRect)refRect {
    if (CGRectEqualToRect(refRect, CGRectNull)) {
        return originRect;
    }
    
    CGRect targetRect = originRect;
    CGFloat pixel = 1.0;
    
    if (CGRectGetMinX(originRect) <= CGRectGetMinX(refRect)) {
        targetRect.origin.x = refRect.origin.x + pixel;
        targetRect.size.width -= (refRect.origin.x - targetRect.origin.x + pixel);
    }
    if (CGRectGetMinY(originRect) <= CGRectGetMinY(refRect)) {
        targetRect.origin.y = refRect.origin.y + pixel;
        targetRect.size.height -= (refRect.origin.y - targetRect.origin.y + pixel);
    }
    if (CGRectGetMaxX(originRect) >= CGRectGetMaxX(refRect)) {
        targetRect.size.width -= (CGRectGetMaxX(originRect) - CGRectGetMaxX(refRect) + pixel);
    }
    if (CGRectGetMaxY(originRect) >= CGRectGetMaxY(refRect)) {
        targetRect.size.height -= (CGRectGetMaxY(originRect) - CGRectGetMaxY(refRect) + pixel);
    }
    
    return targetRect;
}

- (CALayer *)_addLayerForNode:(NEEventTracingVTreeNode *)node colorString:(NSString *)colorString {
    CGRect targetRect = [self _adjustLayerRect:node.visibleRect refRect:self.lastLayerFrame];

    CALayer *layer = [self _fetchLayer];
    layer.frame = targetRect;
    layer.backgroundColor = nil;
    layer.borderColor = [[UIColor et_colorWithHexString:colorString] et_colorByMultiplyAlpha:0.4f].CGColor;
    layer.borderWidth = 2.f;
    [layer et_removeImplicitAnimations];
    [self.layer addSublayer:layer];
    [self.showingNodeLayers addObject:layer];
    
    self.lastLayerFrame = targetRect;
    
    return layer;
}

- (CALayer *) _fetchLayer {
    CALayer *layer = nil;
    if (self.dequeueNodeLayers.count) {
        layer = self.dequeueNodeLayers.lastObject;
        [self.dequeueNodeLayers removeLastObject];
    } else {
        layer = [CALayer layer];
    }
    return layer;
}

#pragma mark - Tag

- (CGRect)_adjustRect:(CGRect)originRect refRect:(CGRect)refRect {
    CGRect targetRect = originRect;
    
    CGFloat statusBarHeight = 0;
    if (@available(iOS 13, *)) {
        statusBarHeight = UIApplication.sharedApplication.keyWindow.windowScene.statusBarManager.statusBarFrame.size.height;
    } else {
        statusBarHeight = UIApplication.sharedApplication.statusBarFrame.size.height;
    }
    
    // 避开状态栏左上角
    CGRect statusBarCornerRect = CGRectMake(0, 0, statusBarHeight, statusBarHeight);
    if (CGRectIntersectsRect(targetRect, statusBarCornerRect)) {
        targetRect.origin.x += statusBarCornerRect.size.width;
    }
    
    // 防重叠
    if (CGRectIntersectsRect(targetRect, refRect)) {
        CGRect sects = CGRectIntersection(targetRect, refRect);
        targetRect.origin.x += sects.size.width;
    }
    
    return targetRect;
}

- (CALayer *)_addTagLayerForNode:(NEEventTracingVTreeNode *)node colorString:(NSString *)colorString visibleRect:(CGRect)visibleRect {
    CGRect targetRect = [self _adjustRect:visibleRect refRect:self.lastTagFrame];

    CATextLayer *tagLayer = [self _fetchTagLayer];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    tagLayer.frame = (CGRect){
        targetRect.origin,
        tagLayer.frame.size
    };
    tagLayer.backgroundColor = [UIColor et_colorWithHexString:colorString].CGColor;
    tagLayer.string = @(node.depth).stringValue;
    [CATransaction commit];
    
    [self.layer addSublayer:tagLayer];
    [self.showingNodeTagLayers addObject:tagLayer];
    
    self.lastTagFrame = tagLayer.frame;
    
    return tagLayer;
}

- (CATextLayer *)_fetchTagLayer {
    CATextLayer *tagLayer = nil;
    if (self.dequeueNodeTagLayers.count) {
        tagLayer = self.dequeueNodeTagLayers.lastObject;
        [self.dequeueNodeTagLayers removeLastObject];
    } else {
        tagLayer = [CATextLayer layer];
        tagLayer.contentsScale = UIScreen.mainScreen.scale;
        tagLayer.foregroundColor = [UIColor whiteColor].CGColor;
        tagLayer.alignmentMode = kCAAlignmentCenter;
        tagLayer.fontSize = 12;
        tagLayer.frame = CGRectMake(0, 0, 16, 16);
    }
    return tagLayer;
}

@end
