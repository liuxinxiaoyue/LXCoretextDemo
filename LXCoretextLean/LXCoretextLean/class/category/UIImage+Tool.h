//
//  UIImage+Tool.h
//  ImageLean
//
//  Created by tang on 16/6/12.
//  Copyright © 2016年 tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tool)

- (UIImage *)waterMarkText:(NSString *)text inRect:(CGRect)rect;

- (UIImage *)waterMarkImage:(UIImage *)waterImage inRect:(CGRect)rect;

- (UIImage *)cropImage:(CGRect)rect;

- (UIImage *)resizeImage:(CGSize)size;

+ (UIImage *)imageConvertInView:(UIView *)view;
@end
