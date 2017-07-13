//
//  LXControllerTransition.m
//  Modal
//
//  Created by tang on 16/4/6.
//  Copyright © 2016年 tang. All rights reserved.
//

#import "LXAnimationTransition.h"
#import "UIView+Extension.h"
#import "LXShowPictureController.h"
#import "UIImageView+WebCache.h"
#import "LXShowModel.h"

@interface LXAnimationTransition ()


@end
@implementation LXAnimationTransition

+ (instancetype)defaultAnimationTransition{
    static dispatch_once_t onceToken;
    static LXAnimationTransition *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[LXAnimationTransition alloc] init];
        instance.originFrame = CGRectZero;
    });
    return instance;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 1.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    NSLog(@"%s",__func__);
    if (self.presented) {
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        LXShowPictureController *showVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        toView.alpha = 0.0;
        
        //
        UIView *containView = [transitionContext containerView];
        [containView addSubview:toView];
        
        //空白遮盖
        UIView *layer = [[UIView alloc] init];
        layer.backgroundColor = [UIColor whiteColor];
        layer.frame = self.originFrame;
        [containView addSubview:layer];
        
        //动画视图
        UIImageView *animationView = [UIImageView new];
        animationView.contentMode = UIViewContentModeScaleAspectFit;
        LXShowModelResource *resource = showVC.items[showVC.showIndex];
        NSURL *url = [NSURL URLWithString:resource.imageUrl];
        [animationView sd_setImageWithURL:url placeholderImage:nil];
        animationView.frame = self.originFrame;
        [containView addSubview:animationView];
        CGRect endFrame = [self contvertToFitKeywindowSize:animationView.image.size];
        [UIView transitionWithView:animationView duration:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            animationView.frame = endFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
            toView.alpha = 1.0;
            [animationView removeFromSuperview];
            [layer removeFromSuperview];
        }];
        
    } else {
        UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        LXShowPictureController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIView *containView = [transitionContext containerView];
        //当前显示的index
        NSInteger currentIndex = fromVC.showIndex;
        
        fromView.alpha = 0.0;
        
        //空白遮盖
        UIView *layer = [[UIView alloc] init];
        layer.backgroundColor = [UIColor whiteColor];
        layer.frame = fromVC.currentFrame;
        [containView addSubview:layer];
        
        //
        UIImageView *animationView = [UIImageView new];
        animationView.contentMode = UIViewContentModeScaleAspectFit;
        LXShowModelResource *resource = fromVC.items[currentIndex];
        NSURL *url = [NSURL URLWithString:resource.imageUrl];
        [animationView sd_setImageWithURL:url placeholderImage:nil];
        animationView.frame = [self contvertToFitKeywindowSize:animationView.image.size];
        [containView addSubview:animationView];
        
        [UIView animateWithDuration:0.5 animations:^{
            animationView.frame = fromVC.currentFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];

            [animationView removeFromSuperview];
            [layer removeFromSuperview];
        }];
    }
}

- (CGRect)contvertToFitKeywindowSize:(CGSize)imageSize{
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat x = 0;
    CGFloat width = size.width;
    CGFloat height = imageSize.width * size.height / size.width;
    CGFloat y = (size.height - height) / 2;
    return CGRectMake(x, y, width, height);
}
@end
