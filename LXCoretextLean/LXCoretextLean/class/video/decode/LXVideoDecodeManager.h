//
//  LXVideoDecodeManager.h
//  LXCoretextLean
//
//  Created by tang on 17/4/28.
//  Copyright © 2017年 tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXVideoDecodeOperation.h"

@interface LXVideoDecodeManager : NSObject

+ (instancetype)defaultManager;

- (void)decodeFileURL:(NSURL *)url
        perFrameBlock:(LXVideoDecodePerFrameBlock)frameBlock
        completeBlock:(LXVideoDecodeFinishBlock)finishBlock
           errorBlock:(LXVideoDecodeErrorBlock)errorBlock;

- (void)cancelDecodeByURL:(NSURL *)url;
@end
