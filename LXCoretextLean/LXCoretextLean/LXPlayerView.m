//
//  LXPlayerView.m
//  LXCoretextLean
//
//  Created by tang on 17/4/25.
//  Copyright © 2017年 tang. All rights reserved.
//

#import "LXPlayerView.h"
#import "SDWebImageManager.h"
#import "LXVideoDecodeManager.h"
#import "LXVideoDownloadManager.h"
#import "LXVideoCacheManager.h"

@interface LXPlayerView()

@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, assign) double total;
@end

@implementation LXPlayerView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer *)player {
    
    return [(AVPlayerLayer *) [self layer] player];
}

- (void)setPlayer:(AVPlayer *)player {
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor blackColor];
        self.layer.contentsGravity = kCAGravityResizeAspect;
        
        UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        progressView.progress = 0.0;
//        progressView.trackTintColor = [UIColor redColor];
        [self addSubview:progressView];
        self.progressView = progressView;
    }
    return self;
}

- (void)loadFirstImageWithURL:(NSString *)url {
    if (!([url isKindOfClass:[NSString class]] && url.length > 0)) {
        return;
    }
    NSURL *imgUrl = [NSURL URLWithString:url];
    [[SDWebImageManager sharedManager] downloadImageWithURL:imgUrl options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {

        self.layer.contents = (__bridge id)image.CGImage;
    }];
}

#pragma - decode 
- (void)playVideoWithURL:(NSURL *)fileURL {
    @weakObj(self);
    [[LXVideoDownloadManager defaultManager] downloadVideo:fileURL progrossBlock:^(float percent) {
        
    } finishBlock:^(NSURL *fileURL) {
        @strongObj(self);
        [self decodeWithURL:fileURL];
    } errorBlock:^(NSError *error) {
        
    }];
}

- (void)decodeWithURL:(NSURL *)fileURL {
    @weakObj(self);
    [[LXVideoDecodeManager defaultManager] decodeFileURL:fileURL perFrameBlock:^(CGImageRef imageRef, CGFloat percent) {
        @strongObj(self);
        self.layer.contents = (__bridge id)imageRef;
        self.progressView.progress = percent;
    } completeBlock:^{
        @strongObj(self);
        NSLog(@"decode finish");
        self.progressView.progress = 1.0;
    } errorBlock:^(NSError *error) {
        
    }];
}

- (void)pauseVideoWithURL:(NSURL *)fileURL {
    LXVideoCacheManager *cacheManager = [LXVideoCacheManager defaultManager];
    NSURL *localFileURL = [cacheManager localCacheURL:fileURL] ;
    [[LXVideoDecodeManager defaultManager] cancelDecodeByURL:localFileURL];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat width = CGRectGetWidth(self.bounds);
    self.progressView.frame = CGRectMake(0, height - 1.0, width, 1.0);
}

- (NSString *)stringForSecond:(long long)seconds {
    
    if (seconds > 60 * 60) {
        // 小时
        NSInteger hour = (NSInteger)(seconds / 60 * 60);
        NSInteger minute = (NSInteger)((seconds - hour * 60 * 60) / 60);
        NSInteger seond = (NSInteger)(seconds - hour * 60 * 60 - minute * 60);
        return [NSString stringWithFormat:@"%ld:%ld:%ld",(long)hour,(long)minute,(long)seond];
    } else if (seconds > 60) {
        // 分
        NSInteger minute = (NSInteger)(seconds / 60);
        NSInteger seond = (NSInteger)(seconds - minute * 60);
        return [NSString stringWithFormat:@"00:%ld:%ld",(long)minute,(long)seond];
    } else {
        return [NSString stringWithFormat:@"00:00:%lld",seconds];
    }
}
@end

