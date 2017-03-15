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
    LXAttributeTypeImage,
};

@interface LXAttributeStringParser : NSObject


/**
 根据给定的有序内容组装attributeString

 @param contents 内容
 @return 返回属性字符串
 */
+ (NSAttributedString *)attributeStringWith:(NSArray<LXNormalContent *> *)contents config:(LXFrameParsesConfig *)config;
@end

UIKIT_EXTERN NSString *const LXCustomeAttributeType;
UIKIT_EXTERN NSString *const LXCustomeAttributeRange;
