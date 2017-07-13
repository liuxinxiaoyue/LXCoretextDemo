//
//  LXShowPictureCell.m
//  Modal
//
//  Created by tang on 16/7/26.
//  Copyright © 2016年 tang. All rights reserved.
//

#import "LXShowPictureCell.h"

@implementation LXShowPictureCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    self.imgView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageAction)];
    [self.imgView addGestureRecognizer:tap];
}

- (void)tapImageAction{
    if ([self.delegate respondsToSelector:@selector(showPictureCell:tapImageView:)]) {
        [self.delegate showPictureCell:self tapImageView:self.imgView];
    }
}

@end
