//
//  HKSubViewCtrl.m
//  hkutil2
//
//  Created by akwei on 13-4-23.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import "HKSubViewCtrl.h"

@interface HKSubViewCtrl ()

@end

@implementation HKSubViewCtrl
@synthesize shadowCtrl;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toBack:(id)sender {
    [self.shadowCtrl hkPopViewControllerAnimated:YES];
}
@end
