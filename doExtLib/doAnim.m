//
//  doself.m
//  doBase
//
//  Created by 刘吟 on 15/1/17.
//  Copyright (c) 2015年 deviceone. All rights reserved.
//

#import "doAnim.h"
#import "doTextHelper.h"
#import "doJsonHelper.h"

@implementation doAnim
{
    NSMutableArray *_unsetPropertys;
}
@synthesize AnimID,Delay,Duration,Curve,RepeatCount,AutoReverse,FillAfter;
@synthesize XZoom,YZoom;
//
-(void) SetValuesFromJson:(NSDictionary*) data
{
    _unsetPropertys = [NSMutableArray array];
    NSArray* keys = [[NSArray alloc]initWithObjects:@"delay",@"duration",@"curve",@"repeatCount",@"autoReverse",@"fillAfter", nil];
    NSArray *allKeys = [data allKeys];
    for(NSString* key in keys)
    {
        if ([allKeys containsObject:key]) {
            [self SetPropValue:key:[doJsonHelper GetOneText:data :key: nil]];
        }else
            [_unsetPropertys addObject:key];
    }
}
-(void) SetPropValue:(NSString*) _key : (NSString*) value
{
    if(_key == nil||value==nil)return;
    if([_key isEqualToString:@"delay"]){
        self.Delay = [[doTextHelper Instance] StrToFloat:value:0]/1000.0f;
        return;
    }
    if([_key isEqualToString:@"duration"]){
        self.Duration =[[doTextHelper Instance] StrToFloat:value:0]/1000.0f;
        return;
    }
    if([_key isEqualToString:@"curve"]){
        self.Curve=value;
        return;
    }
    if([_key isEqualToString:@"repeatCount"]){
        self.RepeatCount =[[doTextHelper Instance] StrToFloat:value:1];
        if (self.RepeatCount<0) {
            self.RepeatCount = MAXFLOAT;
        };
        return;
    }
    if([_key isEqualToString:@"autoReverse"]){
        self.AutoReverse  =[[doTextHelper Instance] StrToBool:value:NO];
        return;
    }
    if([_key isEqualToString:@"fillAfter"]){
        self.FillAfter  =[[doTextHelper Instance] StrToBool:value:NO];
        return;
    }
}
-(CABasicAnimation*) CreateCAAnimation:(CABasicAnimation*)anim
{
    return anim;
}
-(void) SetCAAnimationPropValues:(UIView *)v animation:(CABasicAnimation *)caAnimation;
{
    caAnimation.duration = self.Duration;
    if([self.Curve isEqualToString:@"EaseIn"])
        caAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    else if([self.Curve isEqualToString:@"EaseOut"])
        caAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    else if([self.Curve isEqualToString:@"EaseInOut"])
        caAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    else
        caAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    if ([_unsetPropertys containsObject:@"repeatCount"]) {
        self.RepeatCount = 1;
        caAnimation.repeatCount = 1;
    }else{
        if(self.RepeatCount==-1)
            caAnimation.repeatCount = CGFLOAT_MAX;
        else
            caAnimation.repeatCount = self.RepeatCount;
    }
    if (!self.Duration) {
        self.Duration = 0;
    }
    if (self.AutoReverse) {
        caAnimation.autoreverses = self.AutoReverse;
    }
    if(self.FillAfter)
    {
        caAnimation.removedOnCompletion = NO;
        caAnimation.fillMode = kCAFillModeForwards;
    }
}
@end
