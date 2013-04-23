//
//  HKView3Ctrl.m
//  hkutil2
//
//  Created by akwei on 13-4-23.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import "HKView3Ctrl.h"
#import "HKURLImageView.h"


@implementation HKView3Ctrl

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.imgView.timeout = 10;
    [self.imgView loadFromUrl:@"http://aktest0.b0.upaiyun.com/img7.jpg_600x400" onErrorBlock:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setImgView:nil];
    [super viewDidUnload];
}

@end
