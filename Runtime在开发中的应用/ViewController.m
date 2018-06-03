//
//  ViewController.m
//  Runtime在开发中的应用
//
//  Created by zhen7216 on 2018/6/2.
//  Copyright © 2018 ChenZhen. All rights reserved.
//

#import "ViewController.h"

#import <objc/runtime.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 应用一
    [self traversalPrivateIntanceVariable];
    
    // 应用二
    [self methodExchange];
    
}


/*
 应用一： 查看私有成员变量，并修改其值。（可以修改系统控件的某些属性）
 
 本示例目的：直接修改UITextField的placeholder字体的颜色.
 */
- (void)traversalPrivateIntanceVariable {
    self.textField.placeholder = @"Hello World";
    // 遍历UITextField对象，查找自己需要改变的成员变量
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([UITextField class], &count);
    for (int i = 0; i < count; i++) {
        NSLog(@"成员变量：%s - 类型：%s", ivar_getName(ivars[i]), ivar_getTypeEncoding(ivars[i]));
    }
    
    // 从打印结果中找到的目标：成员变量：_placeholderLabel - 类型：@"UITextFieldLabel"
    // 使用KVC直接修改值
    [self.textField setValue:[UIColor greenColor] forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)methodExchange {
    Method method1 = class_getInstanceMethod([self class], @selector(method1));
    Method method2 = class_getInstanceMethod([self class], @selector(method2));
    method_exchangeImplementations(method1, method2);
    
    [self method1];
}

- (void)method1 {
    NSLog(@"%s", __func__);
}

- (void)method2 {
    NSLog(@"%s", __func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
