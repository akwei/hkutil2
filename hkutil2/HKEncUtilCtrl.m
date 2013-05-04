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
    HKRSAUtil* rsaUtil = [[HKRSAUtil alloc] init];
    rsaUtil.publicKeyData = [@"com.apple.sample.publickey222" dataUsingEncoding:NSUTF8StringEncoding];
    rsaUtil.privateKeyData = [@"com.apple.sample.privatekey111" dataUsingEncoding:NSUTF8StringEncoding];
    [rsaUtil buildKeyInfo];
    NSString* text = @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBALcv2Tm/1ph2EgpsZlB6DdynFT1/F/cSq5kl0ZtpLj6++EtSYQXBqGkminhQ+W309iTBHwoToQzvbV1f1a1yKMEAZ1BWywe0OZWIq9V4Oe2Gr3GFwi36nBOMat7HUnQYkqRoWdYpsQM5+lNMrznYOXnc4D1bSXI210Z1XyXgLfNlAgMBAAECgYB+7m3DgTUOMYnwpQoEK36dbTzffsg5UDuNA9KIsEn1+leLwYou9fBe4/DAy8L5uOoxr4t1bQKENwb902D5LQgk/5iycN29XxV2hSD2HGuDNk8pBfT7dzhhSrd1srCEx++u8GWiGwAVXG3k3iakwlJWn9TFCf3ff3PBsRih73OQhQJBAN0sYkDmxOJ6b57xk/qlr25SH4gpyJoK+reR/231dLO1seFrTQVWcnwd7mrceW1Sm7GsUhn9c6WtObNRk6BcmucCQQDUCDXKQl7VIrwpziBVuBk3X6+k4pfUr9RHtHgsKsEkrEqq2Z49PeiQVmQxsOkrqTHqwmwCTha4sqpxTRIfOaHTAkEAvCXQo5Nss5kiMV0i3FtsJHY6GrQo0Vo7tEO/vgPLtkD/xFpqV/sVQx6XPlK1/VkD155W7YMdiTgWWMQxyH5eywJBANIpfR+IX7UEo9sQC67LNntTZaaaToIq8c9NCxxEGINAHxZvc1Aij+SZLOCwCL4VC3w0z5gNTKovtY9uI/s9Ra8CQQDMxk1QOaCbKm9+c6ArXjN2zSGJjrvFNZX6tzEeUwaR6knCQFs62f4b9EP8//UQzCbnq0d3em+VVkc0+x7jgkD8";
    NSData* textData = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSData* encData = [rsaUtil encryptData:textData usePublicKey:YES];
    NSData* deData = [rsaUtil decryptData:encData usePublicKey:NO];
    NSString* deText = [[NSString alloc] initWithData:deData encoding:NSUTF8StringEncoding];
    if ([text isEqualToString:deText]) {
        NSLog(@"encrypt and decrypt success");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
