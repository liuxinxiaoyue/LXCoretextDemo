//
//  LXDisplayView.h
//  LXCoretextLean
//
//  Created by tang on 17/3/8.
//  Copyright © 2017年 tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

#import "UIView+LXExtension.h"

#import "LXAttributeStringParser.h"
#import "LXCoretextDataManager.h"
#import "LXDealEventManager.h"

@class LXDisplayView;

@protocol LXDisplayViewDelegate <NSObject>

- (void)touchDisplayView:(LXDisplayView *)view url:(NSString *)url;

@end

@interface LXDisplayView : UIView

@property (nonatomic, strong) LXCoretextDataManager *manager;
@end
