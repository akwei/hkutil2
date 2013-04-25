//
//  EncUtil.h
//  encutil
//
//  Created by 伟 袁 on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKEncUtil : NSObject

+(NSString*)md5:(NSString*)value;

+(NSString*)encodeBase64:(NSString*)value;

+(NSData*)decodeBase64:(NSString*)value;

+(NSString*) encodeDESWithBase64WithKey:(NSString*)key value:(NSString*)value;
+(NSString*) decodeDESWithBase64WithKey:(NSString*)key value:(NSString*)value;

+(NSString*)encodeDESToHexWithKey:(NSString*)key value:(NSString*)value;
+(NSString*)decodeDESHexWithKey:(NSString*)key hex:(NSString*)hex;

+(NSString*) encode3DESWithBase64WithKey:(NSString*)key value:(NSString*)value;
+(NSString*) decode3DESWithBase64WithKey:(NSString*)key value:(NSString*)value;

+(NSString*)encode3DESToHexWithKey:(NSString*)key value:(NSString*)value;
+(NSString*)decode3DESHexWithKey:(NSString*)key hex:(NSString*)hex;

@end
