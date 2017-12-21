//
//  ViewController.m
//  GestureCipher
//
//  Created by x on 2017/12/21.
//  Copyright © 2017年 HLB. All rights reserved.
//

#import "ViewController.h"
#import "LockView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LockView *lock = [[LockView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width)];
    
    [self.view addSubview:lock];
    
}


@end
