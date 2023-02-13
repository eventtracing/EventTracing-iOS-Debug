//
//  EventTracingInfoDataItem.h
//  EventTracingDebug
//
//  Created by dl on 2021/11/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class EventTracingInfoSectionData;
@interface EventTracingInfoDataItem : NSObject

@property(nonatomic, copy, readonly) NSString *key;
@property(nonatomic, copy, readonly) NSString *value;

@property(nonatomic, weak) EventTracingInfoSectionData *sectionData;

// UI
@property(nonatomic, assign, readonly) UIEdgeInsets inset;
@property(nonatomic, copy) NSString *colorString;
@property(nonatomic, assign) BOOL fontItalic;
@property(nonatomic, assign) UIFontWeight fontWeight;
@property(nonatomic, assign) CGFloat alpha;

- (instancetype)initWithKey:(NSString *)key value:(NSString *)value;
- (instancetype)initWithKey:(NSString *)key value:(NSString *)value insets:(UIEdgeInsets)inset;

@end

NS_ASSUME_NONNULL_END
