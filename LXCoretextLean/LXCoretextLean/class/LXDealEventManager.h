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
@end
