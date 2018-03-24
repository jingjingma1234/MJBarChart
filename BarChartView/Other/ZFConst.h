
//**********************************************
//
//文件名：ZFConst.h
//
//功能描述：定义一些常量值
//
//作者：马晶
//
//日期：2017-01-10
//
//**********************************************

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "ZFColor.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

/**
 *  角度求三角函数sin值
 *  @param a 角度
 */
#define ZFSin(a) sin(a / 180.f * M_PI)

/**
 *  角度求三角函数cos值
 *  @param a 角度
 */
#define ZFCos(a) cos(a / 180.f * M_PI)

/**
 *  角度求三角函数tan值
 *  @param a 角度
 */
#define ZFTan(a) tan(a / 180.f * M_PI)

/**
 *  弧度转角度
 *  @param radian 弧度
 */
#define ZFAngle(radian) (radian / M_PI * 180.f)

/**
 *  角度转弧度
 *  @param angle 角度
 */
#define ZFRadian(angle) (angle / 180.f * M_PI)


/**
 *  坐标轴起点x值
 */
extern CGFloat const ZFAxisLineStartXPos;

/**
 *  坐标轴 label tag值
 */
extern NSInteger const ZFAxisLineValueLabelTag;

/**
 *  坐标轴 item宽度
 */
extern CGFloat const ZFAxisLineItemWidth;

/**
 *  坐标轴 组与组之间的间距
 */
extern CGFloat const ZFAxisLinePaddingForGroupsLength;

/**
 *  坐标轴 bar与bar之间间距
 */
extern CGFloat const ZFAxisLinePaddingForBarLength;

/**
 *  坐标轴最大上限值到箭头的间隔距离
 */
extern CGFloat const ZFAxisLineGapFromAxisLineMaxValueToArrow;

/**
 *  坐标轴分段线长度
 */
extern CGFloat const ZFAxisLineSectionLength;

/**
 *  坐标轴分段线高度
 */
extern CGFloat const ZFAxisLineSectionHeight;

/**
 *  开始系数(上方)
 */
extern CGFloat const ZFAxisLineStartRatio;

/**
 *  结束系数(下方)
 */
extern CGFloat const ZFAxisLineVerticalEndRatio;

/**
 *  横向坐标轴结束系数(下方)
 */
extern CGFloat const ZFAxisLineHorizontalEndRatio;

/**
 *  线状图圆的半径
 */
extern CGFloat const ZFLineChartCircleRadius;

/**
 *  饼图百分比label Tag值
 */
extern NSInteger const ZFPieChartPercentLabelTag;

/**
 *  导航栏高度
 */
extern CGFloat const NAVIGATIONBAR_HEIGHT;

/**
 *  tabBar高度
 */
extern CGFloat const TABBAR_HEIGHT;

/**
 *  topic高度
 */
extern CGFloat const TOPIC_HEIGHT;


/**
 *  线状图, 波浪图上的value的位置
 */
typedef enum{
    kChartValuePositionDefalut = 0,//上下分布
    kChartValuePositionOnTop = 1,//上方
    kChartValuePositionOnBelow = 2//下方
}kChartValuePosition;

/**
 *  横向或竖向坐标轴
 */
typedef enum{
    kAxisDirectionVertical = 0,//垂直方向
    kAxisDirectionHorizontal = 1//水平方向
}kAxisDirection;

/**
 *  坐标轴
 */
typedef enum{
    kAxisLineValueTypeDecimal = 0,//保留有效小数
    kAxisLineValueTypeInteger = 1,//取整数形式(四舍五入)(默认)
}kAxisLineValueType;

@interface ZFConst : NSObject

@end
