//
//  HKTimerInvoker.h
//  hkutil2
//
//  Created by akwei on 13-4-23.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKTimerInvoker : NSObject

@property(nonatomic,strong) BOOL (^jobBlock)(void);
@property(nonatomic,strong) void (^callbackBlock)(void);
@property(nonatomic,assign)BOOL running;

/*
 任务间隔时间，不能小于1
 */
@property(nonatomic,assign)NSTimeInterval time;

/*
 任务调用，会启用新的线程进行调用，异步执行，不会在主线程中使用
 */
-(void)start;

-(void)startWithDelay:(NSTimeInterval)t;

-(void)stop:(BOOL)waitDone;
@end
