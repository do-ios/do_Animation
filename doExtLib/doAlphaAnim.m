//
//  doAlphaAnim.m
//  doBase
//
//  Created by 刘吟 on 15/1/17.
//  Copyright (c) 2015年 deviceone. All rights reserved.
//

#import "doAlphaAnim.h"
#import "doTextHelper.h"
#import "doJsonHelper.h"

@implementation doAlphaAnim
-(void) SetValuesFromJson:(NSDictionary*) data
{
    NSString* value = [doJsonHelper GetOneText:data :@"alphaFrom" : nil];
    if(value != nil){
        self.AlphaFrom = [[doTextHelper Instance] StrToFloat:value:0];
    }
    value = [doJsonHelper GetOneText:data :@"alphaTo" : nil];
    if(value != nil){
        self.AlphaTo = [[doTextHelper Instance] StrToFloat:value:0];
    }
    [super SetValuesFromJson:data];
}
-(CAAnimation*) CreateCAAnimation :anim
{
    anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    return anim;
}
-(void) SetCAAnimationPropValues:(UIView *)v animation:(CABasicAnimation *)caAnimation
{
    [super SetCAAnimationPropValues:v animation:caAnimation];
    caAnimation.fromValue = [NSNumber numberWithFloat:self.AlphaFrom];
    caAnimation.toValue = [NSNumber numberWithFloat:self.AlphaTo];
}
@end
