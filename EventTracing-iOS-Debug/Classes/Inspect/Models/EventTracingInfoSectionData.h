//
//  EventTracingInfoSectionData.h
//  EventTracingDebug
//
//  Created by jiangxiaofei on 2021/9/18.
//

#import <Foundation/Foundation.h>
#import "EventTracingInfoDataItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface EventTracingInfoSectionData : NSObject

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *colorString;
@property(nonatomic, copy) NSString *bgColorString;

@property (nonatomic, strong) NSArray<EventTracingInfoDataItem *> *items;

- (instancetype)initWithTitle:(NSString *)title items:(NSArray<EventTracingInfoDataItem *> *)items;
- (nullable NSString *)JSONString;

@end

NS_ASSUME_NONNULL_END
