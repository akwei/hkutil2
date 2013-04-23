//
//  HttpUtil.h
//  Tuxiazi
//
//  Created by  on 11-8-27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HTTPCLIENT_DEBUG 0

#define kHttpExceptionMsg @"服务器无响应"
#define kHttpClientException @"请求网络发成错误"

/*
 网络无响应,或服务器无响应
 */
@interface HttpException : NSException
@property(nonatomic,strong)NSString* statusText;
@property(nonatomic,assign)NSInteger statusCode;
@end

/*
 请求网络发成错误
 */
@interface HttpClientException : NSException
@property(nonatomic,retain)NSError* error;
@end

@class HttpResponse;

@interface HttpResponse : NSObject

@property(nonatomic,assign) NSInteger statusCode;
@property(nonatomic,retain) NSString *text;
@property(nonatomic,retain) NSData *data;
@property(nonatomic,retain) NSError *error;

@end

@interface HttpClient : NSObject{

}

@property(nonatomic,copy) NSString* tmpUrl;
@property(nonatomic,strong) HttpResponse *response;
@property(nonatomic,strong) NSError *error;
@property(nonatomic,assign) NSTimeInterval timeOutSeconds;
@property(nonatomic,copy) NSString *method;
@property(nonatomic,copy) NSString *url;
@property(nonatomic,strong) NSMutableDictionary *params;//请求参数key_value值
@property(nonatomic,strong) NSMutableDictionary *dataParams;//请求的上传数据的key_value值
@property(nonatomic,strong) NSMutableArray *postTextArr;//post body

-(void)setRequestGetMetod;

-(void)setRequestPostMethod;

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
