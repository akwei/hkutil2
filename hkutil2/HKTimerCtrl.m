//
//  HKTimerCtrl.m
//  hkutil2
//
//  Created by akwei on 13-4-26.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import "HKTimerCtrl.h"
#import "HKTimerInvoker.h"

@interface HKTimerCtrl ()

@end

@implementation HKTimerCtrl{
    HKTimerInvoker* _timerInvoker;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _timerInvoker = [[HKTimerInvoker alloc] init];
    [_timerInvoker setJobBlock:^BOOL{
        NSLog(@"log job invoke");
        return NO;
    }];
    [_timerInvoker setCallbackBlock:^{
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"任务调用完成" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }];
    _timerInvoker.time = 2;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_timerInvoker stop:YES];
}

- (IBAction)startJob:(id)sender {
    [_timerInvoker start];
}

- (IBAction)stopJob:(id)sender {
    [_timerInvoker stop:YES];
}

@end
