//
//  LXShowPictureCell.h
//  Modal
//
//  Created by tang on 16/7/26.
//  Copyright © 2016年 tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LXShowPictureCell;
@protocol LXShowPictureCellDelegate <NSObject>

@optional
- (void)showPictureCell:(LXShowPictureCell *)cell tapImageView:(UIImageView *)imageView;

@end
@interface LXShowPictureCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (nonatomic,weak) id<LXShowPictureCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidthConstraint;
@end
