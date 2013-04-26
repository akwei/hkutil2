//
//  HKWorkUtil.h
//  hkutil2
//
//  Created by akwei on 13-4-25.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface HKWorkUtil : NSObject

-(void)runOnLayer:(CALayer*)layer animation:(CAAnimation*)animation onComplete:(void (^)(void))completeBlock;

-(void)runOnLayer:(CALayer*)layer animation:(CAAnimation*)animation delay:(NSTimeInterval)delay onComplete:(void (^)(void))completeBlock;

-(void)runBlock:(void (^)(void))block delay:(NSTimeInterval)delay;

@end
