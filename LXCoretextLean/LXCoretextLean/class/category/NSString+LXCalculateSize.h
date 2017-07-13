//
//  NSString+LXCalculateSize.h
//  LXCoretextLean
//
//  Created by tang on 17/3/30.
//  Copyright © 2017年 tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (LXCalculateSize)

- (CGSize)lx_sizeWithFont:(nonnull UIFont *)font leading:(CGFloat)leading lineBreakMode:(NSLineBreakMode)breakMode size:(CGSize)size;

- (CGSize)lx_sizeWithFont:(nonnull UIFont *)font leading:(CGFloat)leading lineBreakMode:(CTLineBreakMode)breakMode constraintSize:(CGSize)size;
@end
