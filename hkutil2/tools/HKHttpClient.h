//
//  HttpUtil.h
//  Tuxiazi
//
//  Created by  on 11-8-27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

/*
 ASIHTTPRequest 的封装，只支持同步模式，不支持异步，异步调用需要在调用层。目前只支持UTF-8编码
 使用方式:
 HttpClient* client = [[HttpClient alloc] init];
 client.timeOutSeconds = 30;
 client.url = "http://github.com/?a=t";
 [client addString:@"akwei" forKey:@"name"];
 [client doGet];
 if (client.request.error){
 // has error
 }
 NSString* responseText = client.responseText;
 NSData* responseData = client.responseData;
 int statusCode = client.request.responseStatusCode;
 */
@interface HKHttpClient : NSObject

@property(nonatomic,assign) NSTimeInterval timeOutSeconds;
@property(nonatomic,copy) NSString *url;
@property(nonatomic,strong) ASIHTTPRequest* request;
@property(nonatomic,strong) NSData* responseData;
@property(nonatomic,strong) NSString* responseText;

-(void)addString:(NSString*)value forKey:(NSString *)key;
-(void)addInteger:(NSInteger)value forKey:(NSString*)key;
-(void)addUnsignedInteger:(NSUInteger)value forKey:(NSString*)key;
-(void)addBOOL:(BOOL)value forKey:(NSString*)key;
-(void)addFloat:(float)value forKey:(NSString*)key;
-(void)addDouble:(double)value forKey:(NSString*)key;
-(void)addLong:(long)value forKey:(NSString*)key;
-(void)addUnsignedLong:(unsigned long)value forKey:(NSString*)key;
-(void)addLongLong:(long long)value forKey:(NSString*)key;
-(void)addUnsignedLongLong:(unsigned long long)value forKey:(NSString*)key;
-(void)addDoubleForDate:(NSDate*)value forKey:(NSString*)key;
-(void)addData:(NSData *)value forKey:(NSString *)key;
-(void)addPostText:(NSString*)text;

-(void)addHeaderString:(NSString*)value forKey:(NSString*)key;
-(void)addHeaderInteger:(NSInteger)value forKey:(NSString*)key;
-(void)addHeaderUnsignedInteger:(NSUInteger)value forKey:(NSString*)key;
-(void)addHeaderLong:(long)value forKey:(NSString*)key;
-(void)addHeaderUnsignedLong:(unsigned long)value forKey:(NSString*)key;
-(void)addHeaderLongLong:(long long)value forKey:(NSString*)key;
-(void)addHeaderUnsignedLongLong:(unsigned long long)value forKey:(NSString*)key;
-(void)addHeaderFloat:(float)value forKey:(NSString*)key;
-(void)addHeaderDouble:(double)value forKey:(NSString*)key;

-(void)addCookie:(NSHTTPCookie*)cookie;

/*
 返回所有key value
 */
-(NSMutableDictionary*)allParams;

/**
 *进行get请求
 **/
-(void)doGet;

-(void)doGetData;

/**
 *进行post请求
 **/
-(void)doPost;


@end
