//
//  doRotateAnim.m
//  doBase
//
//  Created by 刘吟 on 15/1/17.
//  Copyright (c) 2015年 deviceone. All rights reserved.
//

#import "doRotateAnim.h"
#import "doTextHelper.h"
#import "doJsonHelper.h"

#define PI_VALUE 180

@implementation doRotateAnim
{
    CGFloat pivotX ;
    CGFloat pivotY ;
}
-(void) SetValuesFromJson:(NSDictionary*) data
{
    NSString* value = [doJsonHelper GetOneText:data :@"fromDegree" : nil];
    if(value != nil){
        self.FromDegree = [[doTextHelper Instance] StrToFloat:value:0]/PI_VALUE;
    }
    value = [doJsonHelper GetOneText:data :@"toDegree" : nil];
    if(value != nil){
        self.ToDegree = [[doTextHelper Instance] StrToFloat:value:0]/PI_VALUE;
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
-(CAAnimation*) CreateCAAnimation:(CAAnimation *)anim
{
    anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    return anim;
}
-(void) SetCAAnimationPropValues:(UIView *)v animation:(CABasicAnimation *)caAnimation
{
    [super SetCAAnimationPropValues:v animation:caAnimation];
    CGRect frame = v.frame;
    v.layer.anchorPoint = CGPointMake(pivotX, pivotY);
    v.frame = frame;
    caAnimation.fromValue = [NSNumber numberWithFloat:self.FromDegree*M_PI];
    caAnimation.toValue = [NSNumber numberWithFloat:self.ToDegree*M_PI];
}
@end
