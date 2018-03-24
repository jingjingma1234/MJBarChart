
//**********************************************
//
//文件名：BarChartView.h
//
//功能描述：柱状图
//
//**********************************************

#import "BarChartView.h"
#import "ZFConst.h"
#import "NSString+Zirkfied.h"

//动画的时间
#define ANIMATION_TIME 1.0
//Y轴的上边距
#define YAXIS_UP_PADDING 10
//y轴上最大值的那条线离y轴最上端的距离
#define YMAX_NUM_PADDING 10
//xy轴箭头的边长
#define ARROW_WIDTH 0
//X轴上文字最多几行
#define XLABEL_NUM 2
//右边的边距
#define RIGHT_PADDING 40

@interface BarChartView ()

@property (nonatomic,strong) UIColor * m_DefaultColor; //柱状体默认的颜色（默认是红色）

@property (nonatomic,assign) float m_XNameLabelMaxHeight; //x轴上文字的高
@property (nonatomic,assign) float m_YNumLabelMaxWidth;  //Y轴上文字最大的宽
@property (nonatomic,assign) float m_yNameLabelHeight;  //Y轴上数字的高

@property (nonatomic,strong) NSMutableArray * m_BarHeightArrNoGroup;  //柱状体高度集合（换算成当前y轴的高度的百分比高度）每组只有一个柱状体
@property (nonatomic,strong) NSMutableArray * m_BarHeightArr;  //柱状体高度集合（换算成当前y轴的高度的百分比高度）每组有大于一个的柱状体

@property (nonatomic,assign) NSInteger m_BarNumOfGroup;   //每一组柱状体的个数(默认是1)

@property (nonatomic,strong) NSMutableArray * m_XLabelSizeArr;   //x轴上名称的大小集合

@property (nonatomic,strong) NSMutableArray * m_XLabelOriginArr;  //x轴上的名称的起始点集合

@property (nonatomic,strong) NSMutableArray * m_YLabelOriginArr;   //y轴上的数值的起始点集合

@property (nonatomic,assign) float m_GroupLength;  //每组的宽度

@property (nonatomic,strong) NSMutableArray * m_YNumStrArr;  //y轴上的数字字符串集合

@property (nonatomic,strong) NSMutableArray * m_BarLabelArr;  //柱状体上的label的集合

@property (nonatomic,assign) float m_RealOnePadding;         //经过处理的第一个间距的距离

@property (nonatomic,assign) NSInteger m_GroupNum;  //总共组的个数

@end

@implementation BarChartView


/**
 系统方法，初始化方法
 
 @param frame frame
 @return 实例化对象
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //初始化数据
        [self InitData];
        
    }
    return self;
}


/**
 初始化默认的数据
 */
- (void)InitData
{
    _m_Angle = 60.0;
    self.backgroundColor = [UIColor whiteColor];
    self.m_DefaultColor = [UIColor redColor];
    self.m_BarNumOfGroup = 1;
    self.m_GroupPadding = 20.0;
    self.m_BarPadding = 30.0;
    self.m_NameLabelPadding = 10.0;
    self.m_AxisLineColor = [UIColor blackColor];
    self.m_xLineNameFontSize = 10.0;
    self.m_YNumLabelFont = 10.0;
    self.m_BarHeightArrNoGroup = [NSMutableArray arrayWithCapacity:0];
    self.m_BarHeightArr = [NSMutableArray arrayWithCapacity:0];
    self.m_BarLabelArr = [NSMutableArray arrayWithCapacity:0];
    self.m_BarLength = 20.0;
    self.m_NumLabelPadding = 10.0;
    self.m_AxisLineWidth = 1.5;
    self.m_XLabelSizeArr = [NSMutableArray arrayWithCapacity:0];
    self.m_XLabelOriginArr = [NSMutableArray arrayWithCapacity:0];
    self.m_YLabelOriginArr = [NSMutableArray arrayWithCapacity:0];
    self.m_xTextColor = [UIColor blackColor];
    self.m_yTextColor = [UIColor blackColor];
    self.m_YNumStrArr = [NSMutableArray arrayWithCapacity:0];
    self.m_OneGroupPadding = 30;
    self.m_YDashedLineColor = [UIColor lightGrayColor];
    self.m_DashedLineWidth = 1.0;
    self.m_zScaleToBarWidth = 0.6;
    self.m_BarTextFont = 8.0;
    self.m_GradientColor = YES;
    self.m_BarTextColor = [UIColor blackColor];
    self.m_ValueLabelPattern = kPopoverLabelPatternPopover;
    self.m_BarBackColor = [[UIColor colorWithRed:0.02 green:0.17 blue:0.26 alpha:1.00] colorWithAlphaComponent:0.6];
}

