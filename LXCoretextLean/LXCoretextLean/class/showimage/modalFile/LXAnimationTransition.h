//
//  LXControllerTransition.h
//  Modal
//
//  Created by tang on 16/4/6.
//  Copyright © 2016年 tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXAnimationTransition : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic,assign) BOOL presented;
@property (nonatomic,assign) CGRect originFrame;

+ (instancetype)defaultAnimationTransition;
@end
