//
//  LXLinkContent.h
//  LXCoretextLean
//
//  Created by tang on 17/3/10.
//  Copyright © 2017年 tang. All rights reserved.
//

#import "LXNormalContent.h"

@interface LXLinkContent : LXNormalContent

@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, copy) NSString *fontFamily;
@end
