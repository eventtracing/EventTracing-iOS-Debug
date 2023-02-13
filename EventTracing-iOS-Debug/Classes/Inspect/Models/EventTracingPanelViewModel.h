//
//  EventTracingPanelViewModel.h
//  EventTracingDebug
//
//  Created by Smallfly on 2021/9/10.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EventTracingPanelDataItem : NSObject

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *imageName;
@property (nonatomic, copy, readonly) NSArray<NSString *> *eventIds;

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName eventIds:(NSArray<NSString *> *)eventIds;

@end


@interface EventTracingPanelViewModel : NSObject

/// 是否是远端数据
@property (nonatomic, assign, getter=isRemote) BOOL remote;

@property (nonatomic, copy) NSArray<EventTracingPanelDataItem *> *dataItems;

- (void)addItemTitle:(NSString *)title imageName:(NSString *)imageName eventIds:(NSArray <NSString *> *)eventIds remote:(BOOL)remote;

@end

NS_ASSUME_NONNULL_END
