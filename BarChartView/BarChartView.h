
//**********************************************
//
//文件名：BarChartView.h
//
//功能描述：柱状图
//
//**********************************************


#import <UIKit/UIKit.h>
#import "ZFPopoverLabel.h"

@interface BarChartView : UIView

@property (nonatomic,strong) NSArray * m_DataArr;  //数据集合(存储的为字符串形式)
@property (nonatomic,strong) NSArray * m_ColorArr;   //颜色集合
@property (nonatomic,strong) NSArray * m_NameLabelArr;  //x轴上名称集合


@property (nonatomic,assign) float m_GroupPadding;  //组之间的间距（默认是20.0f）
@property (nonatomic,assign) float m_BarPadding;  //柱状体之间的间距(默认是30.0f)
@property (nonatomic,assign) float m_NameLabelPadding;  //x轴坐标上的label离x轴的距离(默认是10.0f)
@property (nonatomic,assign) float m_NumLabelPadding;  //y轴坐标上的label离Y轴的距离(默认是10.0f)
@property (nonatomic,assign) float m_OneGroupPadding;  //X轴坐标上第一组离y轴的距离(默认是30.0f)
@property (nonatomic,assign) float m_BarLength;  //每个柱状体的宽度(默认是20.0f)

@property (nonatomic,strong) UIColor * m_AxisLineColor; //x,y坐标的颜色（默认为黑色）
@property (nonatomic,strong) UIColor * m_xTextColor;  //x轴上字体的颜色 (默认为黑色）
@property (nonatomic,strong) UIColor * m_yTextColor;  //y轴上字体的颜色 (默认为黑色）
@property (nonatomic,strong) UIColor * m_YDashedLineColor;   //y轴上的平行虚线的颜色（默认是浅灰色）
@property (nonatomic,strong) UIColor * m_BarTextColor;   //柱状体上文字的颜色（默认是黑色）
@property (nonatomic,strong) UIColor * m_BarBackColor;   //柱状体后面的背景颜色（默认是黑色）



@property (nonatomic,assign) CGFloat m_xLineNameFontSize;  //x轴上名称的字体大小（默认是10.f）
@property (nonatomic,assign) CGFloat m_YNumLabelFont; //y轴上数字label的字体大小(默认值为10.0f)
@property (nonatomic,assign) CGFloat m_BarTextFont;  //柱状体上文字的大小（默认是8）

@property (nonatomic,assign) NSInteger m_YSectionCount;  //y轴上总共有几段
@property (nonatomic,assign) float m_YMax;  //y轴上的最大值

@property (nonatomic,assign) float m_AxisLineWidth;   //坐标轴的线宽（默认是2）
@property (nonatomic,assign) float m_DashedLineWidth;   //平行虚线的线宽（默认是1）

@property (nonatomic,assign) float m_Angle;  //倾斜的角度(默认是60度)
@property (nonatomic,assign) float m_zScaleToBarWidth;   //柱状体z轴上的长度（相对于柱状体宽度的比例，默认是0.6）
@property (nonatomic,assign) kPopoverLabelPattern m_ValueLabelPattern;   //柱状体上文字样式（气泡还是空白 默认是气泡）
@property (nonatomic,assign) BOOL m_GradientColor;      //是否设置渐变颜色，默认渐变

@end

