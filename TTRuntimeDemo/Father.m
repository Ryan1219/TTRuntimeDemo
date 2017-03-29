//
//  Father.m
//  TTRuntimeDemo
//
//  Created by zhangliangwang on 17/1/8.
//  Copyright © 2017年 zhangliangwang. All rights reserved.
//

#import "Father.h"
#import "Son.h"
#import <objc/runtime.h>


@interface Father ()
{
    NSNumber *_age;
}

@end

@implementation Father


- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        self.name = @"zhangliangwang";
        self.height = @165;
        _age = @26;
    }
    
    return self;
}


- (NSString *)description {
    
    return [NSString stringWithFormat:@"name:%@--height:%@--age:%@",self.name,self.height,_age];
}


- (void)metting {
    
    NSLog(@"%@ today i meeting a beautiful flower",self.name);
}

- (void)leave {
    
    NSLog(@"%@ today leave home",self.name);
}


+ (void)eat {
    
    NSLog(@"fish is very good");
}

- (NSNumber *)returnHeightWithParam1:(NSNumber *)num1 param2:(NSNumber *)num2 {
    
    
    return [NSNumber numberWithInteger:(num1.integerValue+num2.integerValue)];
}

//MARK:-消息转发机制
// 1,方法的动态解析
//实例方法,对象收到未知消息会调用所属类的方法，为未知消息新增一个处理方法
//+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    
//    NSLog(@"--方法的动态解析－－");
//    NSString *selName = NSStringFromSelector(sel);
//    if ([selName isEqualToString:@"unknowData"]) {
//        
//        class_addMethod([self class], @selector(unknowData),(IMP)addMethod,"v@:");
//        
//        return true;
//    }
//    
//    return false;
//}
//
////类方法,调用父类方法解析
//+ (BOOL)resolveClassMethod:(SEL)sel {
//    
//    return [super resolveClassMethod:sel];
//
//}
//
//void addMethod() {
//    
//    NSLog(@"---接受到了消----%s",__func__);
//}

//2,备用接收者
//- (id)forwardingTargetForSelector:(SEL)aSelector {
//    
//    NSLog(@"--备用接收者--");
//    NSString *selName = NSStringFromSelector(aSelector);
//    if ([selName isEqualToString:@"testMethod"]) {
//        
//        return [[Son alloc] init];
//    }
//    
//    return [super forwardingTargetForSelector:aSelector];
//}

//3,完整的消息转发
//1,我们首先要通过,指定方法签名，则表示处理，若返回nil，则表示不处理
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    
    NSLog(@"--指定方法签名--");
    NSString *selName = NSStringFromSelector(aSelector);
    if ([selName isEqualToString:@"testMethod"]) {
        
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    
    return [super methodSignatureForSelector:aSelector];
}

//通过anInvocation对象做很多处理，比如修改实现方法，修改响应对象等
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
    //改变响应对象
//    [anInvocation invokeWithTarget:[[Son alloc] init]];
    
    //改变响应方法
//    [anInvocation setSelector:@selector(newTestMethod1)];
    
    //改变响应对象并改变响应方法
    [anInvocation invokeWithTarget:[[Son alloc] init]];
    [anInvocation setSelector:@selector(newTestMethod)];
    
}

//改变响应方法接收的实体
- (void)newTestMethod1 {
    
    NSLog(@"--%s--",__func__);
}
//消息没有识别会调用该方法
- (void)doesNotRecognizeSelector:(SEL)aSelector {
    
    NSLog(@"----％@---",NSStringFromSelector(aSelector));
}


@end








































