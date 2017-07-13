//
//  LXPresentationController.m
//  Modal
//
//  Created by tang on 16/4/6.
//  Copyright © 2016年 tang. All rights reserved.
//

#import "LXPresentationController.h"

@implementation LXPresentationController

- (CGRect)frameOfPresentedViewInContainerView{
    NSLog(@"%s",__func__);
    return  [super frameOfPresentedViewInContainerView];
}

- (void)presentationTransitionWillBegin
{
    //    NSLog(@"presentationTransitionWillBegin");
    
    self.presentedView.frame = self.containerView.bounds;
    [self.containerView addSubview:self.presentedView];
    
}

- (void)presentationTransitionDidEnd:(BOOL)completed
{
    //    NSLog(@"presentationTransitionDidEnd");
}

- (void)dismissalTransitionWillBegin
{
    //    NSLog(@"dismissalTransitionWillBegin");
}

- (void)dismissalTransitionDidEnd:(BOOL)completed
{
    //    NSLog(@"dismissalTransitionDidEnd");
    [self.presentedView removeFromSuperview];
}
@end
