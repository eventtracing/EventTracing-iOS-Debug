//
//  EventTracingInfoListView.m
//  EventTracingDebug
//
//  Created by jiangxiaofei on 2021/9/18.
//

#import "EventTracingInfoListView.h"
#import "EventTracingInfoListViewHeader.h"
#import "EventTracingInfoListViewCell.h"
#import "EventTracingInfoSectionData.h"
#import "EventTracingInspect2DDefines.h"
#import "EventTracingInfoListViewLayout.h"
#import "UIColor+ETInspect.h"

#define CELL_ID NSStringFromClass(EventTracingInfoListViewCell.class)
#define HEADER_ID NSStringFromClass(EventTracingInfoListViewHeader.class)


#define CONTENT_WIDTH (CGRectGetWidth(self.collectionView.bounds) - 2 * 16.0)
#define CELL_WIDTH (CONTENT_WIDTH - 54.0)

@interface EventTracingInfoListView ()
<
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
EventTracingInfoListViewHeaderDelegate
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *tmpCacheLabel;

@property (nonatomic, copy) NSArray<EventTracingInfoSectionData *> *sectionDatas;
@end

@implementation EventTracingInfoListView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
}

- (void)refreshWithSectionDatas:(NSArray<EventTracingInfoSectionData *> *)sectionDatas {
    _selectedIndex = 0;

    _sectionDatas = sectionDatas;
    NSInteger totalCount = sectionDatas.count;
    [_sectionDatas enumerateObjectsUsingBlock:^(EventTracingInfoSectionData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *stringColor = obj.colorString ?: ETinspect2DLayerColorAt(totalCount - idx - 1);
        obj.colorString = stringColor;
    }];
    
    [self.collectionView reloadData];
}

#pragma mark - EventTracingInfoListViewHeaderDelegate

- (void)listViewHeader:(EventTracingInfoListViewHeader *)header didClickUnFoldSection:(NSInteger)section unfold:(BOOL)unfold {
    if (unfold) {
        _selectedIndex = section;
    } else {
        _selectedIndex = NSNotFound;
    }
    
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
    
    if (_selectedIndex != NSNotFound) {
        UICollectionViewLayoutAttributes *attributes = [self.collectionView.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                                                                atIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        if (attributes) {
            CGFloat offsetY = attributes.frame.origin.y - self.collectionView.contentInset.top;
            offsetY = MIN(offsetY, self.collectionView.contentSize.height - self.collectionView.bounds.size.height) - self.collectionView.contentInset.top;
            offsetY = MAX(offsetY, -self.collectionView.contentInset.top);
            [self.collectionView setContentOffset:CGPointMake(0.f, offsetY) animated:NO];
        }
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _sectionDatas.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    EventTracingInfoSectionData *item = [_sectionDatas objectAtIndex:section];
    return section == _selectedIndex ? item.items.count : 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EventTracingInfoListViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_ID forIndexPath:indexPath];
    
    [cell refreshWithDataItem:_sectionDatas[indexPath.section].items[indexPath.row]];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    EventTracingInfoListViewHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HEADER_ID forIndexPath:indexPath];
    header.delegate = self;
    
    NSInteger section = indexPath.section;
    BOOL unfold = _selectedIndex == section;
    NSInteger serialNum = _sectionDatas.count - section;
    
    EventTracingInfoSectionData *dataItem = _sectionDatas[section];
    [header refreshWithSectionData:dataItem serialNum:serialNum section:section unfold:unfold];
    return header;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    EventTracingInfoSectionData *sectionData = _sectionDatas[indexPath.section];
    EventTracingInfoDataItem *dataItem = sectionData.items[indexPath.row];
    self.tmpCacheLabel.text = dataItem.description;

    if (dataItem.fontItalic) {
        self.tmpCacheLabel.font = [UIFont italicSystemFontOfSize:14];
    } else {
        self.tmpCacheLabel.font = [UIFont systemFontOfSize:14 weight:dataItem.fontWeight];
    }
    
    CGSize textSize = [self.tmpCacheLabel sizeThatFits:CGSizeMake(CELL_WIDTH, CGFLOAT_MAX)];
    return CGSizeMake(CELL_WIDTH, textSize.height);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(CONTENT_WIDTH, 52);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return _selectedIndex == section ? UIEdgeInsetsMake(12, 38, 26, 16) : UIEdgeInsetsMake(0, 38, 10, 16);
}

#pragma mark - Getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        __weak typeof(self) weakSelf = self;
        UICollectionViewFlowLayout *layout = [[EventTracingInfoListViewLayout alloc] initWithBackgroundColorBlock:^NSString * _Nonnull(NSInteger index) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            EventTracingInfoSectionData *sectionData = strongSelf.sectionDatas[index];
            NSString *bgColorString = sectionData.bgColorString ?: sectionData.colorString;
            return bgColorString ?: ETinspect2DLayerColorAt(strongSelf.sectionDatas.count - index - 1);
        }];
        layout.minimumLineSpacing = 12.0;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[EventTracingInfoListViewCell class] forCellWithReuseIdentifier:CELL_ID];
        [_collectionView registerClass:[EventTracingInfoListViewHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEADER_ID];
    }
    return _collectionView;
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
