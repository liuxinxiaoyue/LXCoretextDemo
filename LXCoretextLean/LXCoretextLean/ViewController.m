//
//  ViewController.m
//  LXCoretextLean
//
//  Created by tang on 17/3/8.
//  Copyright © 2017年 tang. All rights reserved.
//

#import "ViewController.h"

#import "LXDisplayView.h"

#import "LXFrameParser.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet LXDisplayView *displayView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    LXFrameParsesConfig *config = [[LXFrameParsesConfig alloc] init];
    config.width = self.displayView.width;
    config.height = self.displayView.height;

    config.lineSpace = 3.0;
    NSInteger index = 0;
    LXTextContent *t1 = [[LXTextContent alloc] init];
    t1.text = @"1.一个显示用的类，仅负责显示内容，不负责排版\n";
    t1.range = NSMakeRange(0, t1.text.length - 1);
    t1.textColor = [UIColor orangeColor];
    t1.fontSize = 15.0;
    t1.contentType = LXContentTypeText;
    index += t1.text.length;
    
    LXImageContent *t2 = [[LXImageContent alloc] init];
    t2.imageName = @"a.jpg";
    t2.width = 200;
    t2.height = 150;
    t2.range = NSMakeRange(index, 1);
    t2.contentType = LXContentTypeImage;
    index += 1;
    
    LXTextContent *t3 = [[LXTextContent alloc] init];
    t3.text = @"2.一个模型类，用于承载显示所需要的所有数据\n";
    t3.range = NSMakeRange(index, t3.text.length - 1);
    t3.textColor = [UIColor blackColor];
    t3.fontSize = 12.0;
    t3.contentType = LXContentTypeText;
    index += t3.text.length;
    
    LXTextContent *t4 = [[LXTextContent alloc] init];
    t4.text = @"3.一个显示用的类，仅负责显示内容，不负责排版\n";
    t4.range = NSMakeRange(index, t4.text.length - 1);
    t4.textColor = [UIColor purpleColor];
    t4.fontSize = 13.0;
    t4.contentType = LXContentTypeText;
    index += t4.text.length;
    
    LXTextContent *t5 = [[LXTextContent alloc] init];
    t5.text = @"4.一个显示用的类，仅负责显示";
    t5.range = NSMakeRange(index, t5.text.length - 1);
    t5.textColor = [UIColor redColor];
    t5.fontSize = 14.0;
    t5.contentType = LXContentTypeText;
    index += t5.text.length;
    
    LXLinkContent *t6 = [[LXLinkContent alloc] init];
    t6.url = @"www.baidu.com";
    t6.textColor = [UIColor blueColor];
    t6.contentType = LXContentTypeLinker;
    t6.fontSize = 18.0;
    t6.range = NSMakeRange(index, t6.url.length - 1);
    index += t6.url.length;
    
    LXImageContent *t7 = [[LXImageContent alloc] init];
    t7.range = NSMakeRange(index, 1);
    t7.contentType = LXContentTypeImage;
    t7.width = 24.0;
    t7.height = 24.0;
    t7.imageName = @"002@2x.png";
    
    NSArray *contents = @[t1, t2, t3, t4, t5, t6, t7];
    
    NSAttributedString *attr = [LXAttributeStringParser attributeStringWith:contents config:config];
    LXCoretextDataManager *manager = [LXFrameParser parserAttributString:attr withConfig:config];
    manager.imgArray = @[t2, t7];
    manager.linkArray = @[t6];
    self.displayView.manager = manager;
//    self.displayView.height = manager.height;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
