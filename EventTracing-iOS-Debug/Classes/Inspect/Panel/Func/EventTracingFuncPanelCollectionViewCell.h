//
//  EventTracingFuncPanelCollectionViewCell.h
//  EventTracingDebug
//
//  Created by Smallfly on 2021/9/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class EventTracingPanelDataItem;

@interface EventTracingFuncPanelCollectionViewCell : UICollectionViewCell

- (void)configWithModel:(EventTracingPanelDataItem *)model;

@end

NS_ASSUME_NONNULL_END
