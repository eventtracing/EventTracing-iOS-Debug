//
//  UIColor+ETInspect.m
//  BlocksKit
//
//  Created by dl on 2021/5/17.
//

#import "UIColor+ETInspect.h"

@implementation UIColor (ETInspect)

- (UIColor *)et_addOverlay:(UIColor *)color {
    CGFloat bgR = 0;
    CGFloat bgG = 0;
    CGFloat bgB = 0;
    CGFloat bgA = 0;
    
    CGFloat fgR = 0;
    CGFloat fgG = 0;
    CGFloat fgB = 0;
    CGFloat fgA = 0;
    
    [self getRed:&bgR green:&bgG blue:&bgB alpha:&bgA];
    [color getRed:&fgR green:&fgG blue:&fgB alpha:&fgA];
    
    CGFloat r = fgA * fgR + (1 - fgA) * bgR;
    CGFloat g = fgA * fgG + (1 - fgA) * bgG;
    CGFloat b = fgA * fgB + (1 - fgA) * bgB;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

+ (UIColor *)et_colorWithARGB:(NSInteger)ARGB {
    NSInteger alpha = (ARGB >> 24) & 0xFF;
    return [self et_colorWithHex:ARGB alpha:1.0 * alpha / 0xFF];
}
+ (NSInteger)et_ARGBFromColor:(UIColor *)color {
    CGFloat r = 0;
    CGFloat g = 0;
    CGFloat b = 0;
    CGFloat a = 0;
    
    NSInteger ARGB = 0;
    BOOL success = [color getRed:&r green:&g blue:&b alpha:&a];
    if (success) {
        NSInteger alpha =   (NSInteger)round(a * 0xFF) << 24;
        NSInteger red   =   (NSInteger)round(r * 0xFF) << 16;
        NSInteger green =   (NSInteger)round(g * 0xFF) << 8;
        NSInteger blue  =   (NSInteger)round(b * 0xFF);
        
        ARGB = alpha | red | green | blue;
    }
    return ARGB;
}

+ (UIColor *)et_colorWithHue:(CGFloat)hue saturation:(CGFloat)saturation lightness:(CGFloat)lightness {
    return [self et_colorWithHue:hue saturation:saturation lightness:lightness alpha:1];
}

+ (UIColor *)et_colorWithHue:(CGFloat)hue saturation:(CGFloat)saturation lightness:(CGFloat)lightness alpha:(CGFloat)alpha {
    hue = hue - (int)(hue / 360) * 360;
    hue += hue < 0 ? 360 : 0;
    saturation = MIN(1, MAX(0, saturation));
    lightness = MIN(1, MAX(0, lightness));
    alpha = MIN(1, MAX(0, alpha));
    
    CGFloat r = 0, g = 0, b = 0;
    CGFloat h = hue, s = saturation, l = lightness;
    if (s <= 0) {
        r = g = b = l;
    } else {
        CGFloat tempRGB[3];
        CGFloat q = l < 0.5 ? (l * (1 + s)) : (l + s - (l * s));
        CGFloat p = 2 * l - q;
        h = h / 360;
        
        tempRGB[0] = h + 1.0 / 3.0;
        tempRGB[1] = h;
        tempRGB[2] = h - 1.0 / 3.0;
        
        for (int i = 0; i < 3; i++) {
            tempRGB[i] += tempRGB[i] < 0.0 ? 1 : 0;
            tempRGB[i] -= tempRGB[i] > 1.0 ? 1 : 0;
            
            if (6.0 * tempRGB[i] < 1.0) {
                tempRGB[i] = p + (q - p) * 6.0 * tempRGB[i];
            } else {
                if (2.0 * tempRGB[i] < 1.0) {
                    tempRGB[i] = q;
                } else {
                    if (3.0 * tempRGB[i] < 2.0) {
                        tempRGB[i] = p + (q - p) * ((2.0 / 3.0) - tempRGB[i]) * 6.0;
                    } else {
                        tempRGB[i] = p;
                    }
                }
            }
        }
        r = MIN(1, MAX(0, tempRGB[0]));
        g = MIN(1, MAX(0, tempRGB[1]));
        b = MIN(1, MAX(0, tempRGB[2]));
    }
    
    return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}

- (BOOL)et_getHue:(CGFloat *)hue saturation:(CGFloat *)saturation lightness:(CGFloat *)lightness alpha:(CGFloat *)alpha {
    CGFloat r, g, b, a;
    CGFloat h = 0, s = 0, l = 0;
    if ([self getRed:&r green:&g blue:&b alpha:&a]) {
        CGFloat max = MAX(MAX(r, g), b);
        CGFloat min = MIN(MIN(r, g), b);
        if (max == min) {
            h = 0;
        } else if (max == r && g >= b) {
            h = 60 * ((g - b) / (max - min));
        } else if (max == r && g < b) {
            h = 60 * ((g - b) / (max - min)) + 360;
        } else if (max == g) {
            h = 60 * ((b - r) / (max - min)) + 120;
        } else if (max == b) {
            h = 60 * ((r - g) / (max - min)) + 240;
        }
        
        l = (max + min) / 2.0;
        
        if (l == 0 || max == min) {
            s = 0;
        } else if (l > 0 && l <= 1.0 / 2.0) {
            s = (max - min) / (2 * l);
        } else {
            s = (max - min) / (2 - 2 * l);
        }
        
        
        if (hue != NULL) {
            *hue = h;
        }
        if (saturation != NULL) {
            *saturation = s;
        }
        if (lightness != NULL) {
            *lightness = l;
        }
        if (alpha != NULL) {
            *alpha = a;
        }
        
        return YES;
    } else {
        return NO;;
    }
}

+ (UIColor *)et_colorWithHex:(NSUInteger)hexColor {
    return [self et_colorWithHex:hexColor alpha:1.f];
}

+ (UIColor *)et_colorWithHex:(NSUInteger)hexColor alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:1.f * (hexColor >> 16 & 0xff) / 0xff
                           green:1.f * (hexColor >>  8 & 0xff) / 0xff
                            blue:1.f * (hexColor >>  0 & 0xff) / 0xff
                           alpha:alpha];
}

