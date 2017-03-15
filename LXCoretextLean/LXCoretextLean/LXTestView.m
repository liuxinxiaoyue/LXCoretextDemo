//
//  LXTestView.m
//  LXCoretextLean
//
//  Created by tang on 17/3/10.
//  Copyright © 2017年 tang. All rights reserved.
//

#import <CoreText/CoreText.h>
#import "LXTestView.h"
#import "UIView+LXExtension.h"

@implementation LXTestView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    // 获取cotext
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 翻转坐标系
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // 创建绘制区域
    UIBezierPath * path = [UIBezierPath bezierPathWithRect:self.bounds];
    UIBezierPath * cirP = [UIBezierPath bezierPathWithRect:CGRectMake(50, 50, 50, 50)];
    [path appendPath:cirP];
    
    //
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:@"hello worldhelloworldhelloworldhelloworldhelloworldhelloworldhelloworldhelloworldhellohello worldhelloworldhelloworldhelloworldhelloworldhelloworldhelloworldhelloworldhellohello worldhelloworldhelloworldhelloworldhelloworldhelloworldhelloworldhelloworldhellohello worldhelloworldhelloworldhelloworldhelloworldhelloworldhelloworldhellow"];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrStr);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attrStr.length), path.CGPath, NULL);
    
    //
    CTFrameDraw(frameRef, context);
    
    //
    CFRelease(frameRef);
    CFRelease(framesetter);
//    CFRelease(path);
}

@end
