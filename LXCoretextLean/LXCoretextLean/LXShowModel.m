//
//  LXShowModel.m
//  LXCoretextLean
//
//  Created by tang on 17/3/28.
//  Copyright © 2017年 tang. All rights reserved.
//

#import "LXShowModel.h"
#import "MJExtension.h"

@implementation LXShowModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"resources": @"LXShowModelResource"
             };
}


- (LXShowModelType)contentType {
    if ([self.type isEqualToString:@"img"]) {
        return LXShowModelTypeImage;
    } else if ([self.type isEqualToString:@"video"]) {
        return LXShowModelTypeVideo;
    }
    return LXShowModelTypeText;
}
@end

@implementation LXShowModelResource

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"imageUrl": @"image_url",
             @"videoUrl": @"video_url"
             };
}
@end
