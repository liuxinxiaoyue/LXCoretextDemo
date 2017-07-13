//
//  LXShowTableViewCell.h
//  LXCoretextLean
//
//  Created by tang on 17/3/30.
//  Copyright © 2017年 tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXLabel.h"
#import "LXShowImageView.h"
#import "LXPlayerView.h"

@class LXViewModel, LXShowTableViewCell, LXShowModelResource;

@protocol LXShowTableViewCellDelegate <NSObject>

@optional
- (void)showCell:(LXShowTableViewCell *)cell tapImageView:(UIImageView *)imageView;
- (void)showCell:(LXShowTableViewCell *)cell tapVideo:(LXShowModelResource *)resource;

@end
@interface LXShowTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *avatorImgView;
@property (nonatomic, strong) LXLabel *nameLabel;
@property (nonatomic, strong) LXLabel *contentLabel;
@property (nonatomic, strong) LXPlayerView *playerView;
@property (nonatomic, strong) LXShowImageView *imgsView;
@property (nonatomic, weak) id<LXShowTableViewCellDelegate> delegate;
@property (nonatomic, strong) LXViewModel *model;

- (void)configWithViewModel:(LXViewModel *)model;
@end
