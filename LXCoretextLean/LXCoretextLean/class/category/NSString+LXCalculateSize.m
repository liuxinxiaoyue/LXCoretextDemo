//
//  NSString+LXCalculateSize.m
//  LXCoretextLean
//
//  Created by tang on 17/3/30.
//  Copyright © 2017年 tang. All rights reserved.
//

#import "NSString+LXCalculateSize.h"
#import "LXAttributeStringParser.h"
#import <CoreText/CoreText.h>

@implementation NSString (LXCalculateSize)

- (CGSize)lx_sizeWithFont:(nonnull UIFont *)font leading:(CGFloat)leading lineBreakMode:(NSLineBreakMode)breakMode size:(CGSize)size {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = leading;
    style.lineBreakMode = breakMode;
    NSDictionary *attrs = @{NSFontAttributeName: font, NSParagraphStyleAttributeName: style};
    CGSize suggestSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:NULL].size;
    return suggestSize;
}

- (CGSize)lx_sizeWithFont:(nonnull UIFont *)font leading:(CGFloat)leading lineBreakMode:(CTLineBreakMode)breakMode constraintSize:(CGSize)size {
    NSDictionary *dic = [LXAttributeStringParser attributesWithLeading:leading breakMode:breakMode textFont:font];
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:self attributes:dic];
    CTFramesetterRef setterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attr);
    CGSize suggestSize = CTFramesetterSuggestFrameSizeWithConstraints(setterRef, CFRangeMake(0, attr.length), NULL, size, NULL);
    return suggestSize;
}
@end
