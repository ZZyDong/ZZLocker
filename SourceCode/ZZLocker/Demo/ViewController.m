//
//  ViewController.m
//  ZZLocker
//
//  Created by Zhang_yD on 2017/3/24.
//  Copyright © 2017年 Z. All rights reserved.
//

#import "ViewController.h"
#import "ZZLocker.h"

#define ZZScreenWidth [UIScreen mainScreen].bounds.size.width
#define ZZScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController () <ZZLockerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:button1];
    button1.frame = CGRectMake(0, 50, ZZScreenWidth, 50);
    [button1 setTitle:@"新增" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(click1) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:button2];
    button2.frame = CGRectMake(0, 120, ZZScreenWidth, 50);
    [button2 setTitle:@"验证" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(click2) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:button3];
    button3.frame = CGRectMake(0, 190, ZZScreenWidth, 50);
    [button3 setTitle:@"验证 - 底端出现 - 隐藏返回按钮" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(click3) forControlEvents:UIControlEventTouchUpInside];
}

- (void)click1 {
    ZZLocker *locker = [[ZZLocker alloc] init];
    locker.delegate = self;
    locker.lockerType = ZZLockerTypeRegist;
    [locker showFromBottom];
}
- (void)click2 {
    if (![self check]) return;
    ZZLocker *locker = [[ZZLocker alloc] init];
    locker.delegate = self;
    locker.lockerType = ZZLockerTypeVerify;
    [locker show];
}
- (void)click3 {
    if (![self check]) return;
    ZZLocker *locker = [[ZZLocker alloc] init];
    locker.delegate = self;
    locker.lockerType = ZZLockerTypeVerify;
    locker.hideBackButton = YES;
    [locker showFromBottom];
}

- (BOOL)check {
    if (![ZZLocker hasLocalPassCode]) {
        UIAlertController *alerC = [UIAlertController alertControllerWithTitle:@"先创建一个密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
        [alerC addAction:action];
        [self presentViewController:alerC animated:YES completion:nil];
        return NO;
    }
    return YES;
}

#pragma mark - ZZLockerDelegate
- (void)z_locker:(ZZLocker *)locker lockDidComplete:(BOOL)isSuccess {
    NSLog(@"lockDidComplete - success - %ld", isSuccess);
}
- (void)z_lockerForgetButtonDidClick:(ZZLocker *)locker {
    NSLog(@"z_lockerForgetButtonDidClick do something");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [locker close];
    });
}

@end
