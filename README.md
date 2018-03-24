# MJBarChart
A simple Line Chart for iOS.
一个二维半的柱状体图表，可以设置多种属性

项目中需要实现二维半的柱状图，还需要设置渐变色，最后封装成了这个组件。

1、效果图：


![Alt text](https://github.com/jingjingma1234/MJBarChart/raw/master/Screenshots/1.png)


2、介绍：


BarChartView为柱状图的视图类。


BarChartView.h文件公开了可设置的属性，可设置各种间距、各种颜色、各种文字大小等，已经设置默认值，需要自定义只要重新设置相应的属性即可。


需要特别说明的是m_ColorArr颜色数组，如果想要设置柱状体的渐变色，m_ColorArr的每一项都是一个多个渐变色组成的数组，demo中有实例，可以参考。


3、使用步骤：


    第一步：把BarChartView文件夹拖入到项目中。；
    
    
    第二步：导入头文件：#import "BarChartView.h"；
    
    
    第三步：创建对象，设置数据和属性，添加到视图上显示即可。
    
    
4、LICENSE


MIT
