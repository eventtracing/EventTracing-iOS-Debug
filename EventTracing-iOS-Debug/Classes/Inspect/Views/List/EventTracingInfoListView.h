//
//  EventTracingInfoListView.h
//  EventTracingDebug
//
//  Created by jiangxiaofei on 2021/9/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class EventTracingInfoSectionData;
@interface EventTracingInfoListView : UIView

@property (nonatomic, assign, readonly) NSUInteger selectedIndex;

- (void)refreshWithSectionDatas:(NSArray<EventTracingInfoSectionData *> *)sectionDatas;

@end

NS_ASSUME_NONNULL_END
