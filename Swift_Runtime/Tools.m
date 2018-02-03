//
//  Tools.m
//  Swift_Runtime
//
//  Created by sim on 2018/2/3.
//  Copyright © 2018年 wanglupeng. All rights reserved.
//

#import "Tools.h"
#import <objc/runtime.h>

@implementation Tools

@end

@implementation UIButton (buttonCategroy)

- (void)addOChandle:(dispatch_block_t)handle
{
    
    objc_setAssociatedObject(self, &"BLOCKKEY", handle, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(clicked:)forControlEvents:UIControlEventTouchUpInside];
}
-(void)clicked:(UIButton *)sender
{
    dispatch_block_t block=objc_getAssociatedObject(self, &"BLOCKKEY");
    if(block)
    {
        block();
    }
}


@end


