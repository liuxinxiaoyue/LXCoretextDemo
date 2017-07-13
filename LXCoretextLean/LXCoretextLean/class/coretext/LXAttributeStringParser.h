//
//  LXAttributeStringParser.h
//  LXCoretextLean
//
//  Created by tang on 17/3/8.
//  Copyright © 2017年 tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXNormalContent.h"
#import "LXFrameParsesConfig.h"

typedef NS_ENUM(NSInteger, LXAttributeType) {
    LXAttributeTypeText,
    LXAttributeTypeURL,
    LXAttributeTypeThreme,
    LXAttributeTypeTruncation,
    LXAttributeTypeImage,
};

@class LXLinkContent;
@interface LXAttributeStringParser : NSObject


+ (NSDictionary *)attributesWithLeading:(float)leading breakMode:(CTLineBreakMode)breakMode textFont:(UIFont *)font;
/**
 返回属性字符串

 @param contents 内容
 @param leading 行高
 @param font 字体
 @return attributedString
 */
+ (NSAttributedString *)attributeStringWith:(NSArray<LXNormalContent *> *)contents leading:(float)leading font:(UIFont *)font breadkMode:(CTLineBreakMode)breakMode;

+ (NSMutableAttributedString *)attributeStringForSurplus:(NSString *)content foreignColor:(UIColor *)color location:(NSInteger)loacation;
@end

UIKIT_EXTERN NSString *const LXCustomeAttributeType;
UIKIT_EXTERN NSString *const LXCustomeAttributeRange;
