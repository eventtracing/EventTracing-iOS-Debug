//
//  EventTracingInfoListViewCell.h
//  EventTracingDebug
//
//  Created by jiangxiaofei on 2021/9/18.
//

#import <UIKit/UIKit.h>
#import "EventTracingInfoDataItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface EventTracingInfoListViewDecorationView : UICollectionReusableView
@end

@interface EventTracingInfoListViewCell : UICollectionViewCell
- (void)refreshWithDataItem:(EventTracingInfoDataItem *)dataItem;
@end

NS_ASSUME_NONNULL_END
