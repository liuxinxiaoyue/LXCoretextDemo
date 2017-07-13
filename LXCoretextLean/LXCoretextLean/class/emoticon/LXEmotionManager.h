//
//  LXEmotionManager.h
//  LXCoretextLean
//
//  Created by tang on 2017/5/8.
//  Copyright © 2017年 tang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXEmotionManager : NSObject

+ (instancetype)defaultManager;

- (NSString *)emotionWithString:(NSString *)str;
@end

@interface LXEmotionGroup : NSObject

@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, strong) NSNumber *version;
@property (nonatomic, strong) NSNumber *displayOnly;
@end

typedef NS_ENUM(NSInteger, LXEmotionType) {
    LXEmotionTypeUserdefine,
    LXEmotionTypeSys,
};
@interface LXEmotion : NSObject

@property (nonatomic, copy) NSString *chs;
@property (nonatomic, copy) NSString *cht;
@property (nonatomic, copy) NSString *gif;
@property (nonatomic, copy) NSString *png;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, assign) LXEmotionType type;
@end
