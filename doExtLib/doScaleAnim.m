//
//  doScaleAnim.m
//  doBase
//
//  Created by 刘吟 on 15/1/17.
//  Copyright (c) 2015年 deviceone. All rights reserved.
//

#import "doScaleAnim.h"
#import "doTextHelper.h"
#import "doJsonHelper.h"

@implementation doScaleAnim
{
    CGFloat pivotX ;
    CGFloat pivotY ;
}
-(void) SetValuesFromJson:(NSDictionary*) data
{
    NSString* value = [doJsonHelper GetOneText:data :@"scaleFromX" : nil];
    if(value != nil){
        self.ScaleFromX = [[doTextHelper Instance] StrToFloat:value:1];
    }
    value = [doJsonHelper GetOneText:data :@"scaleFromY" : nil];
    if(value != nil){
        self.ScaleFromY = [[doTextHelper Instance] StrToFloat:value:1];
    }
    value = [doJsonHelper GetOneText:data :@"scaleToX" : nil];
    if(value != nil){
        self.ScaleToX = [[doTextHelper Instance] StrToFloat:value:1];
    }
    value = [doJsonHelper GetOneText:data :@"scaleToY" : nil];
    if(value != nil){
        self.ScaleToY = [[doTextHelper Instance] StrToFloat:value:1];
    }
    value = [doJsonHelper GetOneText:data :@"pivotX" : nil];
    if(value != nil){
        pivotX = [[doTextHelper Instance] StrToFloat:value:0];
    }
    value = [doJsonHelper GetOneText:data :@"pivotY" : nil];
    if(value != nil){
        pivotY = [[doTextHelper Instance] StrToFloat:value:0];
    }
    [super SetValuesFromJson:data];
}
-(CAAnimation*) CreateCAAnimation:anim
{
    anim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    return anim;
}
-(void) SetCAAnimationPropValues:(UIView *)v animation:(CABasicAnimation *)caAnimation
{
    [super SetCAAnimationPropValues:v animation:caAnimation];
    CGRect frame = v.frame;
    v.layer.anchorPoint = CGPointMake(pivotX, pivotY);
    v.frame = frame;
    caAnimation.fromValue = [NSNumber numberWithFloat:fmax(self.ScaleFromX,self.ScaleFromY)];
    caAnimation.toValue = [NSNumber numberWithFloat:fmax(self.ScaleToX,self.ScaleToY)];
}
@end
