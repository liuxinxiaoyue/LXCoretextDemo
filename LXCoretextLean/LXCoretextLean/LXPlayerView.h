//
//  LXPlayerView.h
//  LXCoretextLean
//
//  Created by tang on 17/4/25.
//  Copyright © 2017年 tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface LXPlayerView : UIView

@property (nonatomic, strong) UIProgressView *progressView;

- (void)loadFirstImageWithURL:(NSString *)url;

- (void)playVideoWithURL:(NSURL *)fileURL;

- (void)pauseVideoWithURL:(NSURL *)fileURL;
@end
