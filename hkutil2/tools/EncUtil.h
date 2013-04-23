//
//  EncUtil.h
//  encutil
//
//  Created by 伟 袁 on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EncUtil : NSObject

+(NSString*)md5:(NSString*)value;

+(NSString*)encodeBase64:(NSString*)value;

+(NSData*)decodeBase64:(NSString*)value;

+(NSString*) encodeDESWithBase64WithKey:(NSString*)key value:(NSString*)value;

+(NSString*) decodeDESWithBase64WithKey:(NSString*)key value:(NSString*)value;

+(NSString*)encodeDESToHex:(NSString*)key value:(NSString*)value;

+(NSString*)decodeDESHex:(NSString*)key hex:(NSString*)hex;

+(NSString*) encode3DESWithBase64WithKey:(NSString*)key value:(NSString*)value;

+(NSString*) decode3DESWithBase64WithKey:(NSString*)key value:(NSString*)value;

@end
