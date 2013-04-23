//
//  HKViewController.m
//  hkutil2
//
//  Created by akwei on 13-4-22.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import "HKViewController.h"
#import "HKView2Ctrl.h"
#import "HKView3Ctrl.h"
#import "HKShadowCtrl.h"
#import "HKSubViewCtrl.h"

@implementation HKViewController{
    HKShadowCtrl* _shadowCtrl;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _shadowCtrl = [[HKShadowCtrl alloc] initWithParentView:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toNext:(id)sender {
    HKView2Ctrl* ctrl = [[HKView2Ctrl alloc] initWithNibName:@"HKView2Ctrl" bundle:nil];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (IBAction)to3:(id)sender {
    HKView3Ctrl* ctrl = [[HKView3Ctrl alloc] initWithNibName:@"HKView3Ctrl" bundle:nil];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (IBAction)toSubView:(id)sender {
    HKSubViewCtrl* ctrl = [[HKSubViewCtrl alloc] initWithNibName:@"HKSubViewCtrl" bundle:nil];
    [_shadowCtrl hkPushViewController:ctrl animated:YES];
}
@end
