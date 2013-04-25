//
//  HttpUtil.m
//  Tuxiazi
//
//  Created by  on 11-8-27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "HKHttpClient.h"
#import "ASIFormDataRequest.h"
#import "HKDataUtil.h"

#define HTTPCLIENT_DEBUG 0

@interface HKHttpClient ()
@property(nonatomic,copy) NSString* tmpUrl;
@property(nonatomic,copy) NSString *method;
@property(nonatomic,strong) NSMutableDictionary *params;//请求参数key_value值
@property(nonatomic,strong) NSMutableDictionary *dataParams;//请求的上传数据的key_value值
@property(nonatomic,strong) NSMutableArray *postTextArr;//post body
@property(nonatomic,strong) NSMutableDictionary* headers;
@property(nonatomic,strong) NSMutableArray* cookies;
@end

@implementation HKHttpClient

- (id)init
{
    self = [super init];
    if (self) {
        self.params=[NSMutableDictionary dictionary];
        self.dataParams=[NSMutableDictionary dictionary];
        self.headers = [[NSMutableDictionary alloc] init];
        self.postTextArr=[NSMutableArray array];
		[self setRequestGetMetod];
    }
    return self;
}

-(void)setRequestGetMetod{
	self.method=@"GET";
}

-(void)setRequestPostMethod{
	self.method=@"POST";
}

-(void)addParam:(id)value forKey:(NSString *)key{
	[self.params setObject:value forKey:key];
}

-(void)addString:(NSString *)value forKey:(NSString *)key{
    [self addParam:value forKey:key];
}

-(void)addInteger:(NSInteger)value forKey:(NSString *)key{
    NSNumber* n=[[NSNumber alloc] initWithInteger:value];
    [self addParam:[n stringValue] forKey:key];
}

-(void)addUnsignedInteger:(NSUInteger)value forKey:(NSString *)key{
    NSNumber* n=[[NSNumber alloc] initWithUnsignedInteger:value];
    [self addParam:[n stringValue] forKey:key];
}

-(void)addBOOL:(BOOL)value forKey:(NSString *)key{
    if (value) {
        [self addParam:@"true" forKey:key];
    }
    else{
        [self addParam:@"false" forKey:key];
    }
}

-(void)addFloat:(float)value forKey:(NSString *)key{
    NSNumber* n=[[NSNumber alloc] initWithFloat:value];
    [self addParam:[n stringValue] forKey:key];
}

-(void)addDouble:(double)value forKey:(NSString *)key{
    NSNumber* n=[[NSNumber alloc] initWithDouble:value];
    [self addParam:[n stringValue] forKey:key];
}

-(void)addDoubleForDate:(NSDate *)value forKey:(NSString *)key{
    double t=[value timeIntervalSince1970];
    NSInteger int_t=(NSInteger)t;
    [self addInteger:int_t forKey:key];
}

-(void)addLong:(long)value forKey:(NSString *)key{
    NSNumber* n=[[NSNumber alloc] initWithLong:value];
    [self addParam:[n stringValue] forKey:key];
}

-(void)addUnsignedLong:(unsigned long)value forKey:(NSString *)key{
    NSNumber* n=[[NSNumber alloc] initWithUnsignedLong:value];
    [self addParam:[n stringValue] forKey:key];
}

-(void)addLongLong:(long long)value forKey:(NSString *)key{
    NSNumber* n=[[NSNumber alloc] initWithLongLong:value];
    [self addParam:[n stringValue] forKey:key];
}

-(void)addUnsignedLongLong:(unsigned long long)value forKey:(NSString *)key{
    NSNumber* n=[[NSNumber alloc] initWithUnsignedLongLong:value];
    [self addParam:[n stringValue] forKey:key];
}

-(void)addData:(NSData *)value forKey:(NSString *)key{
	[self.dataParams setObject:value forKey:key];
}

-(void)addPostText:(NSString *)text{
    [self.postTextArr addObject:text];
}

-(void)addHeaderString:(NSString *)value forKey:(NSString *)key{
    [self.headers setValue:value forKey:key];
}

-(void)addHeaderInteger:(NSInteger)value forKey:(NSString *)key{
    NSNumber* n = [[NSNumber alloc] initWithInteger:value];
    [self addHeaderString:[n stringValue] forKey:key];
}

-(void)addHeaderUnsignedInteger:(NSUInteger)value forKey:(NSString *)key{
    NSNumber* n = [[NSNumber alloc] initWithUnsignedInteger:value];
    [self addHeaderString:[n stringValue] forKey:key];
}

-(void)addHeaderLong:(long)value forKey:(NSString *)key{
    NSNumber* n = [[NSNumber alloc] initWithLong:value];
    [self addHeaderString:[n stringValue] forKey:key];
}

