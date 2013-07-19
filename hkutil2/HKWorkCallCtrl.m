//
//  HKWorkCallCtrl.m
//  hkutil2
//
//  Created by akwei on 13-7-19.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import "HKWorkCallCtrl.h"
#import "HKWorkCaller.h"
#import "HKThreadUtil.h"

@implementation HKWorkCallCtrl

-(void)viewDidAppear:(BOOL)animated{
    __weak HKWorkCallCtrl* me = self;
    [HKWorkCaller workWithBlock:^BOOL(NSMutableDictionary *info) {
        [NSThread sleepForTimeInterval:1];
        [info setValue:@"11" forKey:@"key"];
        
        [[HKThreadUtil shareInstance] asyncBlockToMainThread:^{
            NSString* value = [info valueForKey:@"key"];
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 200, 100)];
            label.backgroundColor = [UIColor blackColor];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:20];
            label.text = value;
            [me.view addSubview:label];
        }];
        return NO;
    } onErrorMainBlock:^(NSMutableDictionary *info, NSException *exception) {
        NSString* value = [info valueForKey:@"key"];
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 200, 100)];
        label.backgroundColor = [UIColor blueColor];
        label.text = value;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:20];
        [me.view addSubview:label];
    }];
}

@end
