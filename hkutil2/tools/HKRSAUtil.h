//
//  HKRSAUtil.h
//  hkutil2
//
//  Created by akwei on 13-5-1.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKRSAUtil : NSObject{
    SecKeyRef _publicSecKeyRef;
    SecKeyRef _privateSecKeyRef;
}
@property(nonatomic,strong)NSData* publicKeyData;
@property(nonatomic,strong)NSData* privateKeyData;

-(void)buildKeyInfo;
-(NSData*)encryptData:(NSData*)data usePublicKey:(BOOL)flag;
-(NSData*)decryptData:(NSData*)data usePublicKey:(BOOL)flag;
@end
