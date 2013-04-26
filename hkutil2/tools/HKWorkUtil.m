//
//  HKWorkUtil.m
//  hkutil2
//
//  Created by akwei on 13-4-25.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import "HKWorkUtil.h"

#define kCompleteBlock @"completeBlock"
#define kDelayBlock @"delayBlock"
#define kAnimation @"animation"
#define kLayer @"layer"

@implementation HKWorkUtil

-(void)runOnLayer:(CALayer *)layer animation:(CAAnimation *)animation onComplete:(void (^)(void))completeBlock{
    animation.delegate = self;
    [animation setValue:completeBlock forKey:kCompleteBlock];
    [animation setValue:layer forKey:kLayer];
    [layer addAnimation:animation forKey:kAnimation];
}

-(void)runOnLayer:(CALayer *)layer animation:(CAAnimation *)animation delay:(NSTimeInterval)delay onComplete:(void (^)(void))completeBlock{
    [self runBlock:^{
        [self runOnLayer:layer animation:animation onComplete:completeBlock];
    } delay:delay];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
//    CALayer* layer = [anim valueForKey:kLayer];
//    [layer removeAnimationForKey:kAnimation];
    void (^completeBlock)(void) = [anim valueForKey:kCompleteBlock];
    if (completeBlock) {
        completeBlock();
    }
}

-(void)runBlock:(void (^)(void))block delay:(NSTimeInterval)delay{
    NSMutableDictionary* info = [[NSMutableDictionary alloc] init];
    [info setValue:block forKey:kDelayBlock];
    [self performSelector:@selector(delayInvoke:) withObject:info afterDelay:delay];
}

-(void)delayInvoke:(NSDictionary*)info{
    void (^delayBlock)(void) = [info valueForKey:kDelayBlock];
    if (delayBlock) {
        delayBlock();
    }
}

@end
