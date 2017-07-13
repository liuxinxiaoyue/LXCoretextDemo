//
//  LXLabel.m
//  LXCoretextLean
//
//  Created by tang on 17/3/30.
//  Copyright © 2017年 tang. All rights reserved.
//

#import "LXLabel.h"

#import "RegexKitLite.h"
#import "UIView+LXExtension.h"

#import "LXCalculateRectUtils.h"
#import "LXAttributeStringParser.h"

#import "LXTextContent.h"
#import "LXLinkContent.h"
#import "LXAtContent.h"
#import "LXImageContent.h"
#import "LXEmotionManager.h"

#import "LXLayout.h"

static NSString *const surplusStr = @"全文";

@interface LXLabel()

@property (nonatomic, assign) CGPoint touchPoint;
@property (nonatomic, assign) UITouchPhase touchPhase;
@property (nonatomic, assign) CFIndex touchIndex;

@property (nonatomic, assign) CTFrameRef frameRef;
@property (nonatomic, assign) CTLineRef truncationLineRef;
@property (nonatomic, assign) BOOL truncation;
@property (nonatomic, assign) NSRange truncationRange;

@property (nonatomic, assign) NSInteger actualHeight;
@property (nonatomic, strong) NSAttributedString *attributeString;
@property (nonatomic, assign) CGFloat offsetY;
@end

@implementation LXLabel

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    NSAttributedString *attr = self.layout.attributeString;
    if (attr == nil) {
        return;
    }
    self.attributeString = attr;
    
    // 创建CTFramesetterRef
    CTFramesetterRef framesetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attr);
    
    // 获得要绘制的区域的高度
    CGSize restrictSize = CGSizeMake(CGRectGetWidth(rect), CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetterRef, CFRangeMake(0, 0), nil, restrictSize, nil);
    CGFloat textHeight = ceil(coreTextSize.height);
    self.actualHeight = textHeight;
    CGRect drawRect = rect;
    
    CGFloat rectHegith = CGRectGetHeight(rect);
    CGFloat rectWidth = CGRectGetWidth(rect);
    
    CGFloat height = rectHegith < textHeight ? rectHegith : textHeight;
    CGFloat y = 0;
    if (self.verticalAlignment == LXTextVerticalAlignmentCenter) {
        y = rectHegith < textHeight ? 0 : (rectHegith - textHeight) / 2;
        drawRect = CGRectMake(0, y , rectWidth, height);
    } else if (self.verticalAlignment == LXTextVerticalAlignmentBottom) {
        drawRect = CGRectMake(0, 0, rectWidth, height);
    } else {
        y = rectHegith < textHeight ? 0 : rectHegith - textHeight;
        drawRect.origin.y = y;
        drawRect.size.height = height;
    }
    self.offsetY = y;
    
    // 获取cotext
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 翻转坐标系
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);

    CGContextTranslateCTM(context, 0, self.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawRect);
//    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
//    CGContextAddPath(context, path);
//    CGContextFillPath(context);

    // 生成CTFrameRef
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetterRef, CFRangeMake(0, attr.length), path, NULL);
    
    if (frameRef == nil) {
        return;
    }
    self.frameRef = frameRef;
    
    // 绘制frameRef
    [self drawFrameRef:frameRef context:context];
    
    
    CFRelease(frameRef);
    CFRelease(path);
    CFRelease(framesetterRef);
}

