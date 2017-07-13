//
//  LXLayout.m
//  LXCoretextLean
//
//  Created by tang on 2017/5/9.
//  Copyright © 2017年 tang. All rights reserved.
//

#import "LXLayout.h"
#import <CoreText/CoreText.h>

#import "RegexKitLite.h"

#import "LXAttributeStringParser.h"
#import "NSString+LXCalculateSize.h"

#import "LXTextContent.h"
#import "LXLinkContent.h"
#import "LXAtContent.h"
#import "LXImageContent.h"
#import "LXEmotionManager.h"

@implementation LXLayout

- (instancetype)init {
    if (self = [super init]) {
        self.breakMode = kCTLineBreakByWordWrapping;
        self.fontSize = 17.0;
        self.leading = 0.0;
    }
    return self;
}

- (void)setText:(NSString *)text {
    NSString *urlPattern = @"\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))";
    NSString *atPattern = @"@[0-9a-zA-Z\\u4e00-\\u9fa5]+";
    NSString *emotionPattern = @"\\[[\\u4e00-\\u9fa5]+\\]";
    NSString *pattern = [NSString stringWithFormat:@"%@|%@|%@", urlPattern, atPattern, emotionPattern];
    
    NSMutableArray *items = [NSMutableArray array];
    NSError *error;
    [text enumerateStringsSeparatedByRegex:pattern options:RKLNoOptions inRange:NSMakeRange(0, text.length) error:&error enumerationOptions:RKLRegexEnumerationNoOptions usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        LXTextContent *temp = [[LXTextContent alloc] init];
        temp.text = *capturedStrings;
        temp.range = *capturedRanges;
        temp.contentType = LXContentTypeText;
        [items addObject:temp];
    }];
    
    NSMutableArray *linkArrays = [NSMutableArray array];
    NSMutableArray *emotionArray = [NSMutableArray array];
    [text enumerateStringsMatchedByRegex:pattern options:RKLNoOptions inRange:NSMakeRange(0, text.length) error:&error enumerationOptions:RKLRegexEnumerationNoOptions usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        NSString *str = *capturedStrings;
        if ([str isMatchedByRegex:urlPattern]) {
            LXLinkContent *link = [[LXLinkContent alloc] init];
            link.range = *capturedRanges;
            link.text = str;
            link.contentType = LXContentTypeLinker;
            link.textColor = [UIColor blueColor];
            [items addObject:link];
            [linkArrays addObject:link];
        } else if ([str isMatchedByRegex:atPattern]) {
            LXAtContent *at = [[LXAtContent alloc] init];
            at.range = *capturedRanges;
            at.text = str;
            at.textColor = [UIColor orangeColor];
            at.contentType = LXContentTypeAt;
            [items addObject:at];
        } else if ([str isMatchedByRegex:emotionPattern]) {
            LXImageContent *emotion = [[LXImageContent alloc] init];
            emotion.range = *capturedRanges;
            emotion.contentType = LXContentTypeImage;
            NSString *str = [text substringWithRange:*capturedRanges];
            emotion.imageName = [[LXEmotionManager defaultManager] emotionWithString:str];
            emotion.width = 24.0;
            emotion.height = 24.0;
            emotion.descent = 6.0;
            [items addObject:emotion];
            [emotionArray addObject:emotion];
        }
    }];
    _linkArray = [linkArrays copy];
    _emotionArray = [emotionArray copy];
    
    [items sortUsingComparator:^NSComparisonResult(LXNormalContent *obj1, LXNormalContent *obj2) {
        NSInteger location1 = obj1.range.location;
        NSInteger location2 = obj2.range.location;
        if (location1 > location2) {
            return NSOrderedDescending;
        } else if (location1 == location2) {
            return NSOrderedSame;
        } else {
            return NSOrderedAscending;
        }
    }];
    
    UIFont *font = [UIFont systemFontOfSize:_fontSize];
    NSAttributedString *attr = [LXAttributeStringParser attributeStringWith:items leading:_leading font:font breadkMode:_breakMode];
    _attributeString = attr;
}

- (CGFloat)heigtWithMaxWidth:(CGFloat)width {

    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    CGSize suggestSize = [self attributeWithConstrainSize:size];
    return ceilf(suggestSize.height);
}

- (CGFloat)widthWithMaxHeight:(CGFloat)height {

    CGSize size = CGSizeMake(CGFLOAT_MAX, height);
    CGSize suggestSize = [self attributeWithConstrainSize:size];
    return ceilf(suggestSize.width);
}

- (CGSize)attributeWithConstrainSize:(CGSize)size {
    if (_attributeString == nil) {
        return CGSizeZero;
    }
    CTFramesetterRef setterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_attributeString);
    CGSize suggestSize = CTFramesetterSuggestFrameSizeWithConstraints(setterRef, CFRangeMake(0, _attributeString.length), NULL, size, NULL);
    return suggestSize;
}
@end
