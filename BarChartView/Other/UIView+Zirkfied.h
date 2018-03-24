
//**********************************************
//
//文件名：UIView+Zirkfied.h
//
//功能描述：自定义边框和设置阴影
//
//作者：马晶
//
//日期：2017-01-10
//
//**********************************************

#import <UIKit/UIKit.h>

@interface UIView (Zirkfied)

/**
 *  自定义边框
 *
 *  @param cornerRadius 角落半径
 *  @param borderWidth  边框宽度
 *  @param color        边框颜色
 */
-(void)setBorderCornerRadius:(CGFloat)cornerRadius andBorderWidth:(CGFloat)borderWidth andBorderColor:(UIColor *)color;

/**
 *  设置阴影
 */
- (void)setShadow:(UIColor *)color;

@end
