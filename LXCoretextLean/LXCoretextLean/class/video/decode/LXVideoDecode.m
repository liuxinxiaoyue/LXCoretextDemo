//
//  LXVideoDecode.m
//  LXCoretextLean
//
//  Created by tang on 17/4/27.
//  Copyright © 2017年 tang. All rights reserved.
//

#import "LXVideoDecode.h"

@interface LXVideoDecode()

@property (nonatomic, copy) PreFrameImageBlock imgBlock;
@property (nonatomic, copy) EndBlock endBlock;
@property (nonatomic, copy) ErrorBlock errorBlock;
@property (nonatomic, copy) NSString *filePath;
@end

@implementation LXVideoDecode

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)decodeVideoPath:(NSString *)filePath imageBlock:(PreFrameImageBlock)imgBlock endBlock:(EndBlock)endBlock errorBlock:(ErrorBlock)errorBlock {
    
    self.imgBlock = imgBlock;
    self.endBlock = endBlock;
    self.errorBlock = errorBlock;
    self.filePath = filePath;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self beginDecode];
    });
}

- (void)beginDecode {
    NSURL *fileURL = [NSURL fileURLWithPath:self.filePath];
    AVURLAsset *asset = [AVURLAsset assetWithURL:fileURL];
    NSLog(@"%.2f", CMTimeGetSeconds(asset.duration));
    NSError *error;
    // 读取媒体数据的阅读器
    AVAssetReader *reader = [[AVAssetReader alloc] initWithAsset:asset error:&error];
    if (error && self.errorBlock) {
        @weakObj(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongObj(self);
            self.errorBlock(error);
        });
    }
    // 获取视频的轨迹（即视频来源）
    NSArray *videoTracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if (!(videoTracks.count > 0)) {
        if (self.endBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.endBlock();
            });
        }
        return;
    }
    AVAssetTrack *videoTrack = [videoTracks objectAtIndex:0];
    
    // 配置阅读器 （读取的像素、视频压缩等）
    int m_pixelForamtType;
    
    // 视频播放时
    m_pixelForamtType = kCVPixelFormatType_32BGRA;
    // 其它用途 如视频压缩
    //m_pixelForamtType = kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange;
    
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    [options setObject:@(m_pixelForamtType) forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    
    AVAssetReaderTrackOutput *videoReaderOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:videoTrack outputSettings:options];
    
    // 为阅读器添加输出端口 开启阅读器
    [reader addOutput:videoReaderOutput];
    [reader startReading];
    
    CGFloat duration = CMTimeGetSeconds(asset.duration);
    while ([reader status] == AVAssetReaderStatusReading && videoTrack.nominalFrameRate > 0) {
        
        @autoreleasepool {
            // 读取 video sample
            CMSampleBufferRef videoBuffer = [videoReaderOutput copyNextSampleBuffer];
            CGImageRef imageRef = [self imageFromSampleBufferRef:videoBuffer];
            CGFloat percent = 0;
            if (duration != 0) {
                CGFloat curr = CMTimeGetSeconds(CMSampleBufferGetOutputPresentationTimeStamp(videoBuffer));
                percent = curr / duration;
                percent = percent > 1? 1: percent;
            }
            if (videoBuffer) {
                NSLog(@"%.2lf", CMTimeGetSeconds(CMSampleBufferGetOutputPresentationTimeStamp(videoBuffer)));
                CFRelease(videoBuffer);
            }
            if (self.imgBlock && imageRef) {
                @weakObj(self);
                dispatch_async(dispatch_get_main_queue(), ^{
                    @strongObj(self);
                    self.imgBlock(imageRef, percent);
                    CFRelease(imageRef);
                });
            }
            
            // 休眠
            [NSThread sleepForTimeInterval:0.04];
        }
    }
    
    // 解码结束
    if (self.endBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.endBlock();
        });
    }
}

- (CGImageRef)imageFromSampleBufferRef:(CMSampleBufferRef)videoBuffer {
    
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(videoBuffer);
    
    // 锁定 pixel buffer基地址
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    // pixel buffer 基地址
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    // pixel buffer 行字节数
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // pixel buffer 的宽高
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // 基于设备的 RGB 颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // 用抽样缓存的数据创建一个位图格式的图形上下文
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef imageRef = NULL;
    if (context) {
        
        imageRef = CGBitmapContextCreateImage(context);
    }
    
    // 解锁 pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return imageRef;
}

@end
