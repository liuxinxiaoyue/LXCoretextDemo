//
//  LXFrameParser.m
//  LXCoretextLean
//
//  Created by tang on 17/3/8.
//  Copyright © 2017年 tang. All rights reserved.
//

#import <CoreText/CoreText.h>

#import "LXFrameParser.h"
#import "LXFrameParsesConfig.h"
#import "LXCoretextDataManager.h"

@implementation LXFrameParser

+ (LXCoretextDataManager *)parserAttributString:(NSAttributedString *)content withConfig:(LXFrameParsesConfig *)config {

    // 创建CTFramesetterRef
    CTFramesetterRef framesetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)content);
    
    // 获得要绘制的区域的高度
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetterRef, CFRangeMake(0, 0), nil, restrictSize, nil);
    CGFloat textHeight = coreTextSize.height;
    
    // 生成CTFrameRef
    CTFrameRef frameRef = [self createFrameRefWithFramesetter:framesetterRef config:config height:textHeight];
    
    // 将生成好的CTFrameRef 实例和计算好的绘制高度保存到 CoretextDataManager中
    LXCoretextDataManager *manager = [[LXCoretextDataManager alloc] init];
    manager.frameRef = frameRef;
    manager.height = textHeight;
    
    CFRelease(frameRef);
    CFRelease(framesetterRef);
    return manager;
}

+ (CTFrameRef)createFrameRefWithFramesetter:(CTFramesetterRef)framesetterRef config:(LXFrameParsesConfig *)config height:(CGFloat)height {

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, config.width, config.height));
    
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetterRef, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    return frameRef;
}
@end
