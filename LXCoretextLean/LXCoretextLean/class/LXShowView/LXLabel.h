//
//  LXLabel.h
//  LXCoretextLean
//
//  Created by tang on 17/3/30.
//  Copyright © 2017年 tang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LXTextVerticalAlignment) {
    LXTextVerticalAlignmentTop,
    LXTextVerticalAlignmentCenter,
    LXTextVerticalAlignmentBottom,
};

@class LXLayout;
@interface LXLabel : UIView

@property (nonatomic, strong) LXLayout *layout;
@property (nonatomic, assign) LXTextVerticalAlignment verticalAlignment;
@end
