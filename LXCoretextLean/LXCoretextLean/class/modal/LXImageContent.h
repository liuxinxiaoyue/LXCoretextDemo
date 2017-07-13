//
//  LXImageContent.h
//  LXCoretextLean
//
//  Created by tang on 17/3/8.
//  Copyright © 2017年 tang. All rights reserved.
//

#import "LXNormalContent.h"

@interface LXImageContent : LXNormalContent

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat descent;
@property (nonatomic, assign) CGRect imagePosition;
@end
