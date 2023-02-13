//
//  UIImage+FromBundle.h
//  EventTracingDebug
//
//  Created by dl on 2022/12/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (FromBundle)

+ (UIImage * _Nullable)et_imageNamed:(NSString *)imageName;

- (UIImage * _Nullable)et_imageWithTintColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
