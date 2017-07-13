//
//  LXShowImageView.h
//  LXCoretextLean
//
//  Created by tang on 2017/5/10.
//  Copyright © 2017年 tang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LXShowImageViewTouchImageViewBlock)(UIImageView *imgView);
@class LXImageMode;
@interface LXShowImageView : UIView

@property (nonatomic, strong) NSArray<LXImageMode *> *images;
@property (nonatomic, copy) LXShowImageViewTouchImageViewBlock touchImgViewBlock;
@end

@interface LXSubImageView : UIImageView

@property (nonatomic, strong) UILabel *label;
@end
