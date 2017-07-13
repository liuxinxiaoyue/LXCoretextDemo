//
//  LXVideoDecodeManager.m
//  LXCoretextLean
//
//  Created by tang on 17/4/28.
//  Copyright © 2017年 tang. All rights reserved.
//

#import "LXVideoDecodeManager.h"

@interface LXVideoDecodeManager()

@property (nonatomic, strong) NSMutableDictionary *decodeDictionary;
@property (nonatomic, strong) NSOperationQueue *decodeQueue;
@end

@implementation LXVideoDecodeManager

+ (instancetype)defaultManager {
    static dispatch_once_t onceToken;
    static LXVideoDecodeManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[LXVideoDecodeManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.decodeDictionary = [NSMutableDictionary dictionary];
        self.decodeQueue = [[NSOperationQueue alloc] init];
        self.decodeQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

- (void)decodeFileURL:(NSURL *)url perFrameBlock:(LXVideoDecodePerFrameBlock)frameBlock completeBlock:(LXVideoDecodeFinishBlock)finishBlock errorBlock:(LXVideoDecodeErrorBlock)errorBlock {
    NSString *key = url.absoluteString;
    if (self.decodeDictionary[key]) {
        return;
    }

    LXVideoDecodeOperation *operation = [[LXVideoDecodeOperation alloc] initDecodeVideoURL:url perFrameBlock:frameBlock completeBlock:^{
        LXVideoDecodeOperation *operation = self.decodeDictionary[key];
        if (operation) {
            [self.decodeDictionary removeObjectForKey:key];
        }
        finishBlock();
    } errorBlock:errorBlock];
    
    [self.decodeDictionary setObject:operation forKey:key];
    [self.decodeQueue addOperation:operation];
}

- (void)cancelDecodeByURL:(NSURL *)url {
    NSString *key = url.absoluteString;
    LXVideoDecodeOperation *operation = self.decodeDictionary[key];
    if (operation) {
        [self.decodeDictionary removeObjectForKey:key];
    }
    [operation cancel];
    
    NSLog(@"剩下 %ld", self.decodeQueue.operations.count);
}
@end
