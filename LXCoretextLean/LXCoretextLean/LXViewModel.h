//
//  LXViewModel.h
//  LXCoretextLean
//
//  Created by tang on 17/3/30.
//  Copyright © 2017年 tang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LXShowModel.h"
#import "LXLayout.h"

@interface LXViewModel : NSObject

@property (nonatomic, strong) LXShowModel *showModel;

@property (nonatomic, assign, readonly) CGRect avatorFrame;

@property (nonatomic, strong) LXLayout *nickNameLayout;
@property (nonatomic, assign, readonly) CGRect nicknameFrame;

@property (nonatomic, strong) LXLayout *contentLayout;
@property (nonatomic, assign, readonly) CGRect contentFrame;

@property (nonatomic, assign, readonly) CGRect imgViewFrame;
@property (nonatomic, strong, readonly) NSArray *imgsMode;

@property (nonatomic, assign, readonly) CGFloat totalHeight;
@property (nonatomic, assign, readonly) CGRect playerFrame;
@property (nonatomic, strong) NSArray *linkArray;
@property (nonatomic, strong) NSArray *themeArray;
@end
