//
//  EventTracingPanelCloseView.h
//  EventTracingDebug
//
//  Created by Smallfly on 2021/9/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EventTracingPanelCloseView : UIView

@property (nonatomic, strong, readonly) UIButton *closeButton;
@property (nonatomic, copy) void (^closeActionBlock)(void);

@end

NS_ASSUME_NONNULL_END
