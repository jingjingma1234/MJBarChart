
//**********************************************
//
//文件名：NSString+Zirkfied.h
//
//功能描述：计算字符串的宽度
//
//作者：马晶
//
//日期：2017-01-10
//
//**********************************************


#import "NSString+Zirkfied.h"

@implementation NSString (Zirkfied)

/**
 *  计算字符串宽度(指当该字符串放在view时的自适应宽度)
 *
 *  @param size 填入预留的大小
 *  @param fontOfSize 字体大小
 *  @param isBold 字体是否加粗
 *
 *  @return 返回CGRect
 */
- (CGRect)stringWidthRectWithSize:(CGSize)size fontOfSize:(CGFloat)fontOfSize isBold:(BOOL)isBold{
    NSDictionary * attributes;
    if (isBold) {
        attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:fontOfSize]};
    }else{
        attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:fontOfSize]};
    }
    
    return [self boundingRectWithSize:size options:NSStringDrawingUsesFontLeading attributes:attributes context:nil];
}

@end
