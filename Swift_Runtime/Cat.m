//
//  Cat.m
//  Swift_Runtime
//
//  Created by sim on 2018/2/2.
//  Copyright © 2018年 wanglupeng. All rights reserved.
//

#import "Cat.h"
#import <objc/runtime.h>
#import "Person.h"

@implementation Cat


+ (void)swizzlingMehod{
        SEL eatSel = @selector(eat);
        SEL runSel = @selector(run);
        Method eatMethod = class_getInstanceMethod([self class], eatSel);
        Method runMethod = class_getInstanceMethod([self class], runSel);
        method_exchangeImplementations(eatMethod, runMethod);
}


- (void)eat {
    NSLog(@"eat");
    
}
- (void)run {
    NSLog(@"run");
}
- (void)perfonromSelectorMethod {
    [self performSelector:@selector(think) withObject:nil];
    //Cat 没有实现think方法
}

//MARK: 消息转发机制的三个步骤

/*
 +(BOOL)resolveClassMethod:(SEL)sel {
 //动态添加一个类方法 用法跟实例方法类似
 if ([NSStringFromSelector(sel) isEqualToString:@"think"]) {
 class_addMethod(self, sel, (IMP)newThink, "v@:*");
 }
 return YES;
 }
 */

/*
 + (BOOL)resolveInstanceMethod:(SEL)sel{
 //动态添加一个实例方法
     if ([NSStringFromSelector(sel) isEqualToString:@"think"]) {
         class_addMethod(self, sel, (IMP)newThink, "v@:*");
     }
     return YES;
 }
 
 void newThink(id self, SEL _cmd, NSString *string){
     NSLog(@"Cat is thingking");
 }
*/


//在Person类实现think方法
/*
- (id)forwardingTargetForSelector:(SEL)aSelector {
        if ([NSStringFromSelector(aSelector) isEqualToString:@"think"]) {
            return [[Person alloc]init];
        }
    return nil;

}
*/

- (NSMethodSignature*)methodSignatureForSelector:(SEL)aSelector {
    NSLog(@"指定方法签名");
    NSString *selName = NSStringFromSelector(aSelector);
    if ([selName isEqualToString:@"think"]) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    
    return [super methodSignatureForSelector:aSelector];
}
//在Person类实现think方法

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
    if ([NSStringFromSelector(anInvocation.selector) isEqualToString:@"think"]) {
        Person *p =  [[Person alloc]init];
        [anInvocation invokeWithTarget:p];
    }
}
//MARK: -自动归档

- (void)encodeWithCoder:(NSCoder *)aCoder{
    unsigned int outCount = 0;
    Ivar *vars = class_copyIvarList([self class], &outCount);
    for (int i = 0; i < outCount; i ++) {
        Ivar var = vars[i];
        const char *name = ivar_getName(var);
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        unsigned int outCount = 0;
        Ivar *vars = class_copyIvarList([self class], &outCount);
        for (int i = 0; i < outCount; i ++) {
            Ivar var = vars[i];
            const char *name = ivar_getName(var);
            NSString *key = [NSString stringWithUTF8String:name];
            id value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
    }
    return self;
}


//MARK: -runtime 字典转模型
//获取所有的属性
+ (NSArray *)getAllproperty
{
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i< count; i++) {
        //获取属性
        objc_property_t property = propertyList[i];
        //获取属性名称
        const char *cName = property_getName(property);
        NSString *propertyname = [[NSString alloc]initWithUTF8String:cName];
        //添加到数组中
        [arr addObject:propertyname];
    }
    return arr.copy;
}

+ (instancetype)modelserializeWithDic:(NSDictionary *)dic
{
    id obj = [self new];
    // 遍历属性数组
    NSArray *propretyList = [self getAllproperty];
    for (NSString *property in propretyList) {
        // 判断字典中是否包含这个key 如果有就进行赋值操作
        if (dic[property]) {
            [obj setValue:dic[property] forKey:property];
        }
    }
    return obj;
}


//MARK: - 获取类Runtime相关属性

//方法列表
- (void)getMethodList {
    unsigned int count;
    Method *methodList = class_copyMethodList([self class], &count);
    
    for (unsigned int i=0; i<count; i++) {
        Method method =methodList[i];
        NSLog(@"Method%d: %@",i,NSStringFromSelector(method_getName(method)));
    }
    NSLog(@"\n_________________方法列表分割线________________________");
}
//属性列表
- (void)getpropertyList {
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (unsigned int i=0; i<count; i++) {
        const char *propertyname = property_getName(propertyList[i]);
        NSLog(@"property%d: %@", i,[NSString stringWithUTF8String:propertyname]);
    }
    NSLog(@"\n________________属性列表分割线________________________");
}

//实例变量列表
- (void)getivarLis {
    unsigned int count;
    Ivar *ivarList = class_copyIvarList([self class], &count);
    for (unsigned int i=0; i<count; i++) {
        Ivar myivar = ivarList[i];
        const char *ivarname = ivar_getName(myivar);
        NSLog(@"ivar%d:%@", i,[NSString stringWithUTF8String:ivarname]);
    }
    NSLog(@"\n________________实例变量列表分割线________________________");
}
//协议列表
- (void)getprotocolList {
    unsigned int count;
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList([self class], &count);
    for (unsigned int i=0; i<count; i++) {
        Protocol *myprotocal = protocolList[i];
        const char *protocolname = protocol_getName(myprotocal);
        NSLog(@"protocol%d: %@",i,[NSString stringWithUTF8String:protocolname]);
    }
    NSLog(@"\n________________协议列表分割线________________________");
}
- (void)getclassName {
    
    const char *className = class_getName([self class]);
    
    NSLog(@"className:%@",[NSString stringWithUTF8String:className]);
    NSLog(@"\n________________类名分割线________________________");
    
}
- (void)getSuperClass {
    Class superClass = class_getSuperclass([self class]);
    NSLog(@"superClass:%@",superClass);
    NSLog(@"\n________________父类分割线________________________");
    
}

@end
