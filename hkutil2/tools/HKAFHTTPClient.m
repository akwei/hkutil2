//
//  HKAFHTTPClient.m
//  hkutil2
//
//  Created by akwei on 13-5-28.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import "HKAFHTTPClient.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"

@interface HKAFHTTPClient ()
@property(nonatomic,strong) NSMutableDictionary* params;
@property(nonatomic,strong) NSMutableDictionary *dataParams;//请求的上传数据的key_value值
@property(nonatomic,strong) NSMutableArray *postTextArr;//post body
@property(nonatomic,strong) NSMutableDictionary* headers;
@property(nonatomic,strong) AFHTTPClient* client;
@property(nonatomic,assign) NSHTTPCookieStorage* cookieStorage;
@end

@implementation HKAFHTTPClient{
    BOOL _done;
}

-(id)init{
    self = [super init];
    if (self) {
        self.params = [[NSMutableDictionary alloc] init];
        self.headers = [[NSMutableDictionary alloc] init];
        self.dataParams = [[NSMutableDictionary alloc] init];
        self.cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        [self.cookieStorage setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
        self.forText = YES;
        
    }
    return self;
}

-(void)executeMethod:(NSString*)method{
    self.client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:self.url]];
    self.client.stringEncoding = NSUTF8StringEncoding;
    self.client.parameterEncoding = AFFormURLParameterEncoding;
    NSDictionary* headersFromCookies = [NSHTTPCookie requestHeaderFieldsWithCookies:self.cookieStorage.cookies];
    [self.headers addEntriesFromDictionary:headersFromCookies];
    for (NSString* key in self.headers) {
        NSString* value = [self.headers valueForKey:key];
        [self.client setDefaultHeader:key value:value];
    }
    NSMutableURLRequest* request = [self createRequest:method];
    HKAFHTTPClient* me = self;
    AFHTTPRequestOperation *operation = [self.client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [me onFinish:operation :nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [me onFinish:operation :error];
    }];
    [self.client enqueueHTTPRequestOperation:operation];
    [self doRunLoop];
}

-(NSMutableURLRequest*)createRequest:(NSString*)method{
    NSDictionary* params = nil;
    if (![method isEqualToString:@"GET"]) {
        params = self.params;
    }
    NSMutableURLRequest *request = nil;
    HKAFHTTPClient* me = self;
    if ([self.dataParams count] > 0) {
        request = [self.client multipartFormRequestWithMethod:method path:@"" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            for (NSString* key in me.dataParams) {
                id obj = [me.dataParams valueForKey:key];
                [formData appendPartWithFormData:obj name:key];
            }
        }];
    }
    else{
        request = [self.client requestWithMethod:method path:@"" parameters:params];
    }
    request.timeoutInterval = self.timeout;
    return request;
}

-(void)doGet{
    NSString* turl = [self buildGetUrl];
    self.url = turl;
    [self executeMethod:@"GET"];
}

-(void)doPost{
    [self executeMethod:@"POST"];
}

-(void)onFinish:(AFHTTPRequestOperation *)operation :(NSError *)error{
    _done = YES;
    self.responseStatusCode = operation.response.statusCode;
    self.responseStatusText = [NSHTTPURLResponse localizedStringForStatusCode:self.responseStatusCode];
    self.responseData = operation.responseData;
    self.responseCookies = self.cookieStorage.cookies;
    if (self.forText && self.responseData) {
        self.responseString = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    }
}

-(void)doRunLoop{
    while (!_done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

#pragma mark - addKeyValue method
-(void)addParam:(id)value forKey:(NSString *)key{
	[self.params setObject:value forKey:key];
}

-(void)addString:(NSString *)value forKey:(NSString *)key{
    [self addParam:value forKey:key];
}

-(void)addInteger:(NSInteger)value forKey:(NSString *)key{
    NSNumber* n=[[NSNumber alloc] initWithInteger:value];
    [self addString:[n stringValue] forKey:key];
}

-(void)addUnsignedInteger:(NSUInteger)value forKey:(NSString *)key{
    NSNumber* n=[[NSNumber alloc] initWithUnsignedInteger:value];
    [self addString:[n stringValue] forKey:key];
}

-(void)addBOOL:(BOOL)value forKey:(NSString *)key{
    if (value) {
        [self addString:@"true" forKey:key];
    }
    else{
        [self addString:@"false" forKey:key];
    }
}

-(void)addFloat:(float)value forKey:(NSString *)key{
    NSNumber* n=[[NSNumber alloc] initWithFloat:value];
    [self addString:[n stringValue] forKey:key];
}

-(void)addDouble:(double)value forKey:(NSString *)key{
    NSNumber* n=[[NSNumber alloc] initWithDouble:value];
    [self addString:[n stringValue] forKey:key];
}

-(void)addDoubleForDate:(NSDate *)value forKey:(NSString *)key{
    double t=[value timeIntervalSince1970];
    NSInteger int_t=(NSInteger)t;
    [self addInteger:int_t forKey:key];
}

-(void)addLong:(long)value forKey:(NSString *)key{
    NSNumber* n=[[NSNumber alloc] initWithLong:value];
    [self addString:[n stringValue] forKey:key];
}

-(void)addUnsignedLong:(unsigned long)value forKey:(NSString *)key{
    NSNumber* n=[[NSNumber alloc] initWithUnsignedLong:value];
    [self addString:[n stringValue] forKey:key];
}

-(void)addLongLong:(long long)value forKey:(NSString *)key{
    NSNumber* n=[[NSNumber alloc] initWithLongLong:value];
    [self addString:[n stringValue] forKey:key];
}

-(void)addUnsignedLongLong:(unsigned long long)value forKey:(NSString *)key{
    NSNumber* n=[[NSNumber alloc] initWithUnsignedLongLong:value];
    [self addString:[n stringValue] forKey:key];
}

-(void)addData:(NSData *)value forKey:(NSString *)key{
	[self.dataParams setObject:value forKey:key];
}

-(void)addPostText:(NSString *)text{
    [self.postTextArr addObject:text];
}

#pragma mark - header method

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

#pragma mark - cookie method

-(void)addCookie:(NSHTTPCookie *)cookie{
    [self.cookieStorage setCookie:cookie];
}

#pragma mark - common method

-(NSString*)buildGetUrl{
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
		NSString *enc_key=[self encodeURL:key];
		NSString *enc_value=[self encodeURL:value];
		NSString *k_v=[[NSString alloc] initWithFormat:@"%@=%@",enc_key,enc_value];
		[buf appendString:k_v];
		if (i<lastIdx) {
			[buf appendString:@"&"];
		}
		i++;
	}
    return buf;
}

- (NSString*)encodeURL:(NSString *)string
{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (__bridge CFStringRef)string,
                                                                                                    NULL,
                                                                                                    //                                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                    (CFStringRef)@":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`",
                                                                                                    kCFStringEncodingUTF8 ));
    return encodedString;
}

#pragma mark - override

-(NSString *)description{
    return [self.client description];
}
@end
