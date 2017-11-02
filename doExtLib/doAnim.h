//
//  doAnim.h
//  doBase
//
//  Created by 刘吟 on 15/1/17.
//  Copyright (c) 2015年 deviceone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface doAnim : NSObject

@property (nonatomic,strong) NSString* AnimID;
@property (nonatomic,assign) float Delay;
@property (nonatomic,assign) float Duration;
@property (nonatomic,strong) NSString* Curve;
@property (nonatomic,assign) int RepeatCount;
@property (nonatomic,assign) BOOL AutoReverse;
@property (nonatomic,assign) BOOL FillAfter;
@property (assign,nonatomic) double XZoom;
@property (assign,nonatomic) double YZoom;
//abstract
-(void) SetValuesFromJson:(NSDictionary*) data;
-(CABasicAnimation*) CreateCAAnimation:(CABasicAnimation*)anim;
-(void)SetCAAnimationPropValues:(UIView *)v  animation:(CABasicAnimation *)caAnimation;
//public
-(void) SetPropValue:(NSString*) _key : (NSString*) _val;
@end