+ (UIColor *)et_colorWithARGBHexString:(NSString *)hexString {
    if ([hexString hasPrefix:@"#"]) {
        hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    }
    
    // ARGB
    if (hexString.length == 4) {
        NSUInteger value = 0;
        if (sscanf(hexString.UTF8String, "%tx", &value)) {
            NSUInteger a, r, g, b;
            a = (value & 0xf000) >> 12;
            r = (value & 0x0f00) >> 8;
            g = (value & 0x00f0) >> 4;
            b = (value & 0x000f) >> 0;
            return [UIColor colorWithRed:1. * r / 0xf
                                   green:1. * g / 0xf
                                    blue:1. * b / 0xf
                                   alpha:1. * a / 0xf];
        }
        return nil;
    }
    // AARRGGBB
    else if (hexString.length == 8) {
        NSUInteger value = 0;
        if (sscanf(hexString.UTF8String, "%tx", &value)) {
            return [self et_colorWithARGB:value];
        }
        return nil;
    }
    else {
        // RGB or RRGGBB
        return [self et_colorWithHexString:hexString alpha:1.f];
    }
}

+ (UIColor *)et_colorWithHexString:(NSString *)hexString {
    return [self et_colorWithHexString:hexString alpha:1.f];
}

+ (UIColor *)et_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    if ([hexString hasPrefix:@"#"]) {
        hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    }
    
    if (hexString.length == 3) {
        NSUInteger value = 0;
        if (sscanf(hexString.UTF8String, "%tx", &value)) {
            NSUInteger r, g, b;
            r = (value & 0x0f00) >> 8;
            g = (value & 0x00f0) >> 4;
            b = (value & 0x000f) >> 0;
            return [UIColor colorWithRed:1.f * (r) / 0x0f
                                   green:1.f * (g) / 0x0f
                                    blue:1.f * (b) / 0x0f
                                   alpha:alpha];
        }
        return nil;
    }
    else if (hexString.length == 6) {
        NSUInteger value = 0;
        if (sscanf(hexString.UTF8String, "%tx", &value)) {
            return [self et_colorWithHex:value alpha:alpha];
        }
        return nil;
    }
    else {
        return nil;
    }
}

- (UIColor *)et_colorByDarken:(CGFloat)ratio {
    CGFloat hue, saturation, brightness, alpha;
    
    if ([self getHue:&hue
          saturation:&saturation
          brightness:&brightness
               alpha:&alpha]) {
        brightness *= (1.f - ratio);
        return [UIColor colorWithHue:hue
                          saturation:saturation
                          brightness:brightness
                               alpha:alpha];
    }
    else if ([self getWhite:&hue
                      alpha:&alpha]) {
        hue *= (1.f - ratio);
        return [UIColor colorWithWhite:hue
                                 alpha:alpha];
    }
    return self;
}

- (UIColor *)et_colorByLighten:(CGFloat)ratio {
    CGFloat hue, saturation, brightness, alpha;
    
    if ([self getHue:&hue
          saturation:&saturation
          brightness:&brightness
               alpha:&alpha]) {
        brightness = (1.f - ratio) * brightness + ratio;
        return [UIColor colorWithHue:hue
                          saturation:saturation
                          brightness:brightness
                               alpha:alpha];
    }
    else if ([self getWhite:&hue
                      alpha:&alpha]) {
        hue = (1.f - ratio) * hue + ratio;
        return [UIColor colorWithWhite:hue
                                 alpha:alpha];
    }
    return self;
}

- (UIColor *)et_HSLColorByLigten:(CGFloat)lightnessRatio {
    CGFloat h = 0, s = 0, l = 0, a = 0;
    if ([self et_getHue:&h saturation:&s lightness:&l alpha:&a]) {
        return [UIColor et_colorWithHue:h saturation:s lightness:l * lightnessRatio alpha:a];
    }
    return self;
}

- (UIColor *)et_colorByMultiplyAlpha:(CGFloat)alpha {
    CGFloat r, g, b, a;
    if ([self getRed:&r
               green:&g
                blue:&b
               alpha:&a]) {
        return [UIColor colorWithRed:r
                               green:g
                                blue:b
                               alpha:a * alpha];
    }
    else if ([self getWhite:&r
                      alpha:&a]) {
        return [UIColor colorWithWhite:r
                                 alpha:a * alpha];
    }
    return self;
}

+ (UIColor *)et_colorWithStart:(UIColor *)startColor endColor:(UIColor *)endColor ratio:(CGFloat)ratio {
    CGFloat rs = 0, gs = 0, bs = 0, as = 0;  //startColor
    CGFloat re = 0, ge = 0, be = 0, ae = 0;  //endColor
    [startColor getRed:&rs green:&gs blue:&bs alpha:&as];
    [endColor getRed:&re green:&ge blue:&be alpha:&ae];
    double r = rs + (re - rs) * ratio;
    double g = gs + (ge - gs) * ratio;
    double b = bs + (be - bs) * ratio;
    double a = as + (ae - as) * ratio;
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

@end
