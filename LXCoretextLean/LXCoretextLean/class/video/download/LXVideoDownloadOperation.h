//
//  LXVideoDownloadOperation.h
//  LXCoretextLean
//
//  Created by tang on 17/4/28.
//  Copyright © 2017年 tang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DownloadProgressBlock)(float percent);
typedef void(^DownloadFinishBlock)(NSURL *fileURL);
typedef void(^DownloadErrorBlock)(NSError *error);

@interface LXVideoDownloadOperation : NSOperation

@property (nonatomic, copy) NSURL *url;
@property (nonatomic, copy) DownloadProgressBlock progressCallBack;

- (instancetype)initWithVideoURL:(NSURL *)url;
@end

FOUNDATION_EXPORT NSString *LXVideoDownloadCompleteNotification;
