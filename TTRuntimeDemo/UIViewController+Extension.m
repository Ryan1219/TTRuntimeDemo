//
//  UIViewController+Extension.m
//  TTRuntimeDemo
//
//  Created by zhang liangwang on 17/4/17.
//  Copyright © 2017年 zhangliangwang. All rights reserved.
//

#import "UIViewController+Extension.h"
#import <objc/runtime.h>

@implementation UIViewController (Extension)

+ (void)load {
    // 使用这个是NSSelectorFromString在ARC禁止，
    Method method1 = class_getInstanceMethod([self class], NSSelectorFromString(@"dealloc"));
    
    Method mehtod2 = class_getInstanceMethod([self class], @selector(ttDealloc));
    // 交换
    method_exchangeImplementations(method1, mehtod2);
}

- (void)ttDealloc {
    
    NSLog(@"------%@--ttDealloc",self);
    // 再次调用方法，并不会死循环，而是交互方法后，是系统原生的方法也继续有作用
    [self ttDealloc];
}

@end
