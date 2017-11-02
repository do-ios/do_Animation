//
//  doTransferAnim.m
//  doBase
//
//  Created by 刘吟 on 15/1/17.
//  Copyright (c) 2015年 deviceone. All rights reserved.
//

#import "doTransferAnim.h"
#import "doTextHelper.h"
#import "doJsonHelper.h"

@implementation doTransferAnim
-(void) SetValuesFromJson:(NSDictionary*) data
{
    NSString* value =  [doJsonHelper GetOneText:data :@"fromX" : nil];
    if(value != nil){
        self.FromX = [[doTextHelper Instance] StrToFloat:value:1];
    }
    value = [doJsonHelper GetOneText:data :@"fromY" : nil];
    if(value != nil){
        self.FromY = [[doTextHelper Instance] StrToFloat:value:1];
    }
    value = [doJsonHelper GetOneText:data :@"toX" : nil];
    if(value != nil){
        self.ToX = [[doTextHelper Instance] StrToFloat:value:1];
    }
    value = [doJsonHelper GetOneText:data :@"toY" : nil];
    if(value != nil){
        self.ToY = [[doTextHelper Instance] StrToFloat:value:1];
    }
    [super SetValuesFromJson:data];
}
-(CAAnimation*) CreateCAAnimation :anim
{
    anim = [CABasicAnimation animationWithKeyPath:@"position"];
    return anim;
}
-(void) SetCAAnimationPropValues:(UIView *)v animation:(CABasicAnimation *)caAnimation
{
    [super SetCAAnimationPropValues:v animation:caAnimation];
    CGPoint startPoint = CGPointMake(v.layer.position.x+self.FromX*self.XZoom, v.layer.position.y+self.FromY*self.YZoom);
    CGPoint endPoint = CGPointMake(v.layer.position.x+self.ToX*self.XZoom, v.layer.position.y+self.ToY*self.YZoom);
    
    caAnimation.fromValue = [NSValue valueWithCGPoint:startPoint];
    caAnimation.toValue = [NSValue valueWithCGPoint:endPoint];
}
@end
