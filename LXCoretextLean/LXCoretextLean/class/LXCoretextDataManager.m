//
//  LXCoretextDataManager.m
//  LXCoretextLean
//
//  Created by tang on 17/3/8.
//  Copyright © 2017年 tang. All rights reserved.
//

#import "LXCoretextDataManager.h"

@implementation LXCoretextDataManager

- (void)setFrameRef:(CTFrameRef)frameRef {
    if (_frameRef != frameRef) {
        if (_frameRef != nil) {
            CFRelease(_frameRef);
        }
        CFRetain(frameRef);
        _frameRef = frameRef;
    }
}

- (void)setImgArray:(NSArray *)imgArray {
    _imgArray = imgArray;
    [self fillImagePosition];
}

- (void)fillImagePosition {
    if (self.imgArray.count == 0) {
        return;
    }
    
    NSArray *lines = (NSArray *)CTFrameGetLines(self.frameRef);
    NSInteger lineCount = lines.count;
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(self.frameRef, CFRangeMake(0, 0), lineOrigins);
    
    int imgIndex = 0;
    LXImageContent *imgContent = self.imgArray[0];
    
    for (NSInteger i = 0; i < lineCount; i++) {
        if (imgContent == nil) {
            break;
        }
        CTLineRef lineRef = (__bridge CTLineRef)lines[i];
        NSArray *runArray = (NSArray *)CTLineGetGlyphRuns(lineRef);
        
        for (id runObj in runArray) {
            CTRunRef runRef = (__bridge CTRunRef)runObj;
            NSDictionary *runAttributes = (NSDictionary *)CTRunGetAttributes(runRef);
            CTRunDelegateRef delegateRef = (__bridge CTRunDelegateRef)[runAttributes valueForKey:(id)kCTRunDelegateAttributeName];
            if (nil == delegateRef) {
                continue;
            }
            
            LXImageContent *dict = CTRunDelegateGetRefCon(delegateRef);
            if (![dict isKindOfClass:[LXImageContent class]]) {
                continue;
            }
            
            CGRect runBounds;
            CGFloat ascent;
            CGFloat descent;
            runBounds.size.width = CTRunGetTypographicBounds(runRef, CFRangeMake(0, 0), &ascent, &descent, NULL);
            runBounds.size.height = ascent + descent;
            
            CGFloat xOffset = CTLineGetOffsetForStringIndex(lineRef, CTRunGetStringRange(runRef).location, NULL);
            runBounds.origin.x = lineOrigins[i].x + xOffset;
            runBounds.origin.y = lineOrigins[i].y;
            runBounds.origin.y -= descent;
            
            CGPathRef pathRef = CTFrameGetPath(self.frameRef);
            CGRect colRect = CGPathGetBoundingBox(pathRef);
            
            CGRect delegateBounds = CGRectOffset(runBounds, colRect.origin.x, colRect.origin.y);
            
            imgContent.imagePosition = delegateBounds;
            imgIndex += 1;
            if (imgIndex == self.imgArray.count) {
                imgContent = nil;
                break;
            } else {
                imgContent = self.imgArray[imgIndex];
            }
        }
    }
}

- (void)dealloc {
    if (_frameRef != nil) {
        CFRelease(_frameRef);
        _frameRef = nil;
    }
}
@end