/**
 计算x轴y轴label的位置大小
 */
- (void)SetLabelWithHeight
{
    
    //纪录y轴上文字的大小
    NSString * yMaxNumStr = [NSString stringWithFormat:@"%.0f",self.m_YMax];
    CGRect rect = [yMaxNumStr stringWidthRectWithSize:self.bounds.size fontOfSize:self.m_YNumLabelFont isBold:NO];
    self.m_YNumLabelMaxWidth = rect.size.width;
    self.m_yNameLabelHeight = rect.size.height;
    
    //第一组柱状体离左边的距离
    float xPadding = self.m_YNumLabelMaxWidth + self.m_NumLabelPadding + self.m_RealOnePadding;
    
    //计算一组的长度
    float padding = RIGHT_PADDING;
    if (self.m_DataArr.count == 2)
    {
        padding = RIGHT_PADDING + 40;
    }
    self.m_GroupLength = (self.bounds.size.width - xPadding - self.m_NameLabelArr.count*self.m_GroupPadding)/self.m_NameLabelArr.count;
    //计算一个柱状体的宽度
    self.m_BarLength = (self.m_GroupLength - (self.m_BarNumOfGroup-1)*self.m_BarPadding)/self.m_BarNumOfGroup;
    
    //循环遍历，纪录x轴上名称的大小位置
    for (int i = 0;i < self.m_NameLabelArr.count;i++)
    {
        NSString * str = self.m_NameLabelArr[i];
        CGRect rect = [str stringWidthRectWithSize:CGSizeMake(self.bounds.size.width, self.bounds.size.height) fontOfSize:self.m_xLineNameFontSize isBold:NO];
        //纪录大小
        CGSize size = CGSizeMake(rect.size.width, rect.size.height);
        [self.m_XLabelSizeArr addObject:[NSValue valueWithCGSize:size]];
        //纪录位置
        CGFloat width = self.m_GroupLength+self.m_GroupPadding-6;
        CGFloat height = rect.size.height*XLABEL_NUM;
        CGFloat x = xPadding + (i + 0.5)*self.m_GroupLength - width/2 + self.m_GroupPadding*i;
        CGFloat y = self.bounds.size.height - rect.size.height*XLABEL_NUM;
        NSValue * value = [NSValue valueWithCGRect:CGRectMake(x, y, width, height)];
        [self.m_XLabelOriginArr addObject:value];
    }
    
    //y轴的0点的下边距
    float yPadding = self.m_XNameLabelMaxHeight + self.m_NameLabelPadding;
    //y轴上每段代表的距离
    float num = self.m_YMax/self.m_YSectionCount;
    //柱状体高度的最大值
    float totalHeight = self.bounds.size.height - self.m_XNameLabelMaxHeight - self.m_NameLabelPadding - YAXIS_UP_PADDING - YMAX_NUM_PADDING;
    //每段距离在y轴上代表的高度
    float heightNum = totalHeight / self.m_YSectionCount;
    [self.m_YNumStrArr addObject:@"0"];
    CGRect firstRect = [@"0" stringWidthRectWithSize:self.bounds.size fontOfSize:self.m_YNumLabelFont isBold:NO];
    [self.m_YLabelOriginArr addObject:[NSValue valueWithCGPoint:CGPointMake((self.m_YNumLabelMaxWidth-firstRect.size.width)/2, self.bounds.size.height - (yPadding +self.m_yNameLabelHeight/2))]];
    //遍历纪录y轴上的数值字符串和数值文字的原点的位置
    for (int i = 0; i < self.m_YSectionCount; i++)
    {
        //纪录y轴上的数值字符串
        NSString * str = [NSString stringWithFormat:@"%.0f",num*(i+1)];
        CGRect strRect = [str stringWidthRectWithSize:self.bounds.size fontOfSize:self.m_YNumLabelFont isBold:NO];
        [self.m_YNumStrArr  addObject:str];
        CGFloat y = self.bounds.size.height - (yPadding + (i+1)*heightNum+self.m_yNameLabelHeight/2);
        CGFloat x = (self.m_YNumLabelMaxWidth-strRect.size.width)/2;
        //纪录位置
        NSValue * value = [NSValue valueWithCGPoint:CGPointMake(x, y)];
        [self.m_YLabelOriginArr addObject:value];
    }
}

