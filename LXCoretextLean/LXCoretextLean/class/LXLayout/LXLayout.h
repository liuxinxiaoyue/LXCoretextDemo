//
//  LXLayout.h
//  LXCoretextLean
//
//  Created by tang on 2017/5/9.
//  Copyright © 2017年 tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXLayout : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) CTLineBreakMode breakMode;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGFloat leading;
@property (nonatomic, strong, readonly) NSAttributedString *attributeString;
@property (nonatomic, strong, readonly) NSArray *linkArray;
@property (nonatomic, strong, readonly) NSArray *atArray;
@property (nonatomic, strong, readonly) NSArray *emotionArray;
@property (nonatomic, strong, readonly) NSArray *imageArray;

- (CGFloat)heigtWithMaxWidth:(CGFloat)width;

- (CGFloat)widthWithMaxHeight:(CGFloat)height;
@end
