//
//  LXTextContent.h
//  LXCoretextLean
//
//  Created by tang on 17/3/8.
//  Copyright © 2017年 tang. All rights reserved.
//

#import "LXNormalContent.h"

@interface LXTextContent : LXNormalContent

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, copy) NSString *fontFamily;
@end
