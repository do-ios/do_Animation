//
//  do_Animation_MM.m
//  DoExt_MM
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "do_Animation_MM.h"

#import "doScriptEngineHelper.h"
#import "doIScriptEngine.h"
#import "doInvokeResult.h"
#import "doProperty.h"
#import "doTextHelper.h"
#import "doAlphaAnim.h"
#import "doRotateAnim.h"
#import "doScaleAnim.h"
#import "doTransferAnim.h"
#import "doUIModule.h"
#import "doIPage.h"
#import "doJsonHelper.h"

#define ANIMATION_KEY_PRE  @"doAnimation_"

@implementation do_Animation_MM
{
    doAnim* doAnimSet;
    NSMutableArray* doAnims;
    NSMutableDictionary* doAnimMap;
    doUIModule* animationUI;
}
-(id)init
{
    self = [super init];
    doAnimSet = [[doAnim alloc]init];
    doAnims = [[NSMutableArray alloc]init];
    doAnimMap = [[NSMutableDictionary alloc]init];
    return self;
}

#pragma mark - 注册属性（--属性定义--）
/*
 [self RegistProperty:[[doProperty alloc]init:@"属性名" :属性类型 :@"默认值" : BOOL:是否支持代码修改属性]];
 */

-(void)OnInit
{
    [super OnInit];
}
-(void) Dispose
{
    doAnimSet = nil;
    [doAnims removeAllObjects];
    doAnims = nil;
    [doAnimMap removeAllObjects];
    doAnimMap = nil;
    animationUI = nil;
    [super Dispose];
}
//设置属性值
- (BOOL) SetPropertyValue:(NSString*) _key : (NSString*) _val
{
    BOOL isReturn = [super SetPropertyValue:_key :_val ];
    [doAnimSet SetPropValue:_key :_val];
    for (doAnim* anim in doAnims) {
        anim.FillAfter = doAnimSet.FillAfter;
    }
    return isReturn;
}
- (void) LoadModel: (NSDictionary*) _rootJsonNode
{
    [doAnimSet SetValuesFromJson:_rootJsonNode];
    NSArray* animationTypes =[ [NSArray alloc]initWithObjects:@"alpha",@"transfer",@"scale",@"rotate", nil];
    for(NSString* type in animationTypes){
        NSArray* alphaNodes =[doJsonHelper GetOneArray: _rootJsonNode :type];
        if(alphaNodes != nil)
        {
            for(id alphaValue in alphaNodes)
            {
                NSDictionary* alphaNode =[doJsonHelper GetNode:alphaValue ];
                if(alphaNode != nil){
                    [self setAnimation:type :alphaNode :[doJsonHelper  GetOneText:alphaNode :@"id": nil]];
                }
            }
        }
    }
}
- (void)LoadModelFromString:(NSString *)_moduleString
{
    id _rootJsonValue =[doJsonHelper LoadDataFromText : _moduleString];
    NSDictionary* _rootJsonNode = [doJsonHelper GetNode:_rootJsonValue];
    [doAnimSet SetValuesFromJson:_rootJsonNode];
    NSArray* animationTypes =[ [NSArray alloc]initWithObjects:@"alpha",@"transfer",@"scale",@"rotate", nil];
    for(NSString* type in animationTypes){
        NSArray* alphaNodes =[doJsonHelper GetOneArray: _rootJsonNode :type];
        if(alphaNodes != nil)
        {
            for(id alphaValue in alphaNodes)
            {
                NSDictionary* alphaNode =[doJsonHelper GetNode:alphaValue ];
                if(alphaNode != nil){
                    [self setAnimation:type :[doJsonHelper GetOneNode:alphaNode :@"data"] :[doJsonHelper  GetOneText:alphaNode :@"id": nil]];
                }
            }
        }
    }
    
}

#pragma mark -
#pragma mark - method
-(void) rotate:(NSArray *)parms
{
    [self setAnimationFromMethod:@"rotate" :parms];
}
-(void) scale:(NSArray *)parms
{
    [self setAnimationFromMethod:@"scale" :parms];
}
-(void) transfer:(NSArray *)parms
{
    [self setAnimationFromMethod:@"transfer" :parms];
}
-(void) alpha:(NSArray *)parms
{
    [self setAnimationFromMethod:@"alpha" :parms];
}
#pragma mark -
#pragma mark - doIAnimation
-(void) SetAnimation:(doUIModule *) _comp :(NSString*) _callbackName
{
    if(_comp==nil||_comp.CurrentUIModuleView==nil) return;
    animationUI = _comp;
    __weak UIView *_view =  (UIView*)_comp.CurrentUIModuleView;
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSArray *a = [_view.layer animationKeys];
        for (NSString *k in a) {
            if ([k hasPrefix:ANIMATION_KEY_PRE]) {
                [_view.layer removeAnimationForKey:k];
            }
        }
    });
    
    double delay = CACurrentMediaTime();
    int i = 0;
    for(doAnim* anim in doAnims)
    {
        i++;
        CABasicAnimation* caAnim = [CABasicAnimation animation];
        caAnim = [anim CreateCAAnimation:caAnim];
        if (!caAnim) {
            return;
        }
        anim.XZoom = animationUI.XZoom;
        anim.YZoom = animationUI.YZoom;
        [anim SetCAAnimationPropValues:_view animation:caAnim];
        
        if (anim.RepeatCount == 0) {
            continue;
        }
        if (anim.Duration <= 0) {
            continue;
        }
        
        delay = anim.Delay;
        caAnim.beginTime = CACurrentMediaTime()+ delay;
        
        caAnim.delegate = self;
        [caAnim setValue:_callbackName forKey:@"callBackName"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_view.layer addAnimation:caAnim forKey:[NSString stringWithFormat:@"%@%i",ANIMATION_KEY_PRE,i]];
            NSLog(@"add animation.....................");
        });
    }
}

//CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim
{
    NSLog(@"did start animation ...................");
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"did stop animation ...................");
    NSString *callName = [anim valueForKey:@"callBackName"];
    [animationUI.CurrentPage.ScriptEngine Callback:callName :nil];
}
#pragma mark -
#pragma mark - private
-(void) setAnimationFromMethod:(NSString*) _type :(NSArray *)parms
{
    NSDictionary* _dictParas = [parms objectAtIndex:0];
    NSDictionary* data =[doJsonHelper GetOneNode: _dictParas :@"data"];
    NSString* animid = [doJsonHelper GetOneText:_dictParas :@"id" : nil];
    [self setAnimation:_type :data :animid];
}
-(void) setAnimation:(NSString*) _type :(NSDictionary*) data : (NSString*) animid
{
    if(data != nil){
        doAnim* anim = nil;
        if(animid != nil){
            anim =doAnimMap[animid];
        }
        if(anim == nil){
            anim = [self animFactory:_type];
            [doAnims addObject:anim];
            if(animid!=nil)
            {
                [doAnimMap setObject:anim forKey:animid];
            }
        }
        anim.AnimID = animid;
        [anim SetValuesFromJson:data];
    }
    for (doAnim* anim in doAnims) {
        anim.FillAfter = doAnimSet.FillAfter;
    }
}
-(doAnim*) animFactory:(NSString*) _type
{
    if([_type isEqualToString:@"alpha"])
        return [[doAlphaAnim alloc]init];
    if([_type isEqualToString:@"scale"])
        return [[doScaleAnim alloc]init];
    if([_type isEqualToString:@"rotate"])
        return [[doRotateAnim alloc]init];
    if([_type isEqualToString:@"transfer"])
        return [[doTransferAnim alloc]init];
    return nil;
}

@end