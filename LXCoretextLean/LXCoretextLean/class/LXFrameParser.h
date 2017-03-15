//
//  LXFrameParser.h
//  LXCoretextLean
//
//  Created by tang on 17/3/8.
//  Copyright © 2017年 tang. All rights reserved.
//
//  用于排版
//

#import <Foundation/Foundation.h>

@class LXCoretextDataManager,LXFrameParsesConfig;
@interface LXFrameParser : NSObject

+ (LXCoretextDataManager *)parserAttributString:(NSAttributedString *)content withConfig:(LXFrameParsesConfig *)config;
@end
