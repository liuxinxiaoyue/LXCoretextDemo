//
//  LXCalculateRectUtils.m
//  LXCoretextLean
//
//  Created by tang on 17/3/15.
//  Copyright © 2017年 tang. All rights reserved.
//

#import "LXCalculateRectUtils.h"

@implementation LXCalculateRectUtils

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
