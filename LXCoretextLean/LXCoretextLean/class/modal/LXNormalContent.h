//
//  LXNormalContent.h
//  LXCoretextLean
//
//  Created by tang on 17/3/8.
//  Copyright © 2017年 tang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LXContentType) {
    LXContentTypeText,     // 文本
    LXContentTypeLinker,   // 链接
    LXContentTypeImage,    // 图片
    LXContentTypeAt,       // AT
};
@interface LXNormalContent : NSObject

@property (nonatomic, assign) NSRange range;
@property (nonatomic, assign) LXContentType contentType;
@end
