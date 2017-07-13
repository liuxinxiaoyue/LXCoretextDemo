//
//  LXShowTableViewCell.m
//  LXCoretextLean
//
//  Created by tang on 17/3/30.
//  Copyright © 2017年 tang. All rights reserved.
//

#import "LXShowTableViewCell.h"
#import "LXShowImageView.h"

#import "UIImageView+WebCache.h"

#import "LXViewModel.h"
#import "LXVideoDownloadManager.h"
#import "LXVideoDecode.h"
#import "LXVideoDecodeManager.h"

@interface LXShowTableViewCell ()

@end

@implementation LXShowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        LXLabel *nameLabel = [[LXLabel alloc] init];
        nameLabel.verticalAlignment = LXTextVerticalAlignmentCenter;
//        nameLabel.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        LXLabel *contentLabel = [[LXLabel alloc] init];
//        contentLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:contentLabel];
        self.contentLabel = contentLabel;
        
        LXPlayerView *playerView = [[LXPlayerView alloc] init];
        [self.contentView addSubview:playerView];
        self.playerView = playerView;
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:imgView];
        self.avatorImgView = imgView;
        
        LXShowImageView *imgsView = [[LXShowImageView alloc] init];
        imgsView.backgroundColor = [UIColor colorWithRed:238.0/ 255.0 green:233.0/ 255.0 blue:233.0/ 255.0 alpha:1.0];
        @weakObj(self);
        imgsView.touchImgViewBlock = ^(UIImageView *imgView){
            @strongObj(self);
            if ([self.delegate respondsToSelector:@selector(showCell:tapImageView:)]) {
                [self.delegate showCell:self tapImageView:imgView];
            }
        };
        [self.contentView addSubview:imgsView];
        self.imgsView = imgsView;
    }
    return self;
}

- (void)configWithViewModel:(LXViewModel *)model {
    self.model = model;
    
    self.avatorImgView.frame = model.avatorFrame;
    NSURL *url = [NSURL URLWithString:model.showModel.avatar];
    [self.avatorImgView sd_setImageWithURL:url placeholderImage:nil];
    
    self.nameLabel.frame = model.nicknameFrame;
    self.nameLabel.layout = model.nickNameLayout;
    
    self.contentLabel.frame = model.contentFrame;
    self.contentLabel.layout = model.contentLayout;
    
    self.imgsView.hidden = true;
    self.playerView.hidden = true;
    if (model.showModel.contentType == LXShowModelTypeVideo) {
        LXShowModelResource *resource = model.showModel.resources.firstObject;
        self.playerView.frame = model.playerFrame;
        
        // 拿第一张图
        [self.playerView loadFirstImageWithURL:resource.imageUrl];
        self.playerView.hidden = false;
        self.playerView.progressView.progress = 0.0;
        self.playerView.hidden = false;
    } else if (model.showModel.contentType == LXShowModelTypeImage) {
        
        self.imgsView.frame = model.imgViewFrame;
        self.imgsView.images = model.imgsMode;
        self.imgsView.hidden = false;
    }
    [self setNeedsLayout];
}
@end
