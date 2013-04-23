//
//  HttpUtil.m
//  Tuxiazi
//
//  Created by  on 11-8-27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "HttpClient.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "DataUtil.h"

@implementation HttpException
@end

@implementation HttpClientException
@end


@implementation HttpResponse
@end

@implementation HttpClient

- (id)init
{
    self = [super init];
    if (self) {
        self.params=[NSMutableDictionary dictionary];
        self.dataParams=[NSMutableDictionary dictionary];
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

-(NSMutableDictionary *)allParams{
    NSMutableDictionary* dic=[NSMutableDictionary dictionary];
    [dic addEntriesFromDictionary:self.params];
    [dic addEntriesFromDictionary:self.dataParams];
    return dic;
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
		NSString *enc_key=[DataUtil encodeURL:key];
		NSString *enc_value=[DataUtil encodeURL:value];
		NSString *k_v=[[NSString alloc] initWithFormat:@"%@=%@",enc_key,enc_value];
		[buf appendString:k_v];
		if (i<lastIdx) {
			[buf appendString:@"&"];
		}
		i++;
	}
    self.tmpUrl=buf;
}

-(void)executeRequest:(ASIHTTPRequest *)request asString:(BOOL)stringValue{
	request.timeOutSeconds=self.timeOutSeconds;
	[request startSynchronous];
	self.error=[request error];
	self.response=[[HttpResponse alloc] init];
	self.response.statusCode=request.responseStatusCode;
	self.response.error=self.error;
	if (stringValue) {
        NSData* data=[[NSData alloc] initWithData:request.responseData];
        self.response.text=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
#if HTTPCLIENT_DEBUG
        NSLog(@"responseEncoding : %i",request.responseEncoding);
        NSLog(@"responseHeaders : %@",[request.responseHeaders description]);
        NSLog(@"responseText : %@",self.response.text);
#endif
	}
	else{
		self.response.data=request.responseData;
	}
}

-(void)doGet{
    [self buildGetUrl];
	ASIHTTPRequest *req=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.tmpUrl]];
	req.requestMethod=@"GET";
	[self executeRequest:req asString:YES];
}

-(void)doGetData{
    [self buildGetUrl];
	ASIHTTPRequest *req=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.tmpUrl]];
	req.requestMethod=@"GET";
	[self executeRequest:req asString:NO];
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
	[self executeRequest:req asString:true];
}

@end
