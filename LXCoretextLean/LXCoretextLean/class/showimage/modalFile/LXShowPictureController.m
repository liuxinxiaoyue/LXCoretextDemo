//
//  LXShowPictureController.m
//  Modal
//
//  Created by tang on 16/7/26.
//  Copyright © 2016年 tang. All rights reserved.
//

#import "LXShowPictureController.h"
#import "LXShowPictureCell.h"

#import "UIImageView+WebCache.h"

#import "LXShowModel.h"

#define cellMargin  15.0
@interface LXShowPictureController ()<LXShowPictureCellDelegate>

@property (nonatomic,weak) UILabel *titleLabel;
@end

@implementation LXShowPictureController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)init{

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGSize size = [UIScreen mainScreen].bounds.size;
    layout.itemSize =  CGSizeMake(size.width + cellMargin, size.height);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0.0;
    layout.minimumInteritemSpacing = 0.0;
    if (self = [super initWithCollectionViewLayout:layout]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
    titleLabel.text = [self titleString];
    [self.view addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect frame = CGRectMake(0, 0, screenSize.width + cellMargin, screenSize.height);
    
    self.collectionView.pagingEnabled = YES;
    self.collectionView.frame = frame;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"LXShowPictureCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.showIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LXShowPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    
    // Configure the cell
    LXShowModelResource *resource = self.items[indexPath.row];
    NSURL *url = [NSURL URLWithString:resource.imageUrl];
    [cell.imgView sd_setImageWithURL:url placeholderImage:nil];
    //
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat height = resource.height * ([UIScreen mainScreen].bounds.size.width / resource.width);
    cell.imageWidthConstraint.constant = width;
    if (height > screenHeight) {
        cell.imageHeightConstraint.constant = height;
        cell.scrollView.scrollEnabled = YES;
    } else {
        cell.imageHeightConstraint.constant = screenHeight;
        cell.scrollView.scrollEnabled = NO;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = offsetX / [UIScreen mainScreen].bounds.size.width;
    NSInteger row = self.showIndex / 3;
    NSInteger col = self.showIndex % 3;
    NSInteger currRow = index / 3;
    NSInteger currCol = index % 3;
    CGFloat width = self.currentFrame.size.width;
    CGFloat height = self.currentFrame.size.height;
    CGFloat x = (currCol - col) * (self.paddingX + width) + self.currentFrame.origin.x;
    CGFloat y = (currRow - row) * (self.paddingY + height) + self.currentFrame.origin.y;
    self.currentFrame = CGRectMake(x, y, width, height);

    self.showIndex = index;
    self.titleLabel.text = [self titleString];

    if ([self.delegate respondsToSelector:@selector(showPictureController:didScrollAtIndexPath:)]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.delegate showPictureController:self didScrollAtIndexPath:indexPath];
    }
}

- (void)showPictureCell:(LXShowPictureCell *)cell tapImageView:(UIImageView *)imageView{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)titleString{
   return [NSString stringWithFormat:@"%d/%d",self.showIndex + 1,self.items.count];
}

- (NSArray *)items{
    if (_items == nil) {
        _items = @[];
    }
    return _items;
}

@end