-(void)addHeaderUnsignedLong:(unsigned long)value forKey:(NSString *)key{
    NSNumber* n = [[NSNumber alloc] initWithUnsignedLong:value];
    [self addHeaderString:[n stringValue] forKey:key];
}

-(void)addHeaderLongLong:(long long)value forKey:(NSString *)key{
    NSNumber* n = [[NSNumber alloc] initWithLongLong:value];
    [self addHeaderString:[n stringValue] forKey:key];
}

-(void)addHeaderUnsignedLongLong:(unsigned long long)value forKey:(NSString *)key{
    NSNumber* n = [[NSNumber alloc] initWithUnsignedLongLong:value];
    [self addHeaderString:[n stringValue] forKey:key];
}

-(void)addHeaderDouble:(double)value forKey:(NSString *)key{
    NSNumber* n = [[NSNumber alloc] initWithDouble:value];
    [self addHeaderString:[n stringValue] forKey:key];
}

-(void)addHeaderFloat:(float)value forKey:(NSString *)key{
    NSNumber* n = [[NSNumber alloc] initWithFloat:value];
    [self addHeaderString:[n stringValue] forKey:key];
}

-(NSMutableDictionary *)allParams{
    NSMutableDictionary* dic=[NSMutableDictionary dictionary];
    [dic addEntriesFromDictionary:self.params];
    [dic addEntriesFromDictionary:self.dataParams];
    return dic;
}

-(void)addCookie:(NSHTTPCookie *)cookie{
    [self.cookies addObject:cookie];
}

-(void)buildGetUrl{
	NSMutableString *buf=[[NSMutableString alloc] init];
	[buf appendString:self.url];
	NSRange r=[self.url rangeOfString:@"?"];
	if (r.location==NSNotFound) {
		if ([self.params count]>0) {
			[buf appendString:@"?"];
		}
	}
	else{
		[buf appendString:@"&"];
	}
	int i=0;
	int lastIdx=[self.params count]-1;
	for (NSString *key in self.params) {
		id value=[self.params objectForKey:key];
		NSString *enc_key=[HKDataUtil encodeURL:key];
		NSString *enc_value=[HKDataUtil encodeURL:value];
		NSString *k_v=[[NSString alloc] initWithFormat:@"%@=%@",enc_key,enc_value];
		[buf appendString:k_v];
		if (i<lastIdx) {
			[buf appendString:@"&"];
		}
		i++;
	}
    self.tmpUrl=buf;
}

-(void)executeRequest:(BOOL)binary{
    self.request.requestHeaders = self.headers;
    self.request.requestCookies = self.cookies;
	self.request.timeOutSeconds=self.timeOutSeconds;
	[self.request startSynchronous];
    self.responseData = [[NSData alloc] initWithData:self.request.responseData];
#if HTTPCLIENT_DEBUG
    NSLog(@"httpMethod : %@",self.request.requestMethod);
    NSLog(@"responseEncoding : %i",self.request.responseEncoding);
    NSLog(@"responseHeaders : %@",[self.request.responseHeaders description]);
    if (binary) {
        NSLog(@"responseData : %@",self.responseData);
    }
    else{
        NSLog(@"responseText : %@",self.responseText);
    }
    NSLog(@"responseStatusCode : %i",self.request.responseStatusCode);
#endif
	if (binary) {
        self.responseText = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
	}
}

-(void)doGet{
    [self buildGetUrl];
    self.request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.tmpUrl]];
	self.request.requestMethod=@"GET";
    [self executeRequest:YES];
}

-(void)doGetForBinary{
    [self buildGetUrl];
	self.request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.tmpUrl]];
	self.request.requestMethod=@"GET";
	[self executeRequest:NO];
}

-(void)doPost{
	ASIFormDataRequest *req=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:self.url]];
	req.requestMethod=@"POST";
	for (NSString *key in self.params) {
		id value=[self.params objectForKey:key];
		[req addPostValue:value forKey:key];
	}
	for (NSString *key in self.dataParams) {
		NSData *data=[self.dataParams objectForKey:key];
		[req addData:data forKey:key];
	}
    for (NSString *text in self.postTextArr) {
        [req appendPostData:[text dataUsingEncoding:NSUTF8StringEncoding]];
    }
	[self executeRequest:YES];
}

-(void)doPostForBinary{
    ASIFormDataRequest *req=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:self.url]];
	req.requestMethod=@"POST";
	for (NSString *key in self.params) {
		id value=[self.params objectForKey:key];
		[req addPostValue:value forKey:key];
	}
	for (NSString *key in self.dataParams) {
		NSData *data=[self.dataParams objectForKey:key];
		[req addData:data forKey:key];
	}
    for (NSString *text in self.postTextArr) {
        [req appendPostData:[text dataUsingEncoding:NSUTF8StringEncoding]];
    }
	[self executeRequest:NO];
}

@end
