//
//  LXDealEventManager.h
//  LXCoretextLean
//
//  Created by tang on 17/3/10.
//  Copyright © 2017年 tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXCoretextDataManager.h"

@interface LXDealEventManager : NSObject

/**
 获取点击point的在字符串中的偏移量

 @param view 视图
 @param point  点击点
 @param manager 数据管理
 @return 偏移量
 */
+ (CFIndex )indexTouchView:(UIView *)view point:(CGPoint)point atCoretexDataManager:(LXCoretextDataManager *)manager;

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
