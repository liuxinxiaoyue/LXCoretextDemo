//
//  LXVideoDecodeOperation.h
//  LXCoretextLean
//
//  Created by tang on 17/4/28.
//  Copyright © 2017年 tang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LXVideoDecodePerFrameBlock)(CGImageRef imageRef, CGFloat percent);
typedef void(^LXVideoDecodeFinishBlock)(void);
typedef void(^LXVideoDecodeErrorBlock)(NSError *error);

@interface LXVideoDecodeOperation : NSOperation

@property (nonatomic, strong) NSURL *fileURL;
@property (nonatomic, copy) LXVideoDecodeFinishBlock finishBlock;
@property (nonatomic, copy) LXVideoDecodePerFrameBlock frameBlock;
@property (nonatomic, copy) LXVideoDecodeErrorBlock errorBlock;

- (instancetype)initDecodeVideoURL:(NSURL *)localURL
                     perFrameBlock:(LXVideoDecodePerFrameBlock)frameBlock
                     completeBlock:(LXVideoDecodeFinishBlock)finishBlock
                        errorBlock:(LXVideoDecodeErrorBlock)errorBlock;
@end
