//
//  do_Animation_MM.h
//  DoExt_MM
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol do_Animation_IMM <NSObject>
//实现同步或异步方法，parms中包含了所需用的属性
- (void)alpha:(NSArray *)parms;
- (void)rotate:(NSArray *)parms;
- (void)scale:(NSArray *)parms;
- (void)transfer:(NSArray *)parms;

@end