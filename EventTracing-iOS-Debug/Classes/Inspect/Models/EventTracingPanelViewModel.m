//
//  EventTracingPanelViewModel.m
//  EventTracingDebug
//
//  Created by Smallfly on 2021/9/10.
//

#import "EventTracingPanelViewModel.h"


@implementation EventTracingPanelDataItem

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName eventIds:(NSArray<NSString *> *)eventIds {
    self = [super init];
    if (!self) return nil;
    _title = title;
    _imageName = imageName;
    _eventIds = eventIds.copy;
    return self;
}

@end


@implementation EventTracingPanelViewModel {
    NSMutableArray *_localItems;
    NSMutableArray *_remoteItems;
}

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    _remote = NO;
    _localItems = [NSMutableArray array];
    _remoteItems = [NSMutableArray array];
    
    return self;
}

- (void)addItemTitle:(NSString *)title imageName:(NSString *)imageName eventIds:(NSArray *)eventIds remote:(BOOL)remote {
    EventTracingPanelDataItem *dataItem = [[EventTracingPanelDataItem alloc] initWithTitle:title imageName:imageName eventIds:eventIds];
    
    if (remote) {
        [_remoteItems addObject:dataItem];
    } else {
        [_localItems addObject:dataItem];
    }
}

- (NSArray<EventTracingPanelDataItem *> *)dataItems {
    return _remote ? _remoteItems.copy : _localItems.copy;
}

@end
