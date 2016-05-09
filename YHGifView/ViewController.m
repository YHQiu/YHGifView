//
//  ViewController.m
//  YHGifView
//
//  Created by 邱弘宇 on 16/4/5.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "ViewController.h"
#import "YHGifView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[NSNotificationCenter defaultCenter]addObserverForName:YHGifViewNotificationKey_TapGIFView object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
//        NSString *gifName = [NSString stringWithFormat:@"gif%u",arc4random()%4 + 1];
//        [YHGifView showWithGIFNamed:gifName animation:NO];
//        [YHGifView dismissDelay];
//    }];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dismiss:(id)sender {
    [YHGifView dismiss];
}
- (IBAction)show:(id)sender {
    [YHGifView show];
}

- (IBAction)showWithMaskType:(id)sender {
     [YHGifView showWithGIFNamed:@"gif1" maskType:YHGifViewMaskTypeBlack];
}
- (IBAction)showWithStatus:(id)sender {
    [YHGifView showWithStatus:@"加载中..." gifNamed:@"gif5"];
}
- (IBAction)showWithStausMasktype:(id)sender {
    [YHGifView showWithStatus:@"请稍候..." gifNamed:@"gif2" maskType:YHGifViewMaskTypeBlack];
}
- (IBAction)showAuto:(id)sender {
    NSString *gifName = [NSString stringWithFormat:@"gif%u",arc4random()%4 + 1];
    [YHGifView sharedInstance].baseWidth = 66;
    [YHGifView sharedInstance].baseHeight = 66;
    [YHGifView showWithGIFNamed:gifName];
    [YHGifView dismissDelay];
    [YHGifView sharedInstance].baseWidth = 0;
    [YHGifView sharedInstance].baseHeight = 0;
}
- (IBAction)showWithURL:(id)sender {
    [YHGifView showWithURL:@"http://img5q.duitang.com/uploads/item/201411/22/20141122124903_tYYds.gif" placeHoldNamed:@"gif2"];
    [YHGifView dismissDelay];
}
- (IBAction)showWithURLMaskType:(id)sender {
    [YHGifView showWithURL:@"http://img5q.duitang.com/uploads/item/201411/22/20141122124903_tYYds.gif"maskType:YHGifViewMaskTypeBlack];
    [YHGifView dismissDelay];
}
- (IBAction)ShowWithStatusURLMaskType:(id)sender {
    [YHGifView showWithStatus:@"Please Waiting..." URL:@"http://pic30.nipic.com/20130618/13006969_043837967000_2.gif" placeHodlNamed:@"gif4"  maskType:YHGifViewMaskTypeBlack];
//    [YHGifView dismissDelay];
}
- (IBAction)showWithStatusAutoDismiss:(id)sender {
    [YHGifView showOnlyStatus:@"注册完成,请前往个人中心完善信息"];
}

@end
