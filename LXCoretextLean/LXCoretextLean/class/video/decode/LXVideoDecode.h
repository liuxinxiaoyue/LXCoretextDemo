//
//  LXVideoDecode.h
//  LXCoretextLean
//
//  Created by tang on 17/4/27.
//  Copyright © 2017年 tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^PreFrameImageBlock)(CGImageRef imageRef, CGFloat percent);
typedef void(^ErrorBlock)(NSError *error);
typedef void(^EndBlock)(void);


@interface LXVideoDecode : NSObject

- (void)decodeVideoPath:(NSString *)filePath
             imageBlock:(PreFrameImageBlock)imgBlock
               endBlock:(EndBlock)endBlock
             errorBlock:(ErrorBlock)errorBlock;

@end