- (void)drawFrameRef:(CTFrameRef)frameRef context:(CGContextRef)contextRef {
    // 获得CTLine
    CFArrayRef lineRefs = CTFrameGetLines(frameRef);
    CFIndex lineCount = CFArrayGetCount(lineRefs);
    CGPoint origins[lineCount];
    CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), origins);
    
    BOOL haveTruncation = (self.actualHeight > self.height) ? true :false;
    CGFloat yOffset = self.offsetY;
    for (int i = 0; i < lineCount; i++) {
        //
        CTLineRef lineRef = CFArrayGetValueAtIndex(lineRefs, i);
        if (i == lineCount - 1 && haveTruncation && lineCount > 1) {
            lineRef = [self createTruncationLineRef:contextRef replaceLineRef:lineRef];
            self.truncationLineRef = lineRef;
            self.truncation = true;
        }
        CFArrayRef runRefs = CTLineGetGlyphRuns(lineRef);

        CFIndex runCount = CFArrayGetCount(runRefs);
        
        for (int j = 0; j < runCount; j++) {
            // 获取CTRun
            CTRunRef runRef = CFArrayGetValueAtIndex(runRefs, j);
            CFRange range = CTRunGetStringRange(runRef);
            CGContextSetTextPosition(contextRef, origins[i].x, origins[i].y + yOffset);
            
            // 获取CTRun属性
            NSDictionary *attDic = (NSDictionary *)CTRunGetAttributes(runRef);
            NSNumber *type = [attDic objectForKey:LXCustomeAttributeType];
            if (type == nil) {
                // 没有特殊处理 直接绘制
                CTRunDraw(runRef, contextRef, CFRangeMake(0, 0));
                continue;
            } else if (type.integerValue == LXAttributeTypeImage) {
                NSDictionary *runAttributes = (NSDictionary *)CTRunGetAttributes(runRef);
                CTRunDelegateRef delegateRef = (__bridge CTRunDelegateRef)[runAttributes valueForKey:(id)kCTRunDelegateAttributeName];
                if (nil == delegateRef) {
                    continue;
                }
                
                LXImageContent *content = CTRunDelegateGetRefCon(delegateRef);
                if (![content isKindOfClass:[LXImageContent class]]) {
                    continue;
                }
                
                CGRect runBounds = [LXCalculateRectUtils getRunBounds:runRef lineRef:lineRef originPoint:origins[i]];
                
                CGPathRef pathRef = CTFrameGetPath(frameRef);
                CGRect colRect = CGPathGetBoundingBox(pathRef);
        
                CGRect delegateBounds = CGRectOffset(runBounds, colRect.origin.x, colRect.origin.y);
                
                UIImage *image = [UIImage imageNamed:content.imageName];
                CGContextDrawImage(contextRef, delegateBounds, image.CGImage);
                continue;
            }
            
            // 计算绘制区域
            CGRect runBounds = [LXCalculateRectUtils getRunBounds:runRef lineRef:lineRef originPoint:origins[i]];
            runBounds.origin.y += yOffset;
            
            LXAttributeType typeValue = type.integerValue;
            if (typeValue == LXAttributeTypeURL || typeValue == LXAttributeTypeTruncation || typeValue == LXAttributeTypeThreme) {
                // 取出链接文字范围
                NSValue *value = [attDic valueForKey:LXCustomeAttributeRange];
                NSRange attRange = value.rangeValue;
                CFRange linkRange = CFRangeMake(attRange.location, attRange.length);
                
                // 绘制背景
                [self drawURLBackground:contextRef runBounds:runBounds linkRange:linkRange runRange:range];
            }
            
            // 绘制文字
            CTRunDraw(runRef, contextRef, CFRangeMake(0, 0));
        }

        if (i == lineCount - 1 && haveTruncation && lineCount > 1) {
            CFRelease(lineRef);
        }
    }
}

- (CTLineRef)createTruncationLineRef:(CGContextRef)contextRef replaceLineRef:(CTLineRef)lineRef{
    // 省略号
    static NSString *const kEllipsesCharacter = @"\u2026";
    
    CFRange lastLineRange = CTLineGetStringRange(lineRef);
    
    CTLineTruncationType truncationType = kCTLineTruncationEnd;
    NSUInteger truncationAttributePosition = lastLineRange.location + lastLineRange.length - 1 - surplusStr.length;
    // 拿到最后一个字符的属性字典
    NSDictionary *tokenAttributes = [self.attributeString attributesAtIndex:truncationAttributePosition effectiveRange:NULL];
    
    NSAttributedString *surplusAttr = [self surplusAttributeStringWithDictionary:tokenAttributes location:lastLineRange.length - surplusStr.length];
    self.truncationRange = NSMakeRange(lastLineRange.length - surplusStr.length, surplusStr.length);
    if (surplusAttr == nil) {
        surplusAttr = [[NSAttributedString alloc] init];
    }
    
    // 给省略字符设置字体、颜色等属性
    NSAttributedString *tokenAttr = [[NSAttributedString alloc] initWithString:kEllipsesCharacter attributes:tokenAttributes];
    
    // 用省略号单独创建一个CTLine
    CTLineRef tokenLine = CTLineCreateWithAttributedString((CFAttributedStringRef)tokenAttr);
    // 复制这一行的属性字符串，如果要把省略号放到中间或其他位置，只需指定长度
    NSUInteger copyLength = lastLineRange.length - surplusAttr.length - 1;
    NSMutableAttributedString *truncationAttr = [[self.attributeString attributedSubstringFromRange:NSMakeRange(lastLineRange.location, copyLength)] mutableCopy];
    if (copyLength > 0) {
        // 判断最后一个字符是否是换行 空格符，是清掉该字符
        unichar lastChar = [[truncationAttr string] characterAtIndex:copyLength - 1];
        if ([[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:lastChar]) {
            [truncationAttr deleteCharactersInRange:NSMakeRange(copyLength - 1, 1)];
        }
    }
    // 拼接省略号到字符串最后
    [truncationAttr appendAttributedString:tokenAttr];
    [truncationAttr appendAttributedString:surplusAttr];
    // 把新的字符串创建成CTLine
    CTLineRef truncationLine = CTLineCreateWithAttributedString((CFAttributedStringRef)truncationAttr);
    // 创建一个截断的CTLine
    CTLineRef truncatedLine = CTLineCreateTruncatedLine(truncationLine, self.width, truncationType, tokenLine);
    if (!truncatedLine) {
        truncatedLine = CFRetain(tokenLine);
    }
    CFRelease(truncationLine);
    CFRelease(tokenLine);
    return truncatedLine;
}

- (NSAttributedString *)surplusAttributeStringWithDictionary:(NSDictionary *)attrs location:(NSInteger)location {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:attrs];
    dict[(id)kCTForegroundColorAttributeName] = (id)[UIColor orangeColor].CGColor;
    dict[LXCustomeAttributeType] = @(LXAttributeTypeTruncation);
    dict[LXCustomeAttributeRange] = [NSValue valueWithRange: NSMakeRange(location, surplusStr.length)];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:surplusStr attributes:dict];
    return attr;
}

