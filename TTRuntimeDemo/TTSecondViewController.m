//
//  TTSecondViewController.m
//  TTRuntimeDemo
//
//  Created by zhang liangwang on 17/4/17.
//  Copyright © 2017年 zhangliangwang. All rights reserved.
//

#import "TTSecondViewController.h"
#import "TTThirdViewController.h"

@interface TTSecondViewController ()

@end

@implementation TTSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    TTThirdViewController *vc = [[TTThirdViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}


- (void)dealloc {
    
    NSLog(@"--TTSecondViewController---");
}


@end
































