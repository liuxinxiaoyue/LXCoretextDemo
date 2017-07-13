//
//  LXViewModel.m
//  LXCoretextLean
//
//  Created by tang on 17/3/30.
//  Copyright © 2017年 tang. All rights reserved.
//

#import "LXViewModel.h"

#import "NSString+LXCalculateSize.h"
#import "LXImageMode.h"

static CGFloat avatorMarginTop = 10;
static CGFloat avatorMarginLeft = 10;
static CGFloat avatorWH = 45.0;

static CGFloat nicknameMarginAvator = 10;

static CGFloat contentMarginNickname = 5;
static CGFloat contentMarginRight = 10;
static CGFloat contentMarginBottom = 10;

@implementation LXViewModel

- (void)setShowModel:(LXShowModel *)showModel {
    _showModel = showModel;
    
    CGRect bound = [UIScreen mainScreen].bounds;
    CGFloat minHeight = avatorWH + avatorMarginTop + contentMarginBottom;
    
    // 头像
    _avatorFrame = CGRectMake(avatorMarginLeft, avatorMarginTop, avatorWH, avatorWH);
    _totalHeight += avatorMarginTop;
    
    // 名字
    CGFloat nicknameHeight = 30.0;
    _nickNameLayout = [[LXLayout alloc] init];
    _nickNameLayout.text = showModel.nickname;
    CGFloat width = [_nickNameLayout widthWithMaxHeight:nicknameHeight];
    _nicknameFrame = CGRectMake(CGRectGetMaxX(_avatorFrame) + nicknameMarginAvator, avatorMarginTop, width, nicknameHeight);
    _totalHeight += nicknameHeight + contentMarginNickname;
    
    // 内容
    CGFloat contentWidth = CGRectGetWidth(bound) - avatorMarginLeft - contentMarginRight;
    _contentLayout = [[LXLayout alloc] init];
    _contentLayout.text = showModel.content;
    CGFloat contentHeight = [_contentLayout heigtWithMaxWidth:contentWidth];
    contentHeight = contentHeight < 300 ? contentHeight : 300;
    _contentFrame = CGRectMake(CGRectGetMinX(_avatorFrame), CGRectGetMaxY(_avatorFrame) + contentMarginNickname, contentWidth, contentHeight);
    _totalHeight += contentHeight + contentMarginBottom;
    
    // 视频
    if (showModel.contentType == LXShowModelTypeVideo) {
        CGFloat maxContentY = CGRectGetMaxY(_contentFrame);
        CGFloat maxAvatorY = CGRectGetMaxY(_avatorFrame);
        CGFloat videoY = maxContentY > maxAvatorY ? maxContentY : maxAvatorY + contentMarginBottom;
        _playerFrame = CGRectMake(avatorMarginLeft, videoY, CGRectGetWidth(bound) - 2 * avatorMarginLeft, 150);
        _totalHeight += 150 + contentMarginBottom;
    } else if (showModel.contentType == LXShowModelTypeImage) {
        CGFloat maxContentY = CGRectGetMaxY(_contentFrame);
        CGFloat maxAvatorY = CGRectGetMaxY(_avatorFrame);
        CGFloat imageViewY = (maxContentY > maxAvatorY ? maxContentY : maxAvatorY) + contentMarginBottom;
        CGFloat imageViewX = avatorMarginLeft;
        CGFloat imageViewWidth = CGRectGetWidth(bound) - 2 * avatorMarginLeft;
        CGFloat imageViewHeight = 0;
        int index = 0;
        NSInteger pictCount = showModel.resources.count;
        CGFloat width = 0;
        LXShowModelResource *first = showModel.resources.firstObject;
        CGFloat scale = 1;
        CGFloat height = floorf(first.height * scale);
        switch (pictCount) {
            case 1:
                width = (CGRectGetWidth(bound) - 2 * avatorMarginLeft) / 2;
                scale = width / first.width;
                height = floorf(first.height * scale);
                break;
                
            default:
                width = floorf((imageViewWidth - 10 * 2) / 3);
                height = width;
                break;
        }
        NSMutableArray *imgs = [NSMutableArray array];
        for (LXShowModelResource *temp in showModel.resources) {
            CGFloat x = (index % 3) * (width + 10);
            CGFloat y = (index / 3) * (height + 10);
            LXImageMode *mode = [[LXImageMode alloc] init];
            mode.frame = CGRectMake(x, y, width, height);
            mode.url = [NSURL URLWithString:temp.imageUrl];
            [imgs addObject:mode];
            index += 1;
        }
        int line = index % 3 == 0 ? index / 3 : index / 3 + 1;
        imageViewHeight = line * height + (line - 1) * 10;
        _imgViewFrame = CGRectMake(imageViewX, imageViewY, imageViewWidth, imageViewHeight);
        _imgsMode = [imgs copy];
        _totalHeight += imageViewHeight + contentMarginBottom + contentMarginBottom;
    }
    if (_totalHeight < minHeight) {
        _totalHeight = minHeight;
    }
}
@end
