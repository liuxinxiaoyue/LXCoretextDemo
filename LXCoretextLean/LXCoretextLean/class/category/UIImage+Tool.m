//
//  UIImage+Tool.m
//  ImageLean
//
//  Created by tang on 16/6/12.
//  Copyright © 2016年 tang. All rights reserved.
//

#import "UIImage+Tool.h"

@implementation UIImage (Tool)

- (UIImage *)waterMarkText:(NSString *)text inRect:(CGRect)rect{
    //1.获取上下文
    UIGraphicsBeginImageContext(self.size);
    
    //2.绘制图片
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];

    //3.绘制水印文字
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    
    style.alignment = NSTextAlignmentCenter;
    
    //文字的属性
    NSDictionary *dic = @{
                          
                          NSFontAttributeName:[UIFont systemFontOfSize:15],
                          
                          NSParagraphStyleAttributeName:style,
                          
                          NSForegroundColorAttributeName:[UIColor orangeColor],
                          
                          NSBackgroundColorAttributeName:[UIColor blueColor]
                          };
    
    //将文字绘制上去
    [text drawInRect:rect withAttributes:dic];

    //4.获取绘制到得图片
    UIImage *watermarkImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //5.结束图片的绘制
    UIGraphicsEndImageContext();
    return watermarkImage;
}

- (UIImage *)waterMarkImage:(UIImage *)waterImage inRect:(CGRect)rect{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    //原图
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    //水印图
    [waterImage drawInRect:rect];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newPic;
}

//截取部分图像
-(UIImage*)cropImage:(CGRect)rect{
//    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
//    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
//    
//    UIGraphicsBeginImageContext(smallBounds.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextDrawImage(context, smallBounds, subImageRef);
//    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
//    UIGraphicsEndImageContext();
    
//    return smallImage;
    CGImageRef sourceImageRef = [self CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    return [UIImage imageWithCGImage:newImageRef];
}

- (UIImage *)resizeImage:(CGSize)size{
    UIGraphicsBeginImageContext(self.size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)imageConvertInView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, view.layer.contentsScale);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:contextRef];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    return image;
}
@end
