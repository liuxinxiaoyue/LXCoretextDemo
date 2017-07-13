//
//  LXShowImageView.m
//  LXCoretextLean
//
//  Created by tang on 2017/5/10.
//  Copyright © 2017年 tang. All rights reserved.
//

#import "LXShowImageView.h"

#import "UIImageView+WebCache.h"
#import "NSData+ImageContentType.h"

#import "LXImageMode.h"

@implementation LXShowImageView

- (instancetype)init {
    self = [super init];
    
    if (self) {
        for (int i = 0; i < 9; i++) {
            LXSubImageView *imgView = [[LXSubImageView alloc] init];
            imgView.userInteractionEnabled = true;
            imgView.tag = i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
            [imgView addGestureRecognizer:tap];
            [self addSubview:imgView];
        }
    }
    return self;
}

- (void)setImages:(NSArray<LXImageMode *> *)images {
    _images = images;
    int index = 0;
    for (LXSubImageView *imgView in self.subviews) {
        if (index > images.count - 1) {
            imgView.hidden = true;
            continue;
        }
        imgView.hidden = false;
        LXImageMode *resource = images[index];
        imgView.frame = resource.frame;
        [imgView sd_setImageWithURL:resource.url placeholderImage:nil];
        index += 1;
    }
}

- (void)tapImage:(UITapGestureRecognizer *)tapGesture {
    UIImageView *imgView = (UIImageView *)tapGesture.view;
    if (self.touchImgViewBlock) {
        self.touchImgViewBlock(imgView);
    }
}

@end

@implementation LXSubImageView

- (instancetype)init {
    if (self = [super init]) {
        UILabel *label = [[UILabel alloc] init];
//        label.backgroundColor = [UIColor colorWithRed:172.0 / 255.0 green:216.0 / 255.0 blue:230.0 / 255.0 alpha:1.0];
        label.backgroundColor = [UIColor redColor];
        label.hidden = true;
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        self.label = label;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    self.label.frame = CGRectMake(CGRectGetWidth(frame) - 30, CGRectGetHeight(frame) - 15, 30, 15);
}
@end