- (void)drawURLBackground:(CGContextRef)contextRef runBounds:(CGRect)runBounds linkRange:(CFRange)linkRange runRange:(CFRange)range {
    if (self.touchPhase == UITouchPhaseBegan) { // 点击链接开始
        // 判断点击区域是否落在链接区域内
        if (isTouchRange(self.touchIndex, linkRange, range)) {
            //
            CGColorRef tempColor = CGColorCreateCopyWithAlpha([UIColor lightGrayColor].CGColor, 1);
            CGContextSetFillColorWithColor(contextRef, tempColor);
            CGColorRelease(tempColor);
            CGContextFillRect(contextRef, runBounds);
        }
    } else {
        // 判断点击区域是否落在链接区域内
        if (isTouchRange(self.touchIndex, linkRange, range)) {
            
            CGContextSetFillColorWithColor(contextRef, [UIColor clearColor].CGColor);
            CGContextFillRect(contextRef, runBounds);
        }
    }
}


- (CGRect)convertRect:(CGRect)rect inRect:(CGRect)toRect {
    
    CGFloat y = CGRectGetHeight(toRect) - CGRectGetMinY(rect) - CGRectGetHeight(rect);
    CGFloat x = CGRectGetMinX(rect);
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    return CGRectMake(x, y, width, height);
}

#pragma mark - touch event
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    if ([self touchPointInImageArea:point]) {
        NSLog(@"点击了图片...");
        return;
    }
    self.touchPoint = point;
    self.touchPhase = touch.phase;
    self.touchIndex = [LXCalculateRectUtils indexTouchView:self point:point frameRef:self.frameRef truncationLine:self.truncationLineRef offsetY:self.offsetY];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self callWhenEndTouch:touches];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self callWhenEndTouch:touches];
}

- (void)callWhenEndTouch:(NSSet<UITouch *> *)touches {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UITouch *touch = touches.anyObject;
        self.touchPhase = touch.phase;
        if (self.truncation) {
            if (indexInRange(self.touchIndex, self.truncationRange)) {
                NSLog(@"点击了。。。");
                self.truncation = false;
            }
        }
        
        for (LXNormalContent *temp in self.layout.linkArray) {
            NSRange range = temp.range;
            if (indexInRange(self.touchIndex, range)) {
                if (temp.contentType == LXContentTypeLinker) {
                    NSLog(@"点击了链接");
                    break;
                }
            }
        }
        
        [self setNeedsDisplay];
    });
}

BOOL indexInRange(CFIndex index, NSRange range) {
    return (range.location < index && (range.location + range.length) >= index);
}

#pragma mark - setter/getter

#pragma mark - utils
- (BOOL)touchPointInImageArea:(CGPoint)point {
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, self.height);
    transform = CGAffineTransformScale(transform, 1, -1);
    
    for (LXImageContent *temp in self.layout.imageArray) {
        CGRect rect = CGRectApplyAffineTransform(temp.imagePosition, transform);
        if (CGRectContainsPoint(rect, point)) {
            return true;
        }
    }
    return false;
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

#pragma mark - getter/setter

- (void)setTruncationLineRef:(CTLineRef)truncationLineRef {
    if (_truncationLineRef) {
        if (_truncationLineRef != truncationLineRef) {
            CFRelease(_truncationLineRef);
            _truncationLineRef = nil;
        }
    }
    CFRetain(truncationLineRef);
    _truncationLineRef = truncationLineRef;
}

- (void)setFrameRef:(CTFrameRef)frameRef {
    if (_frameRef != frameRef) {
        if (_frameRef != nil) {
            CFRelease(_frameRef);
        }
        CFRetain(frameRef);
        _frameRef = frameRef;
    }
}

- (void)setLayout:(LXLayout *)layout {
    _layout = layout;
    [self setNeedsDisplay];
}

- (void)dealloc {
    if (_truncationLineRef) {
        CFRelease(_truncationLineRef);
        _truncationLineRef = nil;
    }
    if (_frameRef) {
        CFRelease(_frameRef);
        _frameRef = nil;
    }
}
@end
