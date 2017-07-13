//
//  LXAttributeStringParser.m
//  LXCoretextLean
//
//  Created by tang on 17/3/8.
//  Copyright © 2017年 tang. All rights reserved.
//

#import <CoreText/CoreText.h>

#import "LXAttributeStringParser.h"

#import "LXTextContent.h"
#import "LXImageContent.h"
#import "LXLinkContent.h"


static NSString *const LXAttributeStringImage = @"LXAttributeStringImage";
static NSString *const LXAttributeStringURL = @"LXAttributeStringURL";

@implementation LXAttributeStringParser

+ (NSDictionary *)attributesWithConfig:(LXFrameParsesConfig *)config {
    
    CGFloat lineSpacing = config.lineSpace;
    const CFIndex kNumberOfSettings = 4;
    CTLineBreakMode breakMode = kCTLineBreakByCharWrapping;
    CTParagraphStyleSetting settings[kNumberOfSettings] = {
        {kCTParagraphStyleSpecifierAlignment, sizeof(CGFloat), &lineSpacing},
        {kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpacing},
        {kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpacing},
        {kCTParagraphStyleSpecifierLineBreakMode, sizeof(CTLineBreakMode), &breakMode}
    };
    CTParagraphStyleRef paragraphStyleRef = CTParagraphStyleCreate(settings, kNumberOfSettings);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)paragraphStyleRef;

    CFRelease(paragraphStyleRef);
    return dict;
}

+ (NSDictionary *)attributesWithLeading:(float)leading breakMode:(CTLineBreakMode)breakMode textFont:(UIFont *)font {
    
    CGFloat lineSpacing = leading;
    const CFIndex kNumberOfSettings = 4;
    CTTextAlignment alignment = kCTTextAlignmentLeft;
    CTParagraphStyleSetting settings[kNumberOfSettings] = {
        {kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &alignment},
        {kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpacing},
        {kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpacing},
        {kCTParagraphStyleSpecifierLineBreakMode, sizeof(CTLineBreakMode), &breakMode}
    };
    CTParagraphStyleRef paragraphStyleRef = CTParagraphStyleCreate(settings, kNumberOfSettings);
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, NULL);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)paragraphStyleRef;
    dict[(id)kCTFontAttributeName] = (__bridge id)fontRef;
    
    CFRelease(fontRef);
    CFRelease(paragraphStyleRef);
    return dict;
}

+ (NSAttributedString *)attributeStringWith:(NSArray<LXNormalContent *> *)contents leading:(float)leading font:(UIFont *)font breadkMode:(CTLineBreakMode)breakMode {
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
    [contents enumerateObjectsUsingBlock:^(LXNormalContent *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *attributes = [self attributesWithLeading:leading breakMode:breakMode textFont:font];
        if (obj.contentType == LXContentTypeText || obj.contentType == LXContentTypeAt) {
            NSAttributedString *temp = [self attributeStringForTextmodal:(LXTextContent *)obj attributes:attributes];
            [attr appendAttributedString:temp];
        } else if (obj.contentType == LXContentTypeImage) {
            NSAttributedString *temp = [self attributeStringForImageModal:(LXImageContent *)obj attributes:attributes];
            [attr appendAttributedString:temp];
        } else if (obj.contentType == LXContentTypeLinker) {
            NSAttributedString *temp = [self attributeStringForLinkModel:(LXLinkContent *)obj attributes:attributes];
            [attr appendAttributedString:temp];
        }
    }];
    return attr;
}

+ (NSAttributedString *)attributeStringForTextmodal:(LXTextContent *)modal attributes:(NSDictionary *)atts {

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:atts];
    dict[(id)kCTForegroundColorAttributeName] = (id)modal.textColor.CGColor;
    
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:modal.text attributes:dict];
    return attr;
}

+ (NSAttributedString *)attributeStringForImageModal:(LXImageContent *)modal attributes:(NSDictionary *)atts {

    CTRunDelegateCallbacks callbacks;
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
    callbacks.version = kCTRunDelegateVersion1;
    callbacks.getAscent = ascentCallback;
    callbacks.getDescent = descentCallback;
    callbacks.getWidth = widthCallback;
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void*)modal);
    
    // 使用OxFFC 作为占位符
    unichar replacementChar = 0xFFFC;
    NSString *content = [NSString stringWithCharacters:&replacementChar length:1];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:content attributes:atts];
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attr, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate);
    [attr addAttribute:LXCustomeAttributeType value:@(LXAttributeTypeImage) range:NSMakeRange(0, 1)];
    NSValue *rangeValue = [NSValue valueWithRange:modal.range];
    [attr addAttribute:LXCustomeAttributeRange value:rangeValue range:NSMakeRange(0, 1)];
    CFRelease(delegate);
    return attr;
}

+ (NSAttributedString *)attributeStringForLinkModel:(LXLinkContent *)modal attributes:(NSDictionary *)attrs {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:attrs];
    dict[(id)kCTForegroundColorAttributeName] = (id)modal.textColor.CGColor;
    dict[LXCustomeAttributeType] = @(LXAttributeTypeURL);
    dict[LXCustomeAttributeRange] = [NSValue valueWithRange:modal.range];
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:modal.text attributes:dict];

    return attr;
}

+ (NSMutableAttributedString *)attributeStringForSurplus:(NSString *)content foreignColor:(UIColor *)color location:(NSInteger)loacation {
    if (!(content && content.length > 0)) {
        return nil;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[(id)kCTForegroundColorAttributeName] = (id)color.CGColor;
    dict[LXCustomeAttributeType] = @(LXAttributeTypeTruncation);
    dict[LXCustomeAttributeRange] = [NSValue valueWithRange: NSMakeRange(loacation, content.length)];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:content attributes:dict];
    return attr;
}

static CGFloat ascentCallback(void *ref) {

    LXImageContent *content = (__bridge LXImageContent*)ref;
    return content.height - content.descent;
}

static CGFloat descentCallback(void *ref) {
    LXImageContent *content = (__bridge LXImageContent*)ref;
    return content.descent;
}

static CGFloat widthCallback(void *ref) {

    LXImageContent *content = (__bridge LXImageContent*)ref;
    return content.width;
}
@end

NSString *const LXCustomeAttributeType = @"LXCustomeAttributeType";
NSString *const LXCustomeAttributeRange = @"LXCustomeAttributeRange";
