//
//  LXTransition.h
//  Modal
//
//  Created by tang on 16/4/6.
//  Copyright © 2016年 tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXTransition : NSObject<UIViewControllerTransitioningDelegate>

@property (nonatomic,assign) CGRect originFrame;

+ (instancetype)shareTransition;
@end
