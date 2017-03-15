//
//  LXDealEventManager.m
//  LXCoretextLean
//
//  Created by tang on 17/3/10.
//  Copyright © 2017年 tang. All rights reserved.
//

#import <CoreText/CoreText.h>

#import "LXDealEventManager.h"

#import "UIView+LXExtension.h"

@implementation LXDealEventManager

+ (CFIndex )indexTouchView:(UIView *)view point:(CGPoint)point atCoretexDataManager:(LXCoretextDataManager *)manager {
    CTFrameRef frameRef = manager.frameRef;
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
        CTLineRef lineRef = CFArrayGetValueAtIndex(lines, i);
        
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
@end
