//
//  LXShowPictureController.h
//  Modal
//
//  Created by tang on 16/7/26.
//  Copyright © 2016年 tang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LXShowPictureController;

@protocol LXShowPictureControllerDelegate <NSObject>

@optional
- (void)showPictureController:(LXShowPictureController *)controller didScrollAtIndexPath:(NSIndexPath *)indexPath;

- (void)showPictureController:(LXShowPictureController *)controller didSelectIndexPath:(NSIndexPath *)indexPath;

@end

@interface LXShowPictureController : UICollectionViewController

@property (nonatomic,strong) NSArray *items;
@property (nonatomic,assign) NSInteger showIndex;
@property (nonatomic,assign) CGRect currentFrame;
@property (nonatomic,assign) CGFloat paddingX;
@property (nonatomic,assign) CGFloat paddingY;
@property (nonatomic,weak) id<LXShowPictureControllerDelegate> delegate;
@end
