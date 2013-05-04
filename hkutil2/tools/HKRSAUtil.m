//
//  HKRSAUtil.m
//  hkutil2
//
//  Created by akwei on 13-5-1.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import "HKRSAUtil.h"

@implementation HKRSAUtil

-(void)buildKeyInfo{
    OSStatus status = noErr;
    NSMutableDictionary *privateKeyAttr = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *publicKeyAttr = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *keyPairAttr = [[NSMutableDictionary alloc] init];
    
    _publicSecKeyRef = NULL;
    _privateSecKeyRef = NULL;
    
    [keyPairAttr setObject:(__bridge id)kSecAttrKeyTypeRSA
                    forKey:(__bridge id)kSecAttrKeyType];
    [keyPairAttr setObject:[NSNumber numberWithInt:1024]
                    forKey:(__bridge id)kSecAttrKeySizeInBits];
    if (self.privateKeyData) {
        [privateKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecAttrIsPermanent];
        [privateKeyAttr setObject:self.privateKeyData forKey:(__bridge id)kSecAttrApplicationTag];
    }
    if (self.publicKeyData) {
        [publicKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecAttrIsPermanent];
        [publicKeyAttr setObject:self.publicKeyData forKey:(__bridge id)kSecAttrApplicationTag];
    }
    
    [keyPairAttr setObject:privateKeyAttr forKey:(__bridge id)kSecPrivateKeyAttrs];
    [keyPairAttr setObject:publicKeyAttr forKey:(__bridge id)kSecPublicKeyAttrs];
    
    status = SecKeyGeneratePair((__bridge CFDictionaryRef)keyPairAttr,
                                &_publicSecKeyRef, &_privateSecKeyRef);

    //    error handling...
    if (status != noErr) {
        NSLog(@"has error when generating the key pair. status=%ld",status);
        return;
    }
}
-(NSData *)encryptData:(NSData *)data usePublicKey:(BOOL)flag{
    SecKeyRef key = NULL;
    if (flag) {
        key = _publicSecKeyRef;
    }
    else{
        key = _privateSecKeyRef;
    }
    OSStatus status = noErr;
    size_t dataLength = [data length];
    size_t cipherBufferSize = SecKeyGetBlockSize(key);
    uint8_t* cipherBuffer = malloc( cipherBufferSize * sizeof(uint8_t) );
    memset((void *)cipherBuffer, 0x0, cipherBufferSize);
    NSInteger blockSize = cipherBufferSize - 12;
    NSInteger blockCount = dataLength / blockSize;
    if (dataLength % blockSize !=0) {
        blockCount = blockCount + 1;
    }
    NSMutableData* mData = [[NSMutableData alloc] init];
    for (int i=0; i<blockCount; i++) {
        int bufferSize = MIN(blockSize,dataLength - i * blockSize);
        NSData* subBuffer = [data subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        status = SecKeyEncrypt(key,
                               kSecPaddingPKCS1,
                               (const uint8_t*)[subBuffer bytes],
                               [subBuffer length],
                               cipherBuffer,
                               &cipherBufferSize);
        if (status == errSecSuccess) {
            [mData appendBytes:cipherBuffer length:cipherBufferSize];
        }
        else{
            free(cipherBuffer);
            NSLog(@"rsa encrypt has error. status=%ld",status);
            return nil;
        }
    }
    free(cipherBuffer);
    return mData;
}
-(NSData *)decryptData:(NSData *)data usePublicKey:(BOOL)flag{
    SecKeyRef key = NULL;
    if (flag) {
        key = _publicSecKeyRef;
    }
    else{
        key = _privateSecKeyRef;
    }
    OSStatus status = noErr;
    size_t cipherBufferSize = [data length];
//    uint8_t* cipherBuffer = (uint8_t *)[data bytes];
    size_t plainBufferSize = SecKeyGetBlockSize(key) ;
    uint8_t* plainBuffer = malloc( plainBufferSize * sizeof(uint8_t) );
	memset((void *)plainBuffer, 0x0, plainBufferSize);
    
    // Ordinarily, you would split the data up into blocks
    // equal to plainBufferSize, with the last block being
    // shorter. For simplicity, this example assumes that
    // the data is short enough to fit.
    
    NSInteger blockSize = plainBufferSize;
    NSInteger blockCount = cipherBufferSize / blockSize;
    if (cipherBufferSize % blockSize !=0) {
        blockCount = blockCount + 1;
    }
    NSMutableData* mData = [[NSMutableData alloc] init];
    for (int i=0; i<blockCount; i++) {
        int bufferSize = MIN(blockSize,cipherBufferSize - i * blockSize);
        NSData* subBuffer = [data subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        status = SecKeyDecrypt(key,
                               kSecPaddingPKCS1,
                               (const uint8_t*)[subBuffer bytes],
                               [subBuffer length],
                               plainBuffer,
                               &plainBufferSize);
        if (status == errSecSuccess) {
            [mData appendBytes:plainBuffer length:plainBufferSize];
        }
        else{
            free(plainBuffer);
            NSLog(@"rsa decrypt has error. status=%ld",status);
            return nil;
        }
    }
    free(plainBuffer);
    return mData;
}
@end
