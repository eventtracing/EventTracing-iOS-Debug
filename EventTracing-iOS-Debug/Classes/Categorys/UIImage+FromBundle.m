//
//  UIImage+FromBundle.m
//  EventTracingDebug
//
//  Created by dl on 2022/12/13.
//

#import "UIImage+FromBundle.h"

@implementation UIImage (FromBundle)

+ (UIImage *)et_imageNamed:(NSString *)imageName {
    NSString *bundleName = MODULE_NAME;
    
    NSBundle *bundle = nil;
    if (! bundleName) {
        bundle = [NSBundle mainBundle];
    }
    NSURL *url = [[NSBundle mainBundle] URLForResource:bundleName withExtension:@"bundle"];
    if (url) {
        bundle = [NSBundle bundleWithURL:url];
    }
    
    if (!bundle) {
        NSString *identifier = [NSString stringWithFormat:@"org.cocoapods.%@", [bundleName stringByReplacingOccurrencesOfString:@"_" withString:@"-"]];
        bundle = [NSBundle bundleWithIdentifier:identifier];
    }
    
    if (!bundle) {
        return nil;
    }
    
    if (@available(iOS 13.0, *)) {
        return [UIImage imageNamed:imageName inBundle:bundle withConfiguration:nil];
    } else {
        return [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
    }
}

- (UIImage *)et_imageWithTintColor:(UIColor *)color {
    if (@available(iOS 13.0, *)) {
        return [self imageWithTintColor:color];
    }
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    [color set];
    UIRectFill(rect);
    [self drawAtPoint:CGPointMake(0, 0) blendMode:kCGBlendModeDestinationIn alpha:1];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
