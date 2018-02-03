//
//  Tools.h
//  Swift_Runtime
//
//  Created by sim on 2018/2/3.
//  Copyright © 2018年 wanglupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Tools : NSObject

@end

@interface UIButton (buttonCategroy)

//UILabel自动换行并调节字体尺寸以适应frame.size
- (void)addOChandle:(dispatch_block_t)handle;

@end
