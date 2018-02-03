//
//  Cat.h
//  Swift_Runtime
//
//  Created by sim on 2018/2/2.
//  Copyright © 2018年 wanglupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cat : NSObject
@property (nonatomic,copy) NSString *name;//名称
@property (nonatomic,copy) NSString *sex; //性别

- (void)eat;
- (void)run;
- (void)getMethodList;
- (void)getpropertyList;
- (void)getivarLis;
- (void)getprotocolList;
- (void)getSuperClass;
- (void)getclassName;
- (void)perfonromSelectorMethod;
+ (void)swizzlingMehod;
+ (instancetype)modelWithDict:(NSDictionary *)dict;
@end
