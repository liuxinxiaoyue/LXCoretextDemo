//
//  LXShowModel.h
//  LXCoretextLean
//
//  Created by tang on 17/3/28.
//  Copyright © 2017年 tang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LXShowModelType) {
    LXShowModelTypeText,
    LXShowModelTypeImage,
    LXShowModelTypeVideo,
};

@class LXShowModelResource;
@interface LXShowModel : NSObject

@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) LXShowModelType contentType;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSArray<LXShowModelResource *> *resources;
@end

@interface LXShowModelResource : NSObject

@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *videoUrl;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@end
