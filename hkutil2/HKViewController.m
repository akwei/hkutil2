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
#import "HKEncUtilCtrl.h"
#import "HKHttpClientCtrl.h"
#import "HKUtilCtrl.h"
#import "HKTimerCtrl.h"
#import "HKHTTPServerCtrl.h"
#import "HKSQLQueryCtrl.h"
#import "HKExceptionCtrl.h"
#import "HKWorkCallCtrl.h"

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

- (IBAction)testEncUtil:(id)sender {
    HKEncUtilCtrl* ctrl = [[HKEncUtilCtrl alloc] initWithNibName:@"HKEncUtilCtrl" bundle:nil];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (IBAction)testHttpClient:(id)sender {
    HKHttpClientCtrl* ctrl = [[HKHttpClientCtrl alloc] initWithNibName:@"HKHttpClientCtrl" bundle:nil];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (IBAction)testUtil:(id)sender {
    HKUtilCtrl* ctrl = [[HKUtilCtrl alloc] initWithNibName:@"HKUtilCtrl" bundle:nil];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (IBAction)testTimer:(id)sender {
    HKTimerCtrl* ctrl = [[HKTimerCtrl alloc] initWithNibName:@"HKTimerCtrl" bundle:nil];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (IBAction)testHTTPServer:(id)sender {
    HKHTTPServerCtrl* ctrl = [[HKHTTPServerCtrl alloc] initWithNibName:@"HKHTTPServerCtrl" bundle:nil];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (IBAction)testSQLQuery:(id)sender {
    HKSQLQueryCtrl* ctrl = [[HKSQLQueryCtrl alloc] initWithNibName:@"HKSQLQueryCtrl" bundle:nil];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (IBAction)textException:(id)sender {
    HKExceptionCtrl* ctrl = [[HKExceptionCtrl alloc] initWithNibName:@"HKExceptionCtrl" bundle:nil];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (IBAction)testWorkCall:(id)sender {
    HKWorkCallCtrl* ctrl = [[HKWorkCallCtrl alloc] initWithNibName:@"HKWorkCallCtrl" bundle:nil];
    [self.navigationController pushViewController:ctrl animated:YES];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
