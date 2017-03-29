//
//  ViewController.m
//  TTRuntimeDemo
//
//  Created by zhangliangwang on 17/1/8.
//  Copyright © 2017年 zhangliangwang. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "Father.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    Father *father = [[Father alloc] init];
//    [father performSelector:@selector(testMethod)];
    [father performSelector:@selector(testMethod)];
    
    
}

- (void)testRuntiem {
    
    //初始化一个对象
    Father *fatehr = [[Father alloc] init];
    NSLog(@"before runtime -- %@",[fatehr description]);
    
    
    ///MARK:-获取类的所有属性列表，类也是对象
    unsigned int memberCount = 0;
    Ivar *members = class_copyIvarList([Father class], &memberCount);
    
    for (int i = 0; i < memberCount; i++) {
        
        Ivar member  = members[i];
        const char *memberName = ivar_getName(member); //获取变量名
        const char *memberType = ivar_getTypeEncoding(member); //获取变量的类型
        
        NSLog(@"变量名字---%s,变量类型---%s",memberName,memberType);
    }
    
    ///MARK:- set方法,修改类属性的值
    Ivar age = members[0];
    object_setIvar(fatehr, age, @18);
    
    Ivar name = members[1];
    object_setIvar(fatehr, name, @"maoyanhua");
    
    Ivar height = members[2];
    object_setIvar(fatehr, height, @180);
    
    NSLog(@"After runtime -- %@",[fatehr description]);
    
    ///MARK:-get方法，获取类属性的值
    id fatherName = object_getIvar(fatehr, name);
    NSLog(@"name -- %@",fatherName);
    
    
    //MARK:-给类动态添加方法，类也是对象
    /*****************************************
     *   动态给对象添加方法并调用对象新添加的私有方法
     
     BOOL class_addMethod(Class cls, SEL name, IMP imp,
     const char *types)
     
     cls：被添加方法的类
     name：可以理解为方法名
     imp：实现这个方法的函数
     types：一个定义该函数返回值类型和参数类型的字符串，这个具体会在后面讲
     
     
     "i@:@:@"
     i:表示返回值类型是int类型，如果是v的话代表void类型
     第一个@：表示id -> self
     第二个:：表示SEL(_cmd)
     第二个@：表示第一个传入参数
     第三个@：表示第二个传入参数
     *****************************************
     */
    class_addMethod([Father class], @selector(reIntType), (IMP)printInt, "i@:@:@:");
    SEL selector1 = @selector(reIntType);
    int sum = [fatehr performSelector:selector1 withObject:fatherName withObject:nil];
    NSLog(@"添加新方法获得的新值－－－%d",sum);
    
    class_addMethod([Father class], @selector(reVoidType), (IMP)testFunc, "v@:");
    [fatehr performSelector:@selector(reVoidType) withObject:nil withObject:nil];
    
    //MARK:-执行类里面的实例方法
    //不带参数
    SEL selector2 = @selector(metting);
    [fatehr performSelector:selector2];
    
    SEL selector3 = @selector(leave);
    [fatehr performSelector:selector3];
    
    //带参数
    SEL selector4 = @selector(returnHeightWithParam1:param2:);
    id reHeight = [fatehr performSelector:selector4 withObject:@30 withObject:@120];
    NSLog(@"调用带参数的私有方法---%@",reHeight);
    
    //MARK:-执行类里面的类方法
    SEL selector5 = @selector(eat);
    [Father performSelector:selector5];
    
    //MARK:-获得对象的方法列表
    /*****************************************
     *         获得对象的方法列表
     * 1、NSSelectorFromString()通过方法名字符串获得执行的方法等同@selector()
     *
     //调用指定方法的实现
     id method_invoke ( id receiver, Method m, ... );
     
     // 调用返回一个数据结构的方法的实现
     void method_invoke_stret ( id receiver, Method m, ... );
     
     // 获取方法名
     SEL method_getName ( Method m );
     
     // 返回方法的实现
     IMP method_getImplementation ( Method m );
     
     // 获取描述方法参数和返回值类型的字符串
     const char * method_getTypeEncoding ( Method m );
     
     // 获取方法的返回值类型的字符串
     char * method_copyReturnType ( Method m );
     
     // 获取方法的指定位置参数的类型字符串
     char * method_copyArgumentType ( Method m, unsigned int index );
     
     // 通过引用返回方法的返回值类型字符串
     void method_getReturnType ( Method m, char *dst, size_t dst_len );
     
     // 返回方法的参数的个数
     unsigned int method_getNumberOfArguments ( Method m );
     
     // 通过引用返回方法指定位置参数的类型字符串
     void method_getArgumentType ( Method m, unsigned int index, char *dst, size_t dst_len );
     
     // 返回指定方法的方法描述结构体
     struct objc_method_description * method_getDescription ( Method m );
     
     // 设置方法的实现
     IMP method_setImplementation ( Method m, IMP imp );
     
     // 交换两个方法的实现
     void method_exchangeImplementations ( Method m1, Method m2 );
     *****************************************
     */
    //获取类的所有方法列表
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList([Father class], &methodCount);
    for (int i = 0; i < methodCount; i++) {
        SEL selector = method_getName(methods[i]); //OBJC_EXPORT SEL method_getName(Method m)
        NSString *selectorNameString = [NSString stringWithCString:sel_getName(selector) encoding:NSUTF8StringEncoding]; //OBJC_EXPORT const char *sel_getName(SEL sel)
        NSLog(@"方法名:---%@",selectorNameString);
    }
    
    //MARK:-方法交换,类方法与实例方法不可以交换，因为交换后执行类方法报无法识别
    Method method1 = class_getInstanceMethod([Father class], @selector(metting));
    Method method2 = class_getInstanceMethod([Father class], @selector(leave));
    Method method3 = class_getClassMethod([Father class], @selector(eat));
    method_exchangeImplementations(method1, method2);
    
    [fatehr performSelector:@selector(metting)];
    //    [fatehr performSelector:@selector(leave)];
    [fatehr performSelector:@selector(leave)];
    
}

//MARK:-动态添加的方法（IMP，指向具体方法的实现）
int printInt() {
    
    return 100;
}

void testFunc(){
    
    NSLog(@"-------testFunc---");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end










































