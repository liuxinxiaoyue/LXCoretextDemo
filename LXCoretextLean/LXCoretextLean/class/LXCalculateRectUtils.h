//
//  LXCalculateRectUtils.h
//  LXCoretextLean
//
//  Created by tang on 17/3/15.
//  Copyright © 2017年 tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface LXCalculateRectUtils : NSObject

/**
 每行CTLine的坐标
 
 @param lineRef CTLine
 @param point CTLine的原点
 @return 坐标
 */
+ (CGRect)getLineBounds:(CTLineRef)lineRef originPoint:(CGPoint)point;

/**
 CTLine中CTRun的坐标
 
 @param runRef CTRun
 @param lineRef CTLine
 @param point CTLine的原点
 @return 坐标
 */
+ (CGRect)getRunBounds:(CTRunRef)runRef lineRef:(CTLineRef)lineRef originPoint:(CGPoint)point;
@end
