//
//  NextViewController.m
//  YHGifView
//
//  Created by 邱弘宇 on 16/4/6.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "YHGifView.h"
#import "NextViewController.h"

@interface NextViewController ()

@end

@implementation NextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [YHGifView showWithStatus:@"正在为您上传图片，请稍候..." gifNamed:@"gif5"  maskType:YHGifViewMaskTypeNone];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [YHGifView dismiss];
}

- (IBAction)hideKeyboard:(id)sender {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
