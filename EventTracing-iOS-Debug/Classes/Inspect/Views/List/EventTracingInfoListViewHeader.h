//
//  EventTracingInfoListViewHeader.h
//  EventTracingDebug
//
//  Created by dl on 2021/11/10.
//

#import <Foundation/Foundation.h>
#import "EventTracingInfoSectionData.h"

NS_ASSUME_NONNULL_BEGIN

@class EventTracingInfoListViewHeader;
@protocol EventTracingInfoListViewHeaderDelegate <NSObject>

- (void)listViewHeader:(EventTracingInfoListViewHeader *)header didClickUnFoldSection:(NSInteger)section unfold:(BOOL)unfold;

@end

@interface EventTracingInfoListViewHeader: UICollectionReusableView

@property (nonatomic, assign) id<EventTracingInfoListViewHeaderDelegate> delegate;

- (void)refreshWithSectionData:(EventTracingInfoSectionData *)sectionData
                  serialNum:(NSInteger)serialNum
                    section:(NSInteger)section
                     unfold:(BOOL)unfold;

@end

NS_ASSUME_NONNULL_END
