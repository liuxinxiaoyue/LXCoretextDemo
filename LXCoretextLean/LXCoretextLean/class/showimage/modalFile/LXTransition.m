//
//  LXTransition.m
//  Modal
//
//  Created by tang on 16/4/6.
//  Copyright © 2016年 tang. All rights reserved.
//

#import "LXTransition.h"
#import "LXAnimationTransition.h"
#import "LXPresentationController.h"

@implementation LXTransition

+ (instancetype)shareTransition{
    static dispatch_once_t onceToken;
    static LXTransition *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[LXTransition alloc] init];
        instance.originFrame = CGRectZero;
    });
    return instance;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    NSLog(@"%s",__func__);
    LXAnimationTransition *trans = [LXAnimationTransition defaultAnimationTransition];
    trans.originFrame = self.originFrame;

    trans.presented = YES;
    return trans;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    NSLog(@"%s",__func__);
    LXAnimationTransition *trans = [LXAnimationTransition defaultAnimationTransition];
    trans.originFrame = self.originFrame;
    trans.presented = NO;
    return trans;
}


//- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
//    NSLog(@"%s",__func__);
//    LXPresentationController *presVC = [[LXPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
//    return presVC;
//}
@end