/**
 处理数据
 */
- (void)Deal_Data
{
    //清除上次的数据
    [self.m_XLabelSizeArr removeAllObjects];
    [self.m_XLabelOriginArr removeAllObjects];
    [self.m_YLabelOriginArr removeAllObjects];
    [self.m_YNumStrArr removeAllObjects];
    [self.m_BarHeightArrNoGroup removeAllObjects];
    [self.m_BarHeightArr removeAllObjects];
    
    
    //如果数据比较少，增加前面的距离
    self.m_RealOnePadding = self.m_OneGroupPadding;
    if (self.m_DataArr.count <= 3)
    {
        self.m_RealOnePadding = self.m_OneGroupPadding + 30;
    }
    
    //删除所有的字体label
    if (self.m_BarLabelArr.count>0)
    {
        for (ZFPopoverLabel * label in self.m_BarLabelArr)
        {
            [label removeFromSuperview];
        }
        [self.m_BarLabelArr removeAllObjects];
    }
    
    //计算x轴上文字名称的高度
    NSString * firstStr = [self.m_NameLabelArr firstObject];
    CGRect rect = [firstStr stringWidthRectWithSize:CGSizeMake(self.bounds.size.width, self.bounds.size.height) fontOfSize:self.m_xLineNameFontSize isBold:NO];
    self.m_XNameLabelMaxHeight = rect.size.height*XLABEL_NUM;
    
    id firstObject = [_m_DataArr firstObject];
    //柱状体高度的最大值
    float totalHeight = self.bounds.size.height - self.m_XNameLabelMaxHeight - self.m_NameLabelPadding - YAXIS_UP_PADDING - YMAX_NUM_PADDING;
    
    //处理数据
    //判断一组是单个还是多个
    if ([firstObject isKindOfClass:[NSString class]])
    {
        self.m_BarNumOfGroup = 1;
        //获取组的高度数据
        for (int i = 0; i < _m_DataArr.count; i++)
        {
            float height = [_m_DataArr[i] floatValue];
            float barHeight = height/_m_YMax*totalHeight;
            [self.m_BarHeightArrNoGroup addObject:[NSNumber numberWithFloat:barHeight]];
        }
    }
    else if([firstObject isKindOfClass:[NSArray class]])   //一组有多个
    {
        //循环获取柱状体换算之后的高度
        for (int i = 0; i < _m_DataArr.count; i++)
        {
            NSArray * arr = _m_DataArr[i];
            NSMutableArray * mArr = [NSMutableArray arrayWithCapacity:0];
            self.m_BarNumOfGroup = arr.count;
            for (int j = 0; j < arr.count; j++)
            {
                float height = [arr[j] floatValue];
                float barHeight = height/_m_YMax*totalHeight;
                [mArr addObject:[NSNumber numberWithFloat:barHeight]];
            }
            [self.m_BarHeightArr addObject:mArr];
        }
    }
 
    
    [self SetLabelWithHeight];
    
}


/**
 绘制文字
 */
- (void)DrawText
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //绘制x轴上的文字
    for (int i = 0; i < self.m_NameLabelArr.count; i++)
    {
        NSString * nameStr = self.m_NameLabelArr[i];
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic[NSFontAttributeName] = [UIFont systemFontOfSize:self.m_xLineNameFontSize];
        dic[NSForegroundColorAttributeName] = self.m_xTextColor;
        dic[NSStrokeWidthAttributeName] = @0;
        
        if (self.m_XLabelOriginArr.count>=i+1)
        {
            CGRect rect = [self.m_XLabelOriginArr[i] CGRectValue];
            [self ToDrawTextWithRect:rect str:nameStr context:ctx];
        }
    }
    
    //绘制y轴上的文字
    for (int i = 0; i < self.m_YNumStrArr.count; i++)
    {
        NSString * numStr = self.m_YNumStrArr[i];
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic[NSFontAttributeName] = [UIFont systemFontOfSize:self.m_YNumLabelFont];
        dic[NSForegroundColorAttributeName] = self.m_yTextColor;
        dic[NSStrokeWidthAttributeName] = @0;
        if (self.m_YLabelOriginArr.count>=i+1)
        {
            CGPoint p = [self.m_YLabelOriginArr[i] CGPointValue];
            [numStr drawAtPoint:p withAttributes:dic];
        }
    }
}


