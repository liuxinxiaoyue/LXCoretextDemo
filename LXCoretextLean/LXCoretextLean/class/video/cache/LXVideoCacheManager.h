//
//  LXVideoCacheManager.h
//  LXCoretextLean
//
//  Created by tang on 17/4/28.
//  Copyright © 2017年 tang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXVideoCacheManager : NSObject

+ (instancetype)defaultManager;


/**
 从fromURL将文件缓存起来

 @param fileName 文件名
 @param fromURL 初始文件URL
 @return url
 */
- (NSURL *)cacheFile:(NSString *)fileName fileURL:(NSURL *)fromURL;

/**
 返回本地视频文件的URL

 @param fileURL 文件URL(http请求)
 @return 本地文件URL
 */
- (NSURL *)localCacheURL:(NSURL *)fileURL;
@end
