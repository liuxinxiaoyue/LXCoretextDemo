//
//  LXEmotionManager.m
//  LXCoretextLean
//
//  Created by tang on 2017/5/8.
//  Copyright © 2017年 tang. All rights reserved.
//

#import "LXEmotionManager.h"
#import "MJExtension.h"

@interface LXEmotionManager()

@property (nonatomic, strong) NSDictionary *emotions;
@end

@implementation LXEmotionManager

+ (instancetype)defaultManager {
    static dispatch_once_t onceToken;
    static LXEmotionManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[LXEmotionManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmoticonWeibo" ofType:@"bundle"];
        [self emotionsAtPath:path];
    }
    return self;
}

- (void)emotionsAtPath:(NSString *)bundlePath {
    NSString *emoticonsPath = [bundlePath stringByAppendingPathComponent:@"emoticons.plist"];
    NSDictionary *emoticonsDic = [NSDictionary dictionaryWithContentsOfFile:emoticonsPath];
    if (!(emoticonsDic && emoticonsDic[@"packages"])) {
        return;
    }

    NSMutableDictionary *chinaSimpleEmotion = [NSMutableDictionary dictionary];
    for (NSDictionary *items in emoticonsDic[@"packages"]) {
        LXEmotionGroup *group = [LXEmotionGroup mj_objectWithKeyValues:items];
        NSString *groupPath = [bundlePath stringByAppendingPathComponent:group.groupId];
        NSString *groupEmotionPath = [groupPath stringByAppendingPathComponent:@"info.plist"];
        NSDictionary *groupEmotion = [NSDictionary dictionaryWithContentsOfFile:groupEmotionPath];
        if (groupEmotion && groupEmotion[@"emoticons"]) {
            for (NSDictionary *temp in groupEmotion[@"emoticons"]) {
                LXEmotion *emotion = [LXEmotion mj_objectWithKeyValues:temp];
                emotion.groupId = group.groupId;
                if (emotion.type != LXEmotionTypeUserdefine) {
                    continue;
                }
                if (emotion.chs && emotion.png) {
                    chinaSimpleEmotion[emotion.chs] = emotion;
                }
            }
        }
    }
    self.emotions = [chinaSimpleEmotion copy];
}

- (NSString *)emotionWithString:(NSString *)str {
    if (!([str isKindOfClass:[NSString class]] && str.length > 0)) {
        return nil;
    }
    LXEmotion *emotion = self.emotions[str];
    NSString *name = emotion.png;
    if ([name hasSuffix:@"@3x.png"]) {
        name = [name componentsSeparatedByString:@"@3x.png"].firstObject;
    } else if ([name hasSuffix:@"@2x.png"]) {
        name = [name componentsSeparatedByString:@"@2x.png"].firstObject;
    } else if ([name hasSuffix:@".png"]) {
        name = [name componentsSeparatedByString:@".png"].firstObject;
    }
    name = [NSString stringWithFormat:@"EmoticonWeibo.bundle/%@/%@", emotion.groupId, name];
    return name;
}
@end

@implementation LXEmotionGroup

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"groupId": @"id",
             @"displayOnly": @"display_only"
             };
}
@end

@implementation LXEmotion


@end
