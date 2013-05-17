//
//  HKEncUtilCtrl.m
//  hkutil2
//
//  Created by akwei on 13-4-25.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import "HKEncUtilCtrl.h"
#import "HKEncUtil.h"
#import "HKRSAUtil.h"

@implementation HKEncUtilCtrl{
    
}
@synthesize shadowCtrl;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self testdes];
//    [self testredes];
//    [self test3des];
//    [self testre3des];
    [self testRSA];
}

-(void)testdes{
    NSString* key =@"12345678";
    NSString* text = @"你好，我爱你，中国，abcd!-=39458*&^";
    NSData* textData = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSData* data = [HKEncUtil DESEncryptWithData:textData forKey:key];
    NSString* b64text = [HKEncUtil BASE64EncryptData:data];
    NSLog(@"test des:%@",b64text);
}

-(void)testredes{
    NSString* key =@"12345678";
    NSString* text = @"bVI453QkPGRyawbo19rrXda2H0yDpotLef9Fu6SyQfFrf2Bh4FfWDG8/FrD/8ArT";
    NSData* data = [HKEncUtil BASE64DecryptString:text];
    NSData* textData = [HKEncUtil DESDecryptWithData:data forKey:key];
    NSLog(@"test redes:%@",[[NSString alloc] initWithData:textData encoding:NSUTF8StringEncoding]);
}

-(void)test3des{
    NSString* key =@"123456781234567812345678";
    NSString* text = @"你好，我爱你，中国，abcd!-=39458*&^";
    NSData* textData = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSData* des_data = [HKEncUtil DESEDEEncryptWithData:textData forKey:key];
    NSString* b64text = [HKEncUtil BASE64EncryptData:des_data];
    NSLog(@"test 3des:%@",b64text);
}

-(void)testre3des{
    NSString* key =@"9xjf6dlx7vjw30cmd7qosjc6";
    NSString* text = @"eT3j8tjrDn04W3mkX6tLpleQOWt53IioKhmhzK6y1z+Q+wNBb05pdGo+lygUuT1d";
    NSData* data = [HKEncUtil BASE64DecryptString:text];
    NSData* textData = [HKEncUtil DESEDEDecryptWithData:data forKey:key];
    NSLog(@"test re3des:%@",[[NSString alloc] initWithData:textData encoding:NSUTF8StringEncoding]);
}

-(void)testRSA{
    HKRSAUtil* rsaUtil = [[HKRSAUtil alloc] initWithPublickKeyData:[HKEncUtil BASE64DecryptString:@"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCDMo51EbnF+lZ82gdW6Uycj2H9OmoaropTeMvszTiiIgiDhM+DuRP70KOzlaoSg+01qRwgXXq0iXSPLvBp0HKAsBhe1TD3kRpwvU8NetGx7h+xG/BOn8X3vJdjfonzs+6Cr+3ver7ZFO1tSjOElZYcahDHKhugpWvLSsQ/EipyCQIDAQAB"]
                                                  isX509PublickKey:YES
                                                    privateKeyData:nil
                                                      publicKeyTag:@"publickKeyRef"
                                                     privateKeyTag:@"privateKeyRef"];
    
    
    
    NSString* text = @"我来了，哈哈哈，你好，来一个，奥特曼，动感超人hello1234567890";
    NSData* textData = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSData* encData = [rsaUtil encryptData:textData];
    NSString* b64 = [HKEncUtil BASE64EncryptData:encData];
    NSLog(@"b64=%@",b64);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
