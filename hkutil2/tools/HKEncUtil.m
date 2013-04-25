//
//  EncUtil.m
//  encutil
//
//  Created by 伟 袁 on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HKEncUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "GTMStringEncoding.h"

@implementation HKEncUtil

+(NSString *)md5:(NSString *)value{
	int len=CC_MD5_DIGEST_LENGTH;
    const char* ch = [value UTF8String];
    unsigned char result[len];
    CC_MD5(ch, strlen(ch), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:len];
    for(int i = 0; i<len; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

+(NSString *)encodeBase64:(NSString *)value{
    GTMStringEncoding *coder = [GTMStringEncoding rfc4648Base64StringEncoding];
    return [coder encodeString:value];
    
}

+(NSData *)decodeBase64:(NSString *)value{
    GTMStringEncoding *coder = [GTMStringEncoding rfc4648Base64StringEncoding];
    return [coder decode:value];
}


+ (NSData *)desData:(NSData *)data key:(NSString *)keyString CCOperation:(CCOperation)op
{
    char buffer [1024] ;
    memset(buffer, 0, sizeof(buffer));
    size_t bufferNumBytes;
    CCCryptorStatus cryptStatus = CCCrypt(op,
                                          
                                          kCCAlgorithmDES,
                                          
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          
                                          [keyString UTF8String],
                                          
                                          kCCKeySizeDES,
                                          
                                          NULL,
                                          
                                          [data bytes],
                                          
                                          [data length],
                                          
                                          buffer,
                                          
                                          1024,
                                          
                                          &bufferNumBytes);
    if(cryptStatus == kCCSuccess){
        NSData *returnData =  [NSData dataWithBytes:buffer length:bufferNumBytes];
        return returnData;
    }
    NSLog(@"des failed！");
    return nil;
    
}

+(NSString *)encodeDESWithBase64WithKey:(NSString *)key value:(NSString *)value{
    NSData* strData= [value dataUsingEncoding:NSUTF8StringEncoding];
    NSData* data=[HKEncUtil desData:strData key:key CCOperation:kCCEncrypt];
    GTMStringEncoding *coder = [GTMStringEncoding rfc4648Base64StringEncoding];
    return [coder encode:data];
}

+(NSString *)decodeDESWithBase64WithKey:(NSString *)key value:(NSString *)value{
    GTMStringEncoding *coder = [GTMStringEncoding rfc4648Base64StringEncoding];
    NSData* data=[coder decode:value];
    NSData* decodeData=[HKEncUtil desData:data key:key CCOperation:kCCDecrypt];
    NSString* decodeStr= [[NSString alloc] initWithData:decodeData encoding:NSUTF8StringEncoding];
    return decodeStr;
}

+(NSString *)encodeDESToHex:(NSString *)key value:(NSString *)value{
    NSData* strData= [value dataUsingEncoding:NSUTF8StringEncoding];
    NSData* data=[HKEncUtil desData:strData key:key CCOperation:kCCEncrypt];
    return [self hexStringFromData:data];
}

+(NSString *)decodeDESHex:(NSString *)key hex:(NSString *)hex{
    NSData* data = [self dataFromHexString:hex];
    NSData* decodeData=[HKEncUtil desData:data key:key CCOperation:kCCDecrypt];
    NSString* decodeStr= [[NSString alloc] initWithData:decodeData encoding:NSUTF8StringEncoding];
    return decodeStr;
}

+ (NSData *)dataFromHexString:(NSString *)string{
    NSMutableData *stringData = [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [string length] / 2; i++) {
        byte_chars[0] = [string characterAtIndex:i*2];
        byte_chars[1] = [string characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [stringData appendBytes:&whole_byte length:1];
    }
    return stringData;
}

+ (NSString*)hexStringFromData:(NSData *)data{
    unichar* hexChars = (unichar*)malloc(sizeof(unichar) * (data.length*2));
    unsigned char* bytes = (unsigned char*)data.bytes;
    for (NSUInteger i = 0; i < data.length; i++) {
        unichar c = bytes[i] / 16;
        if (c < 10) c += '0';
        else c += 'a' - 10;
        hexChars[i*2] = c;
        c = bytes[i] % 16;
        if (c < 10) c += '0';
        else c += 'a' - 10;
        hexChars[i*2+1] = c;
    }
    NSString* retVal = [[NSString alloc] initWithCharactersNoCopy:hexChars
                                                           length:data.length*2
                                                     freeWhenDone:YES];
    return retVal;
}

+(NSString *)encode3DESWithBase64WithKey:(NSString *)key value:(NSString *)value{
    return [HKEncUtil encodeANdDecode3DESWithBase64WithKey:key value:value encryptOrDecrypt:kCCEncrypt];
}

+(NSString*)formatKey:(NSString*)key{
    NSData* keyData=[key dataUsingEncoding:NSUTF8StringEncoding];
    Byte* keyBytes=(Byte*)[keyData bytes];
    NSMutableData *nKeyMutableData=[[NSMutableData alloc] init];
    for (int i=0; i<24; i++) {
        Byte byte[]={0};
        [nKeyMutableData appendBytes:byte length:sizeof(byte)];
    }
    int keyLen=[keyData length];
    Byte* newKeyBytes=(Byte*)[nKeyMutableData bytes];
    for (int i=0; i<keyLen && i<[nKeyMutableData length]; i++) {
        newKeyBytes[i]=keyBytes[i];
    }
    int newKeyBytesLen=[nKeyMutableData length];
    NSData* newKeydata=[NSData dataWithBytes:newKeyBytes length:newKeyBytesLen];
    NSString* newKey=[[NSString alloc] initWithData:newKeydata encoding:NSUTF8StringEncoding];
    return newKey;
}

+(NSString *)decode3DESWithBase64WithKey:(NSString *)key value:(NSString *)value{
    return [HKEncUtil encodeANdDecode3DESWithBase64WithKey:key value:value encryptOrDecrypt:kCCDecrypt];
}

+(NSString *)encodeANdDecode3DESWithBase64WithKey:(NSString *)key value:(NSString *)value encryptOrDecrypt:(CCOperation)encryptOrDecrypt{
    const void *vplainText;
    size_t plainTextBufferSize;
    GTMStringEncoding *coder = [GTMStringEncoding rfc4648Base64StringEncoding];
    if (encryptOrDecrypt == kCCDecrypt)//解密
    {
        NSData *EncryptData = [coder decode:value];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else //加密
    {
        NSData* data = [value dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    NSString* nKey=[HKEncUtil formatKey:key];
    const void *vkey = (const void *) [nKey UTF8String];
    // NSString *initVec = @"init Vec";
    //const void *vinitVec = (const void *) [initVec UTF8String];
    //  Byte iv[] = {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding | kCCOptionECBMode,
                       vkey,
                       kCCKeySize3DES,
                       nil,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    if (ccStatus!=kCCSuccess) {
        free(bufferPtr);
        return nil;
    }
    //if (ccStatus == kCCSuccess) NSLog(@"SUCCESS");
    /*else if (ccStatus == kCC ParamError) return @"PARAM ERROR";
     else if (ccStatus == kCCBufferTooSmall) return @"BUFFER TOO SMALL";
     else if (ccStatus == kCCMemoryFailure) return @"MEMORY FAILURE";
     else if (ccStatus == kCCAlignmentError) return @"ALIGNMENT";
     else if (ccStatus == kCCDecodeError) return @"DECODE ERROR";
     else if (ccStatus == kCCUnimplemented) return @"UNIMPLEMENTED"; */
    
    NSString *result;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                               length:(NSUInteger)movedBytes]
                                       encoding:NSUTF8StringEncoding];
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [coder encode:myData];
    }
    free(bufferPtr);
    return result;
}

@end
