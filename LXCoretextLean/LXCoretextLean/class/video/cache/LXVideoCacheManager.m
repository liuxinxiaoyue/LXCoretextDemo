//
//  LXVideoCacheManager.m
//  LXCoretextLean
//
//  Created by tang on 17/4/28.
//  Copyright © 2017年 tang. All rights reserved.
//

#import "LXVideoCacheManager.h"

@interface LXVideoCacheManager()

@property (nonatomic, copy) NSString *cachePath;
@end

@implementation LXVideoCacheManager

+ (instancetype)defaultManager {
    static dispatch_once_t onceToken;
    static LXVideoCacheManager *instance;
    dispatch_once(&onceToken, ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *cachePath = [docPath stringByAppendingPathComponent:@"video"];
        
        BOOL directory = true;
        if (![fileManager fileExistsAtPath:cachePath isDirectory:&directory]) {
            NSError *error;
            [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:true attributes:nil error:&error];
            if (error) {
                NSLog(@"create cache directory error: %@", error.description);
            }
        }
        
        instance = [[LXVideoCacheManager alloc] init];
        instance.cachePath = cachePath;
    });
    return instance;
}

- (NSURL *)cacheFile:(NSString *)fileName fileURL:(NSURL *)fromURL {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *cacheURL = [NSURL fileURLWithPath:self.cachePath];
    NSURL *fileURL = [cacheURL URLByAppendingPathComponent:fileName];
    
    if (![fileManager fileExistsAtPath:fileURL.path]) {
        NSError *error;
        [fileManager copyItemAtURL:fromURL toURL:fileURL error:&error];
        if (error) {
            NSLog(@"copy file error: %@", error.description);
            return nil;
        }
    }
    return fileURL;
}

- (NSURL *)localCacheURL:(NSURL *)fileURL {

    NSString *fileName = fileURL.lastPathComponent;
    NSString *cachePath = self.cachePath;
    NSString *filePath = [cachePath stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSURL *cacheURL = [NSURL fileURLWithPath:filePath];
        return cacheURL;
    }
    return nil;
}
@end
