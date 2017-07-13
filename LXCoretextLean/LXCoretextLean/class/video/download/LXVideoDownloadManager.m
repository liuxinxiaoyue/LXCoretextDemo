//
//  LXVideoDownloadManager.m
//  LXCoretextLean
//
//  Created by tang on 17/4/28.
//  Copyright © 2017年 tang. All rights reserved.
//

#import "LXVideoDownloadManager.h"
#import "LXVideoCacheManager.h"

@interface LXVideoDownloadManager()

@property (nonatomic, strong) NSOperationQueue *downloadQueue;
@property (nonatomic, copy) DownloadFinishBlock finishBlock;
@end

@implementation LXVideoDownloadManager

+ (instancetype)defaultManager {
    static dispatch_once_t onceToken;
    static LXVideoDownloadManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[LXVideoDownloadManager alloc] init];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        queue.maxConcurrentOperationCount = 1;
        queue.name = @"LXVideoDownloadOperationQueue";
        instance.downloadQueue = queue;
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadFinish:) name:LXVideoDownloadCompleteNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)downloadVideo:(NSURL *)url progrossBlock:(DownloadProgressBlock)progrossBlock finishBlock:(DownloadFinishBlock)finishBlock errorBlock:(DownloadErrorBlock)errorBlock {
    // query cache
    if (!([url isKindOfClass:[NSURL class]] && url.absoluteString.length > 0)) {
        return;
    }
    NSURL *cacheURL = [[LXVideoCacheManager defaultManager] localCacheURL:url];
    if (cacheURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            finishBlock(cacheURL);
        });
        return;
    }
    self.finishBlock = finishBlock;
    
    // load network
    LXVideoDownloadOperation *operation = [[LXVideoDownloadOperation alloc] initWithVideoURL:url];
    operation.progressCallBack = progrossBlock;
    
    [self.downloadQueue addOperation:operation];
}

- (void)downloadFinish:(NSNotification *)noitfication {
    NSURL *url = noitfication.object;
    if (![url isKindOfClass:[NSURL class]]) {
        return;
    }
    self.finishBlock(url);
}

@end
