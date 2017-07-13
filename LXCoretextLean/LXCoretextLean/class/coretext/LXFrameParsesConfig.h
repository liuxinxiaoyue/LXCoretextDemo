//
//  LXFrameParsesConfig.h
//  LXCoretextLean
//
//  Created by tang on 17/3/8.
//  Copyright © 2017年 tang. All rights reserved.
//
//  用于排版时的通用可配置项
//
//

#import <UIKit/UIKit.h>

@interface LXFrameParsesConfig : NSObject

/** view的宽度*/
@property (nonatomic, assign) CGFloat width;
/** view的高度*/
@property (nonatomic, assign) CGFloat height;
/** 文字的行高*/
@property (nonatomic, assign) CGFloat lineSpace;
@end
