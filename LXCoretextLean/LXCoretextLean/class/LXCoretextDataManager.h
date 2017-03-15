//
//  LXCoretextDataManager.h
//  LXCoretextLean
//
//  Created by tang on 17/3/8.
//  Copyright © 2017年 tang. All rights reserved.
//
//  用于承载显示所需要的数据
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

#import "LXTextContent.h"
#import "LXImageContent.h"
#import "LXLinkContent.h"

@interface LXCoretextDataManager : NSObject

@property (nonatomic, assign) CTFrameRef frameRef;
/** CTFrame的实际高度*/
@property (nonatomic, assign) CGFloat height;
/** 所有图片数据*/
@property (nonatomic, strong) NSArray<LXImageContent *> *imgArray;
/** 所有连接数据*/
@property (nonatomic, strong) NSArray<LXLinkContent *> *linkArray;
@end
