//
//  LXCalculateRectUtils.m
//  LXCoretextLean
//
//  Created by tang on 17/3/15.
//  Copyright © 2017年 tang. All rights reserved.
//

#import "LXCalculateRectUtils.h"

#import "UIView+LXExtension.h"

@implementation LXCalculateRectUtils

+ (CFIndex )indexTouchView:(UIView *)view point:(CGPoint)point frameRef:(CTFrameRef)frameRef truncationLine:(CTLineRef)trunLineRef offsetY:(CGFloat)offset {
    CFArrayRef lines = CTFrameGetLines(frameRef);
    if (lines == nil) {
        return -1;
    }
    CFIndex count = CFArrayGetCount(lines);
    
    //获得每一行的origin坐标
    CGPoint origins[count];
    CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), origins);
    
    //翻转坐标系
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, view.height);
    transform = CGAffineTransformScale(transform, 1, -1);

    for (int i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        linePoint.y += offset;
        CTLineRef lineRef = CFArrayGetValueAtIndex(lines, i);
        if (i == count - 1 && trunLineRef) {
            lineRef = trunLineRef;
        }
        //获得每一行的CGRect信息
        CGRect lineRect = [LXCalculateRectUtils getLineBounds:lineRef originPoint:linePoint];
        CGRect rect = CGRectApplyAffineTransform(lineRect, transform);
        
        if (CGRectContainsPoint(rect, point)) {
            // 将点击的坐标转换成相对于当前行的坐标
            CGPoint relativePoint = CGPointMake(point.x - CGRectGetMinX(rect), point.y - CGRectGetMinY(rect));
            
            // 获得当前点击坐标对应的字符串偏移
            CFIndex index = CTLineGetStringIndexForPosition(lineRef, relativePoint);
            //            NSLog(@"%ld", index);
            // 判断偏移的类型
            return index;
        }
    }
    return -1;
}

+ (CGRect)getLineBounds:(CTLineRef)lineRef originPoint:(CGPoint)point {
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading= 0.0f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(lineRef, &ascent, &descent, &leading);
    CGFloat height = ascent + descent;
    return CGRectMake(point.x, point.y - descent, width, height);
}

+ (CGRect)getRunBounds:(CTRunRef)runRef lineRef:(CTLineRef)lineRef originPoint:(CGPoint)point {
    CGRect runBounds;
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    runBounds.size.width = CTRunGetTypographicBounds(runRef, CFRangeMake(0, 0), &ascent, &descent, &leading);
    runBounds.size.height = ascent + descent;
    CGFloat xOffset = CTLineGetOffsetForStringIndex(lineRef, CTRunGetStringRange(runRef).location, NULL);
    runBounds.origin.x = point.x + xOffset;
    runBounds.origin.y = point.y - descent;
    return runBounds;
}
@end