/**
 绘制文字居中并换行的方法

 @param rect1 绘制文字的范围
 @param str1 绘制的文字内容
 @param context 图形上下文
 */
- (void)ToDrawTextWithRect:(CGRect)rect1 str:(NSString*)str1 context:(CGContextRef)context
{
    if( str1 == nil || context == nil)
        return;
    
    CGContextSetLineWidth(context, 1.0);
    CGContextSetRGBFillColor (context, 0.01, 0.01, 0.01, 1);
    
    //段落格式
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    textStyle.alignment = NSTextAlignmentCenter;//水平居中
    //字体
    UIFont * font = [UIFont boldSystemFontOfSize:self.m_xLineNameFontSize];
    //构建属性集合
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:textStyle,NSForegroundColorAttributeName:self.m_xTextColor};
    
    [str1 drawInRect:rect1 withAttributes:attributes];
}


/**
 画坐标轴
 */
- (void)DrawAxis
{
    //x轴
    CGFloat x = self.m_YNumLabelMaxWidth + self.m_NumLabelPadding;
    CGFloat y = self.bounds.size.height-(self.m_XNameLabelMaxHeight + self.m_NameLabelPadding);
    //获取原点的位置
    CGPoint Origin = CGPointMake(x,y);
    
    //绘制背景颜色
    //柱状体高度的最大值
    float totalHeight = self.bounds.size.height - self.m_XNameLabelMaxHeight - self.m_NameLabelPadding - YAXIS_UP_PADDING - YMAX_NUM_PADDING;
    UIBezierPath * backPath = [UIBezierPath bezierPathWithRect:CGRectMake(Origin.x, YAXIS_UP_PADDING+YMAX_NUM_PADDING+ARROW_WIDTH,self.bounds.size.width - ARROW_WIDTH , totalHeight)];
    [self.m_BarBackColor set];
    [backPath fill];
    
      //画x轴
    UIBezierPath * xpath = [UIBezierPath bezierPath];
    [xpath moveToPoint:Origin];
    [xpath addLineToPoint:CGPointMake(self.bounds.size.width - ARROW_WIDTH, y)];
    [self.m_AxisLineColor set];
    xpath.lineWidth = self.m_AxisLineWidth;
    [xpath stroke];
    //画x轴上的箭头
//    UIBezierPath * arrowXpath = [UIBezierPath bezierPath];
//    [arrowXpath moveToPoint:CGPointMake(self.bounds.size.width - ARROW_WIDTH,y-ARROW_WIDTH/2)];
//    [arrowXpath addLineToPoint:CGPointMake(self.bounds.size.width, y)];
//    [arrowXpath addLineToPoint:CGPointMake(self.bounds.size.width - ARROW_WIDTH, y+ARROW_WIDTH/2)];
//    [self.m_AxisLineColor set];
//    [arrowXpath fill];
    
    //画y轴
    UIBezierPath * ypath = [UIBezierPath bezierPath];
    [ypath moveToPoint:Origin];
    [ypath addLineToPoint:CGPointMake(x, ARROW_WIDTH+YAXIS_UP_PADDING)];
    [self.m_AxisLineColor set];
    ypath.lineWidth = self.m_AxisLineWidth;
    [ypath stroke];
    
    //画圆点
    UIBezierPath * circlePath = [UIBezierPath bezierPathWithArcCenter:Origin radius:2.5 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    [self.m_AxisLineColor set];
    [circlePath fill];
    
    
    
    //画y轴上的箭头
//    UIBezierPath * arrowYpath = [UIBezierPath bezierPath];
//    [arrowYpath moveToPoint:CGPointMake(x-ARROW_WIDTH/2,ARROW_WIDTH+YAXIS_UP_PADDING)];
//    [arrowYpath addLineToPoint:CGPointMake(x, YAXIS_UP_PADDING)];
//    [arrowYpath addLineToPoint:CGPointMake(x+ARROW_WIDTH/2, ARROW_WIDTH+YAXIS_UP_PADDING)];
//    [self.m_AxisLineColor set];
//    [arrowYpath fill];
    
    //画z轴
//    UIBezierPath * zPath = [UIBezierPath bezierPath];
//    [zPath moveToPoint:Origin];
//    CGFloat lineX = self.m_OneGroupPadding+self.m_YNumLabelMaxWidth+self.m_NumLabelPadding;
//    CGFloat lineY = self.bounds.size.height - self.m_OneGroupPadding*ZFTan(self.m_Angle) - self.m_XNameLabelMaxHeight - self.m_NameLabelPadding;
//    [zPath addLineToPoint:CGPointMake(lineX, lineY)];
//    [[self.m_AxisLineColor colorWithAlphaComponent:0.3] set];
//    CGFloat dash[] = {3,3};
//    [zPath setLineDash:dash count:2 phase:0];
//    zPath.lineWidth = self.m_AxisLineWidth;
//    [zPath stroke];
}


/**
 画y轴上的平行的虚线
 */
- (void)DrawDashedLine
{
    //柱状体高度的最大值
    float totalHeight = self.bounds.size.height - self.m_XNameLabelMaxHeight - self.m_NameLabelPadding - YAXIS_UP_PADDING - YMAX_NUM_PADDING;
    //每段距离在y轴上代表的高度
    float heightNum = totalHeight / self.m_YSectionCount;
    //循环画虚线
    for (int i = 0; i < self.m_YSectionCount; i++)
    {
        //创建路径
        UIBezierPath * linePath = [UIBezierPath bezierPath];
        CGFloat x = self.m_YNumLabelMaxWidth + self.m_NumLabelPadding+ self.m_AxisLineWidth/2;
        //绘制路径
        [linePath moveToPoint:CGPointMake(x, self.bounds.size.height - self.m_XNameLabelMaxHeight-self.m_NameLabelPadding-heightNum*(i+1))];
        [linePath addLineToPoint:CGPointMake(self.bounds.size.width-ARROW_WIDTH, self.bounds.size.height - self.m_XNameLabelMaxHeight-self.m_NameLabelPadding-heightNum*(i+1))];
        //渲染颜色
        [self.m_YDashedLineColor set];
        //绘制虚线
//        const CGFloat dash[] = {3,3};
//        [linePath setLineDash:dash count:2 phase:0];
        linePath.lineWidth = self.m_DashedLineWidth;
        [linePath stroke];
    }
}


/**
 画柱状体
 */
- (void)DrawBars
{
    
    //获取图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //判断一组里面有一个还是多个柱状体
    if (self.m_BarNumOfGroup == 1)
    {
        for (int i = 0; i < self.m_DataArr.count; i++)
        {
            //计算每个柱状体的位置和大小
            CGFloat width = self.m_BarLength;
            CGFloat height = [self.m_BarHeightArrNoGroup[i] floatValue];
            CGFloat x = self.m_YNumLabelMaxWidth+self.m_NumLabelPadding+self.m_RealOnePadding+self.m_BarLength*i+self.m_GroupPadding*i;
            CGFloat y = self.bounds.size.height - self.m_XNameLabelMaxHeight-self.m_NameLabelPadding-self.m_AxisLineWidth/2-height;
            //绘制的颜色
            NSArray * colorArr = @[self.m_DefaultColor];
            if (self.m_ColorArr.count-1>=i)
            {
                colorArr = self.m_ColorArr[i];
            }
            
            //文本内容
            NSString * str = _m_DataArr[i];
            //绘制
            [self DrawSingleBarWithRect:CGRectMake(x, y, width, height) colorArr:colorArr contextRef:ctx withText:str];
            
        }
    }
    else   //每组有多个柱状体
    {
        //循环遍历第一层数组，数组里面是每组的数据
        for (int i = 0; i < self.m_BarHeightArr.count; i++)
        {
            NSArray * barArr = self.m_BarHeightArr[i];
            //循环遍历每组的数据
            for (int j = 0; j < barArr.count; j++)
            {
                //计算每个柱状体的位置大小
                CGFloat width = self.m_BarLength;
                CGFloat x = self.m_YNumLabelMaxWidth+self.m_NumLabelPadding+self.m_RealOnePadding+self.m_GroupPadding*i+i*(self.m_BarLength*self.m_BarHeightArr.count+(self.m_BarHeightArr.count-1)*self.m_BarPadding)+j*(self.m_BarLength+self.m_BarPadding);
                CGFloat height = [self.m_BarHeightArr[i][j] floatValue];
                CGFloat y = self.bounds.size.height - self.m_XNameLabelMaxHeight-self.m_NameLabelPadding-self.m_AxisLineWidth/2-height;
                //绘制的颜色
                NSArray * colorArr = @[self.m_DefaultColor];
                if (self.m_ColorArr.count-1>=j)
                {
                    colorArr = self.m_ColorArr[j];
                }
                //文本内容
                NSString * str = _m_DataArr[i][j];
                //绘制
                [self DrawSingleBarWithRect:CGRectMake(x, y, width, height) colorArr:colorArr contextRef:ctx withText:str];
                
            }
        }
    }
    
    
}


/**
 绘制单个柱状体的方法
 
 @param rect 绘制的位置范围
 @param colorArr 渲染的渐变颜色数组（开始颜色和结束颜色）
 @param ctx 图形上下文
 @param text 柱状体上的文本内容
 */
- (void)DrawSingleBarWithRect:(CGRect)rect colorArr:(NSArray *)colorArr contextRef:(CGContextRef)ctx withText:(NSString *)text
{
    
    //获取位置大小
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y;
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    UIColor * startColor = nil;
    UIColor * endColor = nil;
    UIColor * middleColor = nil;
    //获取渐变开始的颜色和结束的颜色
    if (colorArr.count==1)
    {
        startColor = [colorArr firstObject];
        middleColor = startColor;
        endColor = startColor;
    }
    else if(colorArr.count==2)
    {
        startColor = [colorArr firstObject];
        middleColor = colorArr[1];
        endColor = colorArr[1];
    }
    else if (colorArr.count == 3)
    {
        startColor = colorArr[0];
        middleColor = colorArr[1];
        endColor = colorArr[2];
    }
    
    //画矩形柱体
    UIBezierPath * path = [UIBezierPath bezierPathWithRect:CGRectMake(x, y, width, height)];
    if (startColor != nil)
    {
        [startColor setFill];
    }
    [[UIColor colorWithWhite:1.0 alpha:0.8] setStroke];
    //添加到图形上下文
    CGContextAddPath(ctx, path.CGPath);
    CGContextFillPath(ctx);
    
    //颜色渐变
   
    [self DrawLinearGradient:ctx path:path.CGPath startColor:startColor.CGColor middleColor:middleColor.CGColor endColor:endColor.CGColor];
    
    
    //绘制右边的四边形
    UIBezierPath * rightPath = [UIBezierPath bezierPath];
    //绘制路径
    [rightPath moveToPoint:CGPointMake(x + width, y+height)];
    [rightPath addLineToPoint:CGPointMake(x + width + width * self.m_zScaleToBarWidth * ZFCos(_m_Angle), y+height - width * self.m_zScaleToBarWidth*ZFSin(_m_Angle))];
    [rightPath addLineToPoint:CGPointMake(x + width + width * self.m_zScaleToBarWidth * ZFCos(_m_Angle), y-width * self.m_zScaleToBarWidth*ZFSin(_m_Angle))];
    [rightPath addLineToPoint:CGPointMake(x + width, y+height - height)];
    [rightPath addLineToPoint:CGPointMake(x + width, y+height)];
    //添加到图形上下文
    CGContextAddPath(ctx, rightPath.CGPath);
    //颜色渲染
    if (startColor!= nil)
    {
        [startColor setFill];
    }
    [[UIColor colorWithWhite:0.9 alpha:1.0] setStroke];
    CGContextDrawPath(ctx, kCGPathFill);
    [[UIColor colorWithWhite:0.3 alpha:0.4] setFill];
    CGContextAddPath(ctx, rightPath.CGPath);
    CGContextDrawPath(ctx, kCGPathFill);
    //颜色渐变
    [self DrawLinearGradient:ctx path:rightPath.CGPath startColor:[UIColor colorWithWhite:0.4 alpha:0.5].CGColor middleColor:[UIColor colorWithWhite:0.1 alpha:0.45].CGColor endColor:[UIColor colorWithWhite:0.05 alpha:0.6].CGColor];
    
    //绘制上面的四边形
    UIBezierPath * upPath = [UIBezierPath bezierPath];
    //绘制路径
    [upPath moveToPoint:CGPointMake(x, y)];
    [upPath addLineToPoint:CGPointMake(x + width, y)];
    [upPath addLineToPoint:CGPointMake(x + width + width * self.m_zScaleToBarWidth * ZFCos(_m_Angle), y+height - width * self.m_zScaleToBarWidth*ZFSin(_m_Angle) - height)];
    [upPath addLineToPoint:CGPointMake(x + width * self.m_zScaleToBarWidth * ZFCos(_m_Angle), y - width * self.m_zScaleToBarWidth * ZFSin(_m_Angle))];
    [upPath addLineToPoint:CGPointMake(x, y)];
    //添加到图形上下文
    CGContextAddPath(ctx, upPath.CGPath);
    //颜色渲染
    if (startColor!= nil)
    {
        [startColor setFill];
    }
    [[UIColor colorWithWhite:0.9 alpha:1.0] setStroke];
    CGContextDrawPath(ctx, kCGPathFill);
    [[UIColor colorWithWhite:0.4 alpha:0.4] setFill];
    CGContextAddPath(ctx, upPath.CGPath);
    CGContextDrawPath(ctx, kCGPathFill);
    
    //文本绘制
    
    //计算文字的预估大小
    CGRect textRect = [text stringWidthRectWithSize:self.bounds.size fontOfSize:self.m_BarTextFont isBold:NO];
    //创建气泡控件
    ZFPopoverLabel * popoverLabel = [[ZFPopoverLabel alloc] initWithFrame:CGRectMake(x+width/2-textRect.size.width/2-7+width * self.m_zScaleToBarWidth * ZFCos(_m_Angle), y-width * self.m_zScaleToBarWidth * ZFSin(_m_Angle)-textRect.size.height-15, textRect.size.width + 14, textRect.size.height + 8) direction:kAxisDirectionVertical];
    //设置属性
    popoverLabel.text = text;
    popoverLabel.font = [UIFont systemFontOfSize:self.m_BarTextFont];
    popoverLabel.arrowsOrientation = kPopoverLaberArrowsOrientationOnBelow;
    popoverLabel.pattern = self.m_ValueLabelPattern;
    popoverLabel.textColor = self.m_BarTextColor;
    popoverLabel.isShadow = YES;
    popoverLabel.isAnimated = YES;
    popoverLabel.shadowColor = [UIColor blackColor];
    //绘制
    [popoverLabel strokePath];
    [self addSubview:popoverLabel];
    [self.m_BarLabelArr addObject:popoverLabel];
    
}


/**
 颜色渐变
 
 @param context 图形上下文
 @param path 路径
 @param startColor 开始颜色
 @param endColor 结束颜色
 */
- (void)DrawLinearGradient:(CGContextRef)context
                      path:(CGPathRef)path
                startColor:(CGColorRef)startColor
               middleColor:(CGColorRef)middleColor
                  endColor:(CGColorRef)endColor
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //几种颜色所占的比例
    CGFloat locations[] = { 0.3,0.6,1};
    //颜色集合
    NSArray *colors = @[(__bridge id) startColor,(__bridge id) middleColor,(__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    if (self.m_GradientColor == YES)
    {
        //具体方向可根据需求修改
        CGPoint startPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMinY(pathRect));
        CGPoint endPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
        
        CGContextSaveGState(context);
        CGContextAddPath(context, path);
        CGContextClip(context);
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
        CGContextRestoreGState(context);
        
        CGGradientRelease(gradient);
    }
   
    CGColorSpaceRelease(colorSpace);
}


/**
 系统绘制方法
 
 @param rect 绘制的范围
 */
- (void)drawRect:(CGRect)rect
{
    //处理数据
    [self Deal_Data];
    
    //绘制文字
    [self DrawText];
    
    //画坐标轴
    [self DrawAxis];
    
    //画y轴上的平行的虚线
    [self DrawDashedLine];
    
    //画柱状体
    [self DrawBars];
    
}


@end

