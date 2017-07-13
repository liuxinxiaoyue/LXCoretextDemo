//
//  LXVideoDownloadOperation.m
//  LXCoretextLean
//
//  Created by tang on 17/4/28.
//  Copyright © 2017年 tang. All rights reserved.
//

#import "LXVideoDownloadOperation.h"
#import "LXVideoCacheManager.h"

@interface LXVideoDownloadOperation()<NSURLSessionDownloadDelegate>

@property (nonatomic, assign, getter=isExecuting) BOOL executing;
@property (nonatomic, assign, getter=isFinished) BOOL finished;
@end

@implementation LXVideoDownloadOperation

@synthesize executing = _executing;
@synthesize finished = _finished;

- (instancetype)initWithVideoURL:(NSURL *)url {
    self = [super init];
    if (self) {
        _executing = false;
        _finished = false;
        _url = url;
    }
    return self;
}

- (instancetype)init {
    return [self initWithVideoURL:nil];
}

- (void)main {
    @try {
        NSLog(@"start excutiong %s, mainThread %@, currentThread %@", __func__, [NSThread mainThread], [NSThread currentThread]);
        if (self.isCancelled || self.url == nil) {
            self.finished = true;
            self.executing = false;
            return;
        }
        NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultConfig.timeoutIntervalForRequest = 10;
        NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfig delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:self.url];
        [downloadTask resume];
        self.executing = true;
    } @catch (NSException *exception) {
        self.finished = true;
        self.executing = false;
    } @finally {
        
    }
}

- (void)start {
    if (self.isCancelled) {
        self.finished = true;
        return;
    }
    
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    self.executing = true;
}

- (BOOL)isExecuting {
    return _executing;
}

- (BOOL)isFinished {
    return _finished;
}

- (BOOL)isConcurrent {
    return true;
}

- (void)callWhenFinsishSucc:(BOOL)succ responseObject:(id)response error:(NSError *)error {
//    if (self.callBack) {
//        self.callBack(succ, response, error);
//    }
    self.finished = true;
    self.executing = false;
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

#pragma mark - NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSLog(@"finish");
    
    NSString *fileName = downloadTask.response.suggestedFilename;
    NSURL *cacheURL = [[LXVideoCacheManager defaultManager] cacheFile:fileName fileURL:location];
    [[NSNotificationCenter defaultCenter] postNotificationName:LXVideoDownloadCompleteNotification object:cacheURL];
    self.finished = true;
    self.executing = false;
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    NSLog(@"didWrite: %lld, totalWrite: %lld, totalExpect: %lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    if (self.progressCallBack) {
        dispatch_async(dispatch_get_main_queue(), ^{
            double totalExpect = totalBytesExpectedToWrite;
            float percent = totalBytesWritten / totalExpect;
            self.progressCallBack(percent);
        });
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    NSLog(@"error description %@", error.description);
}

@end

NSString *LXVideoDownloadCompleteNotification = @"LXVideoDownloadCompleteNotification";
