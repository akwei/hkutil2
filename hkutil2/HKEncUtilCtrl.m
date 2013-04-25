//
//  HKEncUtilCtrl.m
//  hkutil2
//
//  Created by akwei on 13-4-25.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import "HKEncUtilCtrl.h"
#import "HKEncUtil.h"

@implementation HKEncUtilCtrl
@synthesize shadowCtrl;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString* key =@"12345678";
    NSString* text = @"你好，我爱你，中国，abcd!-=39458*&^";
    NSString* des_text = [HKEncUtil encodeDESToHexWithKey:key value:text];
    NSString* d_des_text = [HKEncUtil decodeDESHexWithKey:key hex:des_text];
    if ([text isEqualToString:d_des_text]) {
        NSLog(@"des encode decode");
    }
    des_text = [HKEncUtil encodeDESWithBase64WithKey:key value:text];
    d_des_text = [HKEncUtil decodeDESWithBase64WithKey:key value:des_text];
    if ([text isEqualToString:d_des_text]) {
        NSLog(@"des base64 encode decode");
    }
    
    
    NSString* tdes_text = [HKEncUtil encode3DESToHexWithKey:key value:text];
    NSString* d_tdes_text = [HKEncUtil decode3DESHexWithKey:key hex:tdes_text];
    if ([text isEqualToString:d_tdes_text]) {
        NSLog(@"tdes encode decode");
    }
    tdes_text = [HKEncUtil encode3DESWithBase64WithKey:key value:text];
    d_tdes_text = [HKEncUtil decode3DESWithBase64WithKey:key value:tdes_text];
    if ([text isEqualToString:d_tdes_text]) {
        NSLog(@"tdes base64 encode decode");
    }
    
    NSString* b64_text = [HKEncUtil encodeBase64:text];
    NSString* d_b64_text = [[NSString alloc] initWithData:[HKEncUtil decodeBase64:b64_text] encoding:NSUTF8StringEncoding];
    if ([text isEqualToString:d_b64_text]) {
        NSLog(@"base64 encode decode");
    }
    
    NSString* md5_text = [HKEncUtil md5:text];
    if ([md5_text length] == 32) {
        NSLog(@"md5 ok");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
