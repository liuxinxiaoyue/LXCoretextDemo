//
//  ViewController.m
//  LXCoretextLean
//
//  Created by tang on 17/3/8.
//  Copyright © 2017年 tang. All rights reserved.
//

#import "ViewController.h"
#import "LXShowPictureController.h"
#import "LXTransition.h"

#import "LXShowTableViewCell.h"

#import "MJExtension.h"
#import "LXShowModel.h"
#import "LXViewModel.h"
#import "LXLabel.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, LXShowTableViewCellDelegate>

@property (nonatomic, strong) NSArray<LXViewModel *> *items;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign) BOOL tableViewScrolling;
@property (nonatomic, strong) UIView *playView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, assign) BOOL scrolling;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 获取数据 --> 解析成模型  --> 计算高度  --> draw
    // 存入数据库
    
    NSMutableArray *datas = [NSMutableArray array];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"data.json" withExtension:nil];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *items = dic[@"data"];
    [items enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LXShowModel *temp = [LXShowModel mj_objectWithKeyValues:obj];
        LXViewModel *viewModel = [[LXViewModel alloc] init];
        viewModel.showModel = temp;
        [datas addObject:viewModel];
    }];
    self.items = [datas copy];
    
    CGRect frame = self.view.bounds;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [tableView registerClass:[LXShowTableViewCell class] forCellReuseIdentifier:@"reuse"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    LXShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LXViewModel *model = self.items[indexPath.row];
    [cell configWithViewModel:model];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LXViewModel *model = self.items[indexPath.row];
    return model.totalHeight;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

// 看不见cell时调用
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%s, indexPath.row %ld", __func__, indexPath.row);
    LXViewModel *viewModel = self.items[indexPath.row];
    if (viewModel.showModel.contentType == LXShowModelTypeVideo) {
        LXShowModelResource *resource = viewModel.showModel.resources.firstObject;
        NSURL *url = [NSURL URLWithString:resource.videoUrl];
        LXShowTableViewCell *showCell = (LXShowTableViewCell *)cell;
        [showCell.playerView pauseVideoWithURL:url];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"%s", __func__);
    self.scrolling = false;
    CGFloat deviceHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat minShowVideoOffsetY = contentOffsetY + 100;
    CGFloat maxShowVideoOffsetY = contentOffsetY + deviceHeight - 100;
    
    NSArray *visibleIndexPathes = [self.tableView indexPathsForVisibleRows];
    @weakObj(self);
    [visibleIndexPathes enumerateObjectsUsingBlock:^(NSIndexPath *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongObj(self);
        LXViewModel *viewModel = self.items[obj.row];
        if (viewModel.showModel.contentType == LXShowModelTypeVideo) {
            LXShowTableViewCell *cell = [self.tableView cellForRowAtIndexPath:obj];
            CGRect frame = cell.frame;
            if (CGRectGetMinY(frame) >= minShowVideoOffsetY && CGRectGetMaxY(frame) <= maxShowVideoOffsetY) {
                
                LXShowModelResource *resource = viewModel.showModel.resources.firstObject;
                [cell.playerView playVideoWithURL:[NSURL URLWithString:resource.videoUrl]];
            }
        }
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"%s", __func__);
    self.scrolling = true;
}

#pragma mark - LXShowTableViewCellDelegate
- (void)showCell:(LXShowTableViewCell *)cell tapImageView:(UIImageView *)imageView {
//    CGRect frame = [self.view convertRect:imageView.frame fromView:cell.imgsView];
    CGRect frame = [cell.imgsView convertRect:imageView.frame toView:self.view];
    LXShowPictureController *pictrueVC = [[LXShowPictureController alloc] init];
    pictrueVC.paddingX = 10;
    pictrueVC.paddingY = 10;
    pictrueVC.currentFrame = frame;
    pictrueVC.showIndex = imageView.tag;
    pictrueVC.items = [cell.model.showModel.resources copy];
    
    pictrueVC.modalPresentationStyle = UIModalPresentationCustom;
    LXTransition *transition = [LXTransition shareTransition];
    transition.originFrame = frame;
    pictrueVC.transitioningDelegate = transition;
    
    [self presentViewController:pictrueVC animated:true completion:nil];
}

- (NSArray *)items {
    if (nil == _items) {
        _items = [NSArray array];
    }
    return _items;
}
@end
