//
//  EventTracingInspect2DWindow.h
//  BlocksKit
//
//  Created by dl on 2021/5/12.
//

#import <UIKit/UIKit.h>
#import "EventTracingInspectControlBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface EventTracingInspect2DWindow : UIWindow

@property(nonatomic, strong, readonly) EventTracingInspectControlBar *inspectControlBar;

@end

NS_ASSUME_NONNULL_END
