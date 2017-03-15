//
//  LXDisplayView.m
//  LXCoretextLean
//
//  Created by tang on 17/3/8.
//  Copyright © 2017年 tang. All rights reserved.
//

#import "LXDisplayView.h"

@interface LXDisplayView()

@property (nonatomic, assign) CGPoint touchPoint;
@property (nonatomic, assign) UITouchPhase touchPhase;
@property (nonatomic, assign) CFIndex touchIndex;
@property (nonatomic, assign) BOOL respondLink;
@end

@implementation LXDisplayView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    return self;
}

- (void)drawRect:(CGRect)rect {
    // 获取cotext
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 翻转坐标系
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CTFrameRef frameRef = self.manager.frameRef;
    if (frameRef == nil) {
        return;
    }

    [self drawFrameRef:frameRef context:context];
    
    for (LXImageContent *temp in self.manager.imgArray) {
        UIImage *image = [UIImage imageNamed:temp.imageName];
        if (image) {
            CGContextDrawImage(context, temp.imagePosition, image.CGImage);
        }
    }
}

- (void)drawFrameRef:(CTFrameRef)frameRef context:(CGContextRef)contextRef {
    // 获得CTLine
    CFArrayRef lineRefs = CTFrameGetLines(frameRef);
    CFIndex lineCount = CFArrayGetCount(lineRefs);
    CGPoint origins[lineCount];
    CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), origins);
    
    for (int i = 0; i < lineCount; i++) {
        //
        CTLineRef lineRef = CFArrayGetValueAtIndex(lineRefs, i);
        CFArrayRef runRefs = CTLineGetGlyphRuns(lineRef);
        CFIndex runCount = CFArrayGetCount(runRefs);
        for (int j = 0; j < runCount; j++) {
            // 获取CTRun
            CTRunRef runRef = CFArrayGetValueAtIndex(runRefs, j);
            CFRange range = CTRunGetStringRange(runRef);
            CGContextSetTextPosition(contextRef, origins[i].x, origins[i].y);
            
            // 获取CTRun属性
            NSDictionary *attDic = (NSDictionary *)CTRunGetAttributes(runRef);
            NSNumber *type = [attDic objectForKey:LXCustomeAttributeType];
            if (type == nil) {
                // 没有特殊处理
                CTRunDraw(runRef, contextRef, CFRangeMake(0, 0));
                continue;
            }
            
            // 计算绘制区域
            CGRect runBounds = [LXDealEventManager getRunBounds:runRef lineRef:lineRef originPoint:origins[i]];
            
            NSInteger typeValue = type.integerValue;
            if (typeValue == LXAttributeTypeURL) {
                // 取出链接文字范围
                NSValue *value = [attDic valueForKey:LXCustomeAttributeRange];
                NSRange attRange = value.rangeValue;
                CFRange linkRange = CFRangeMake(attRange.location, attRange.length);
                
                // 先绘制背景 后绘制文字
                [self drawURLBackground:contextRef runBounds:runBounds linkRange:linkRange runRange:range];
            }
            
            // 绘制文字
            CTRunDraw(runRef, contextRef, CFRangeMake(0, 0));
        }
    }
}

- (void)drawURLBackground:(CGContextRef)contextRef runBounds:(CGRect)runBounds linkRange:(CFRange)linkRange runRange:(CFRange)range{
    if (self.touchPhase == UITouchPhaseBegan) { // 点击链接开始
        // 判断点击区域是否落在链接区域内
        if (isTouchRange(self.touchIndex, linkRange, range)) {
            //
            CGColorRef tempColor = CGColorCreateCopyWithAlpha([UIColor lightGrayColor].CGColor, 1);
            CGContextSetFillColorWithColor(contextRef, tempColor);
            CGColorRelease(tempColor);
            CGContextFillRect(contextRef, runBounds);
            if (!self.respondLink) {  // 防止响应两次点击事件(因为分两行显示)
                self.respondLink = true;
                NSLog(@"点击了链接");
            }
        }
    } else {
        // 判断点击区域是否落在链接区域内
        if (isTouchRange(self.touchIndex, linkRange, range)) {
            
            CGContextSetFillColorWithColor(contextRef, [UIColor clearColor].CGColor);
            CGContextFillRect(contextRef, runBounds);
            self.respondLink = false;
        }
    }
}

- (void)simpleDraw {
    // 获取cotext
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 翻转坐标系
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // 创建绘制区域
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    
    //
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:@"hello world"];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrStr);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attrStr.length), path, NULL);
    
    //
    CTFrameDraw(frameRef, context);
    
    //
    CFRelease(frameRef);
    CFRelease(framesetter);
    CFRelease(path);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    self.touchPoint = point;
    self.touchPhase = touch.phase;
    self.touchIndex = [LXDealEventManager indexTouchView:self point:point atCoretexDataManager:self.manager];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    self.touchPhase = touch.phase;
    [self setNeedsDisplay];
}

Boolean CFRangesIntersect(CFRange range, CFRange runRange) {
    CFIndex max_location = MAX(range.location, runRange.location);
    CFIndex min_tail = MIN(range.location + range.length, runRange.location + runRange.length);
    if (min_tail - max_location > 0) {
        return TRUE;
    } else {
        return FALSE;
    }
}

Boolean isTouchRange(CFIndex index, CFRange touch_range, CFRange run_range) {
    if (touch_range.location < index && touch_range.location + touch_range.length >= index) {
        return CFRangesIntersect(touch_range, run_range);
    } else {
        return FALSE;
    }
}
@end

