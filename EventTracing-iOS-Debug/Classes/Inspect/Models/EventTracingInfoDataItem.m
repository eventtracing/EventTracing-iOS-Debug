//
//  EventTracingInfoDataItem.m
//  EventTracingDebug
//
//  Created by dl on 2021/11/11.
//

#import "EventTracingInfoDataItem.h"

@implementation EventTracingInfoDataItem

- (instancetype)initWithKey:(NSString *)key value:(NSString *)value {
    return [self initWithKey:key value:value insets:UIEdgeInsetsZero];
}

- (instancetype)initWithKey:(NSString *)key value:(NSString *)value insets:(UIEdgeInsets)inset {
    self = [self init];
    if (self) {
        _key = key;
        _value = value;
        _inset = inset;
        _fontWeight = UIFontWeightRegular;
        _alpha = 1.f;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ : %@", _key ?: @"NULL", _value ?: @"NULL"];
}

@end
