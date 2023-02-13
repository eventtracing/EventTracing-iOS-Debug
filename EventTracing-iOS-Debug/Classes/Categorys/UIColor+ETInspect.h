//
//  UIColor+ETInspect.h
//  BlocksKit
//
//  Created by dl on 2021/5/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (ETInspect)
- (UIColor *)et_addOverlay:(UIColor *)color;

/**
 根据 argb 整形创建 color

 @param ARGB 0xFFAABBCC，即 alpha：FF，red：AA，green：BB，blue：CC
 @return return value description
 */
+ (UIColor *)et_colorWithARGB:(NSInteger)ARGB;

/**
 根据颜色返回 argb。

 @param color color description
 @return return 如果失败，返回 0
 */
+ (NSInteger)et_ARGBFromColor:(UIColor *)color;

/**
根据 HSL色彩空间创建 color

@param hue 色相 [0, 360]
@param saturation 饱和度 [0, 1]
@param lightness 亮度 [0, 1]
@return UIColor对象
*/

+ (UIColor *)et_colorWithHue:(CGFloat)hue
                  saturation:(CGFloat)saturation
                   lightness:(CGFloat)lightness;

/**
根据 HSL色彩空间创建 color

@param hue 色相 [0, 360) --会自动取值到[0,360)内，规则是a>360 ? 取余数：400->40，a<0？取余数再+360：-40-->320
@param saturation 饱和度 [0, 1] 会将值固定在[0,1]内，规则是a>1为1，a<0为0
@param lightness 亮度 [0, 1] 会将值固定在[0,1]内，规则是a>1为1，a<0为0
@param alpha 透明度 会将值固定在[0,1]内，规则是a>1为1，a<0为0
@return UIColor对象
*/
+ (UIColor *)et_colorWithHue:(CGFloat)hue
                  saturation:(CGFloat)saturation
                   lightness:(CGFloat)lightness
                       alpha:(CGFloat)alpha;


/**
根据 颜色color来获取其HSL色彩空间

@param hue  色相（引用） [0, 360)
@param saturation 饱和度（引用） [0, 1]
@param lightness 亮度（引用）  [0, 1]
@param alpha 透明度（引用）  [0, 1]
@return  // If the receiver is of a compatible color space, any non-NULL parameters are populated and 'YES' is returned. Otherwise, the parameters are left unchanged and 'NO' is returned.
*/
- (BOOL)et_getHue:(nullable CGFloat *)hue
       saturation:(nullable CGFloat *)saturation
        lightness:(nullable CGFloat *)lightness
            alpha:(nullable CGFloat *)alpha;

/**
 使用方法：使用 16 进制整型，比 NSString 快且节省空间。
 @code
 [UIColor et_colorWithHex:0xff33cc];
 @endcode

 @warning 短格式是不支持，如： 0xfff != 0xffffff，它相当于 0x000fff
 @param hexColor 16 进制的无符号整型
 @return 新的颜色实例
 */
+ (UIColor *)et_colorWithHex:(NSUInteger)hexColor;
+ (UIColor *)et_colorWithHex:(NSUInteger)hexColor alpha:(CGFloat)alpha;


/**
 通过一段 hex 字符串生成颜色，支持长格式 @"33ccff"，也支持短格式 @"3cf"，当包含非法字符时，
 返回 nil，如 @"xyz"

 @param hexString 十六进制字符串
 @return 新的颜色实例
 */
+ (UIColor *)et_colorWithHexString:(NSString *)hexString;
+ (UIColor *)et_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

/// 从字符串获取颜色，# ARGB / AARRGGBB / RGB / RRGGBB
/// @param hexString ARGB格式的颜色字符串
+ (UIColor *)et_colorWithARGBHexString:(NSString *)hexString;

/**
 将当前颜色调暗

 @param ratio 百分比，[0, 1]，0 为原颜色，1 为全黑
 @return 新颜色
 */
- (UIColor *)et_colorByDarken:(CGFloat)ratio;

/**
 将当前颜色调亮
 
 @param ratio 百分比，[0, 1]，0 为原颜色，1 为最亮（注意，不一定是白色）
 @return 新颜色
 */
- (UIColor *)et_colorByLighten:(CGFloat)ratio;


/**
将当前颜色以HSL格式调整亮度，即调整其lightness值

@param lightnessRatio 百分比
@return 新颜色
*/
- (UIColor *)et_HSLColorByLigten:(CGFloat)lightnessRatio;

/**
 将当前颜色的 alpha 乘以传入的 alpha 值作为新的 alpha

 @param alpha alpha 比率
 @return 新颜色值
 @warning 如果取不到当前颜色 alpha，则返回 self
 */
- (UIColor *)et_colorByMultiplyAlpha:(CGFloat)alpha;

/**
 从给的起点与终点颜色间，拿到percent（0，1）位置的颜色，用于做颜色平滑过渡

 @param startColor 起点颜色
 @param endColor 终点颜色
 @param ratio 位置比例
 @return 在startColor与endColor之间ratio处的颜色值
 */
+ (UIColor *)et_colorWithStart:(UIColor *)startColor endColor:(UIColor *)endColor ratio:(CGFloat)ratio;

@end


NS_ASSUME_NONNULL_END
