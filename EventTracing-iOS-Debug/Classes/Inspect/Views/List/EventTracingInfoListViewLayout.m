//
//  EventTracingInfoListViewLayout.m
//  EventTracingDebug
//
//  Created by Smallfly on 2021/9/19.
//

#import "EventTracingInfoListViewLayout.h"
#import "EventTracingInspect2DDefines.h"
#import "EventTracingInfoListViewCell.h"

#define DECORATION_ID NSStringFromClass(EventTracingInfoListViewDecorationView.class)

typedef NSString * (^ColorBuilderBlock)(NSInteger index);

@implementation EventTracingInfoListViewLayoutAttributes
@end

@implementation EventTracingInfoListViewLayout {
    NSMutableArray *_attributes;
    ColorBuilderBlock _colorBlock;
}

- (instancetype)initWithBackgroundColorBlock:(NSString *(^)(NSInteger))colorBlock {
    self = [super init];
    if (self) {
        _colorBlock = colorBlock;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    [self registerClass:[EventTracingInfoListViewDecorationView class] forDecorationViewOfKind:DECORATION_ID];
    
    _attributes = [NSMutableArray array];

    NSInteger sections = self.collectionView.numberOfSections;
    for (NSInteger sec = 0; sec < sections; sec++) {
        EventTracingInfoListViewLayoutAttributes *attri = [EventTracingInfoListViewLayoutAttributes layoutAttributesForDecorationViewOfKind:DECORATION_ID withIndexPath:[NSIndexPath indexPathForRow:0 inSection:sec]];
        attri.backgroundHexColor = _colorBlock ? _colorBlock(sec) : nil;
        attri.zIndex = -1;

        NSInteger rows = [self.collectionView numberOfItemsInSection:sec];

        UICollectionViewLayoutAttributes *firstItem = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:sec]];
        UICollectionViewLayoutAttributes *lastItem = rows == 0 ? firstItem : [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:sec]];
        
        CGFloat bottomPadding = rows == 0 ? 0 : 16;
        CGFloat height = CGRectGetMaxY(lastItem.frame) - CGRectGetMinY(firstItem.frame);
        attri.frame = CGRectMake(16, CGRectGetMinY(firstItem.frame), CGRectGetWidth(self.collectionView.bounds) - 32, height + bottomPadding);
        
        [_attributes addObject:attri];
    }
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [super layoutAttributesForElementsInRect:rect].mutableCopy;
    for (UICollectionViewLayoutAttributes *attri in _attributes) {
        if (CGRectIntersectsRect(rect, attri.frame)) {
            [attributes addObject:attri];
        }
    }
    return attributes.copy;
}

@end
