//
//  LXVideoDownloadManager.h
//  LXCoretextLean
//
//  Created by tang on 17/4/28.
//  Copyright © 2017年 tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXVideoDownloadOperation.h"

@interface LXVideoDownloadManager : NSObject

+ (instancetype)defaultManager;

- (void)downloadVideo:(NSURL *)url progrossBlock:(DownloadProgressBlock)progrossBlock finishBlock:(DownloadFinishBlock)finishBlock errorBlock:(DownloadErrorBlock)errorBlock;
@end
