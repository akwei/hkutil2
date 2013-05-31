//
//  HKHttpClientCtrl.m
//  hkutil2
//
//  Created by akwei on 13-4-25.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import "HKHttpClientCtrl.h"
#import "HKHttpClient.h"
#import "HKThreadUtil.h"
#import "HKAFHTTPClient.h"

@implementation HKHttpClientCtrl{
    HKThreadUtil* _threadUtil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _threadUtil = [HKThreadUtil shareInstance];
    [_threadUtil asyncBlock:^{
        HKAFHTTPClient* client = [[HKAFHTTPClient alloc] init];
        client.timeout = 10;
        client.baseUrl = @"http://www.baidu.com";
        client.subUrl = @"";
        [client doGet];
        if (client.error) {
            NSLog(@"request error\n%@",[client.error description]);
        }
        else{
            [_threadUtil syncBlockToMainThread:^{
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"ok" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }];
        }
    }];
    NSLog(@"\n");
    NSLog(@"viewDidLoad");
    NSLog(@"\n");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
