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
//    [self testdes];
//    [self testredes];
//    [self test3des];
//    [self testre3des];
//    [self testRSA];
    [self testReRSA];
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
    NSString* b64 =@"LYmhOASDElxZI91Ff0LKqNdvB/gCrPuFjRD3/nQCy68PJA2HFWSBuxITUB2Fri14bvkQEpVKN1R9e9rJSZh/p759Nt+nOBY/ZTfQK+G8Io1WdO7GXUiPSPCkbZYB+SrAPrF6x6nystHDPF/xk0jq9jfS2OXasJfk0MzJqeWH7rM=";
    NSString* b64PrvKey=@"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBALcv2Tm/1ph2EgpsZlB6DdynFT1/F/cSq5kl0ZtpLj6++EtSYQXBqGkminhQ+W309iTBHwoToQzvbV1f1a1yKMEAZ1BWywe0OZWIq9V4Oe2Gr3GFwi36nBOMat7HUnQYkqRoWdYpsQM5+lNMrznYOXnc4D1bSXI210Z1XyXgLfNlAgMBAAECgYB+7m3DgTUOMYnwpQoEK36dbTzffsg5UDuNA9KIsEn1+leLwYou9fBe4/DAy8L5uOoxr4t1bQKENwb902D5LQgk/5iycN29XxV2hSD2HGuDNk8pBfT7dzhhSrd1srCEx++u8GWiGwAVXG3k3iakwlJWn9TFCf3ff3PBsRih73OQhQJBAN0sYkDmxOJ6b57xk/qlr25SH4gpyJoK+reR/231dLO1seFrTQVWcnwd7mrceW1Sm7GsUhn9c6WtObNRk6BcmucCQQDUCDXKQl7VIrwpziBVuBk3X6+k4pfUr9RHtHgsKsEkrEqq2Z49PeiQVmQxsOkrqTHqwmwCTha4sqpxTRIfOaHTAkEAvCXQo5Nss5kiMV0i3FtsJHY6GrQo0Vo7tEO/vgPLtkD/xFpqV/sVQx6XPlK1/VkD155W7YMdiTgWWMQxyH5eywJBANIpfR+IX7UEo9sQC67LNntTZaaaToIq8c9NCxxEGINAHxZvc1Aij+SZLOCwCL4VC3w0z5gNTKovtY9uI/s9Ra8CQQDMxk1QOaCbKm9+c6ArXjN2zSGJjrvFNZX6tzEeUwaR6knCQFs62f4b9EP8//UQzCbnq0d3em+VVkc0+x7jgkD8";
    NSString* b64PubKey =@"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC3L9k5v9aYdhIKbGZQeg3cpxU9fxf3EquZJdGbaS4+vvhLUmEFwahpJop4UPlt9PYkwR8KE6EM721dX9WtcijBAGdQVssHtDmViKvVeDnthq9xhcIt+pwTjGrex1J0GJKkaFnWKbEDOfpTTK852Dl53OA9W0lyNtdGdV8l4C3zZQIDAQAB";
    NSData* encdata =[HKEncUtil BASE64DecryptString:b64];
    NSData* privateKey = [HKEncUtil BASE64DecryptString:b64PrvKey];
    NSData* publicKey = [HKEncUtil BASE64DecryptString:b64PubKey];
    [HKEncUtil generateKeyPairWithPublicKey:publicKey privatekey:privateKey];
    NSData* data = [HKEncUtil RSADecryptWithData:encdata forPrivateKey:privateKey];
    NSLog(@"testRSA:%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

-(void)testReRSA{
    NSString* b64PrvKey=@"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBALcv2Tm/1ph2EgpsZlB6DdynFT1/F/cSq5kl0ZtpLj6++EtSYQXBqGkminhQ+W309iTBHwoToQzvbV1f1a1yKMEAZ1BWywe0OZWIq9V4Oe2Gr3GFwi36nBOMat7HUnQYkqRoWdYpsQM5+lNMrznYOXnc4D1bSXI210Z1XyXgLfNlAgMBAAECgYB+7m3DgTUOMYnwpQoEK36dbTzffsg5UDuNA9KIsEn1+leLwYou9fBe4/DAy8L5uOoxr4t1bQKENwb902D5LQgk/5iycN29XxV2hSD2HGuDNk8pBfT7dzhhSrd1srCEx++u8GWiGwAVXG3k3iakwlJWn9TFCf3ff3PBsRih73OQhQJBAN0sYkDmxOJ6b57xk/qlr25SH4gpyJoK+reR/231dLO1seFrTQVWcnwd7mrceW1Sm7GsUhn9c6WtObNRk6BcmucCQQDUCDXKQl7VIrwpziBVuBk3X6+k4pfUr9RHtHgsKsEkrEqq2Z49PeiQVmQxsOkrqTHqwmwCTha4sqpxTRIfOaHTAkEAvCXQo5Nss5kiMV0i3FtsJHY6GrQo0Vo7tEO/vgPLtkD/xFpqV/sVQx6XPlK1/VkD155W7YMdiTgWWMQxyH5eywJBANIpfR+IX7UEo9sQC67LNntTZaaaToIq8c9NCxxEGINAHxZvc1Aij+SZLOCwCL4VC3w0z5gNTKovtY9uI/s9Ra8CQQDMxk1QOaCbKm9+c6ArXjN2zSGJjrvFNZX6tzEeUwaR6knCQFs62f4b9EP8//UQzCbnq0d3em+VVkc0+x7jgkD8";
    NSString* b64PubKey =@"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC3L9k5v9aYdhIKbGZQeg3cpxU9fxf3EquZJdGbaS4+vvhLUmEFwahpJop4UPlt9PYkwR8KE6EM721dX9WtcijBAGdQVssHtDmViKvVeDnthq9xhcIt+pwTjGrex1J0GJKkaFnWKbEDOfpTTK852Dl53OA9W0lyNtdGdV8l4C3zZQIDAQAB";
    NSData* privateKey = [HKEncUtil BASE64DecryptString:b64PrvKey];
    NSData* publicKey = [HKEncUtil BASE64DecryptString:b64PubKey];
    [HKEncUtil generateKeyPairWithPublicKey:publicKey privatekey:privateKey];
    NSString* text = @"123456781234567812345678";
    NSData* textData = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSData* data = [HKEncUtil RSAEncryptWithData:textData forPublicKey:publicKey];
    NSString* b64 = [HKEncUtil BASE64EncryptData:data];
    NSLog(@"b64:%@",b64);
    data = [HKEncUtil BASE64DecryptString:b64];
    textData = [HKEncUtil RSADecryptWithData:data forPrivateKey:privateKey];
    text = [[NSString alloc] initWithData:textData encoding:NSUTF8StringEncoding];
    NSLog(@"text:%@",text);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
