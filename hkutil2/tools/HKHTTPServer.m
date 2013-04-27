//
//  HKHTTPServer.m
//  hkutil2
//
//  Created by akwei on 13-4-26.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import "HKHTTPServer.h"
#import "HTTPMessage.h"
#import "HTTPDataResponse.h"
#import "HTTPFileResponse.h"
#import "HTTPDynamicFileResponse.h"
#import "HTTPLogging.h"
#import "HKTimerInvoker.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "HKHttpClient.h"
#import "HKDeviceUtil.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <arpa/inet.h>
#import <sys/time.h>

#define HKHTTPSessionDebug 0
#define HKHTTPConnectionDebug 0

#define ios_sessionid @"ios_sessionid"

static const int httpLogLevel = HTTP_LOG_LEVEL_WARN;
static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation HKHTTPDataResponse
-(void)addHeaderWithValue:(NSString *)value forKey:(NSString *)key{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.responseHeaders=[NSMutableDictionary dictionary];
    });
    [self.responseHeaders setValue:value forKey:key];
}

-(NSDictionary *)httpHeaders{
    return self.responseHeaders;
}
@end

#pragma mark - HKHTTPSession
@implementation HKHTTPSession

-(id)initWithSessionId:(NSString *)sessionId{
    self = [super init];
    if (self) {
        NSDate* date = [[NSDate alloc] init];
        double longtime = [date timeIntervalSince1970];
        self.sessionId = sessionId;
        self.lastAccessTime=longtime;
        self.invalidFlg=NO;
    }
    return self;
}

-(void)setAttribute:(id)value forKey:(NSString *)key{
    @synchronized(self){
        if (!self.dic) {
            self.dic = [[NSMutableDictionary alloc] init];
        }
    }
    [self.dic setValue:value forKey:key];
}

-(id)attributeForKey:(NSString *)key{
    return [self.dic valueForKey:key];
}

-(void)removeAttributeForKey:(NSString *)key{
    [self.dic removeObjectForKey:key];
}

-(void)clear{
    [self.dic removeAllObjects];
}

-(void)invalid{
#if HKHTTPSessionDebug
    NSLog(@"invalid session : %@",self.sessionId);
#endif
    self.invalidFlg=YES;
    [self clear];
}

-(BOOL)isExpired:(NSTimeInterval)time{
    NSDate* date = [[NSDate alloc] init];
    double longtime = [date timeIntervalSince1970];
    if (longtime - self.lastAccessTime > time) {
        return YES;
    }
    return NO;
}

-(void)updateAccessTime{
    NSDate* date = [[NSDate alloc] init];
    self.lastAccessTime=[date timeIntervalSince1970];
}

@end

#pragma mark - HKHTTPSessionMgr
@interface HKHTTPSessionMgr()
/*
 存储所创建的所有session
 */
@property(nonatomic,strong)NSMutableDictionary* sessionDic;
@end

/*
 存储HKHTTPSessionListener
 */
static HKHTTPSessionMgr* _shareSessionMgr=nil;
@implementation HKHTTPSessionMgr{
    dispatch_queue_t syncQueue;
    HKTimerInvoker* _timerInvoker;
    NSMutableArray* _sessionListeners;
}

+(id)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareSessionMgr = [[HKHTTPSessionMgr alloc] init];
        _shareSessionMgr.sessionLiveTime = 60*20;
        _shareSessionMgr.checkDelayTime = 10;
        _shareSessionMgr.checkIntervalTime = 60;
    });
    return _shareSessionMgr;
}


-(id)init{
    self = [super init];
    if (self) {
        self.checkIntervalTime = 60;
        self.checkDelayTime= 30;
        syncQueue = dispatch_queue_create("HKHTTPSessionMgr.syncQueue", DISPATCH_QUEUE_SERIAL);
        self.sessionDic = [[NSMutableDictionary alloc] init];
        _timerInvoker = [[HKTimerInvoker alloc] init];
    }
    return self;
}

-(BOOL)addHTTPSessionListener:(id<HKHTTPSessionListener>)listener{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sessionListeners = [[NSMutableArray alloc] init];
    });
    for (id<HKHTTPSessionListener> obj in _sessionListeners) {
        if (obj==listener) {
            return NO;
        }
    }
    [_sessionListeners addObject:listener];
    return YES;
}

-(void)removeHTTPSessionListener:(id<HKHTTPSessionListener>)listener{
    [_sessionListeners removeObject:listener];
}

-(void)removeAllHttpSessionListeners{
    [_sessionListeners removeAllObjects];
}


-(NSString*)createSessionId{
    NSDate* date = [[NSDate alloc] init];
    unsigned long long longtime = [date timeIntervalSince1970];
    struct timeval tpstart;
    gettimeofday(&tpstart,NULL);
    NSUInteger usec = tpstart.tv_usec;
    NSUInteger rand = 0 + (arc4random()%(NSIntegerMax-0+1));
    NSString* sid = [[NSString alloc] initWithFormat:@"%llu%llu%llu",longtime,(unsigned long long)usec,(unsigned long long)rand];
    return sid;
}

-(void)startSessionChecker{
    @synchronized(self){
        [_timerInvoker stop:YES];
        _timerInvoker.time = self.checkIntervalTime;
        dispatch_queue_t _queue = syncQueue;
        __block __unsafe_unretained  HKHTTPSessionMgr* me = self;
        _timerInvoker.jobBlock = ^{
            NSMutableArray* keys = [[NSMutableArray alloc] init];
            [me.sessionDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                HKHTTPSession* session = (HKHTTPSession*)obj;
                dispatch_sync(_queue, ^{
                    if (session.invalidFlg) {
                        [keys addObject:session.sessionId];
                    }
                    else{
                        if ([session isExpired:me.sessionLiveTime]) {
                            [session invalid];
                            [keys addObject:session.sessionId];
                        }
                    }
                });
            }];
            for (NSString* key in keys) {
                [me removeHTTPSessionForSessionId:key];
            }
            return NO;
        };
        [_timerInvoker startWithDelay:self.checkDelayTime];
    }
}

-(void)stopSessionChecker{
    [_timerInvoker stop:YES];
}

-(HKHTTPSession *)httpSessionForSessionId:(NSString *)sessionId createIfNotExist:(BOOL)flag{
    __block HKHTTPSession* session=nil;
    __block __unsafe_unretained HKHTTPSessionMgr* me = self;
    dispatch_sync(syncQueue, ^{
        session = [me.sessionDic valueForKey:sessionId];
        if (session) {
            if (session.invalidFlg) {
                return;
            }
            if ([session isExpired:me.sessionLiveTime]) {
                [session invalid];
                return;
            }
            [session updateAccessTime];
        }
        else{
            if (flag) {
                session = [[HKHTTPSession alloc] initWithSessionId:[me createSessionId]];
                session.sessionMgr=me;
                [me.sessionDic setValue:session forKey:session.sessionId];
                for (id<HKHTTPSessionListener> obj in _sessionListeners) {
                    [obj httpSessionListenerOnSessionCreated:session];
                }
            }
        }
    });
    return session;
}

-(void)removeHTTPSessionForSessionId:(NSString *)sessionId{
    __block id session;
    __block __unsafe_unretained HKHTTPSessionMgr* me = self;
    dispatch_sync(syncQueue, ^{
        session = [me.sessionDic valueForKey:sessionId];
        if (session) {
            [me.sessionDic removeObjectForKey:sessionId];
        }
    });
    if (session) {
        for (id<HKHTTPSessionListener> obj in _sessionListeners) {
            [obj httpSessionListenerOnSessionDestroyed:session];
        }
    }
}

-(void)dealloc{
    [_timerInvoker stop:YES];
}

@end


#pragma mark - HKActionMapping
@implementation HKActionMapping
@end


#pragma mark - ActionClassInfo
static NSMutableDictionary* actionClassInfoDic=nil;
@implementation ActionClassInfo

+(ActionClassInfo *)actionClassInfoWithClass:(Class)cls{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        actionClassInfoDic=[[NSMutableDictionary alloc] init];
    });
    NSString* clsName=[[NSString alloc] initWithUTF8String:class_getName(cls)];
    ActionClassInfo* aci=[actionClassInfoDic valueForKey:clsName];
    if (!aci) {
        aci=[[ActionClassInfo alloc] initWithClass:cls];
        [actionClassInfoDic setValue:aci forKey:clsName];
    }
    return aci;
}

-(id)initWithClass:(Class)cls{
    self=[super init];
    if (self) {
        self.cls=cls;
        self.propTypeEncodingDic=[NSMutableDictionary dictionary];
        Class currentCls=cls;
        while (currentCls!=nil && currentCls!=[NSObject class]) {
            [self createWithClass:currentCls];
            currentCls=[currentCls superclass];
        }
    }
    return self;
}

-(void)createWithClass:(Class)cls{
    unsigned int outCount;
    objc_property_t* props=class_copyPropertyList(cls, &outCount);
    for (int i=0; i<outCount; i++) {
        objc_property_t prop=props[i];
        const char* propName=property_getName(prop);
        NSString* _propName=[[NSString alloc] initWithUTF8String:propName];
        Ivar ivar=class_getInstanceVariable(cls, propName);
        if (!ivar) {
            NSString* pn=[[NSString alloc] initWithFormat:@"_%@",_propName];
            ivar=class_getInstanceVariable(cls, [pn UTF8String]);
        }
        const char* tye=ivar_getTypeEncoding(ivar);
        NSString* _tye=[[NSString alloc] initWithUTF8String:tye];
        [self.propTypeEncodingDic setValue:_tye forKey:_propName];
    }
    free(props);
}

-(BOOL)setPropValueWithObject:(id)obj value:(NSString*)value propName:(NSString *)propName{
    NSString* pn=propName;
    NSString* type=[self.propTypeEncodingDic valueForKey:pn];
    if (type) {
        if ([type isEqualToString:@"@\"NSString\""]) {
            [obj setValue:value forKey:pn];
        }
        else if ([type isEqualToString:@"i"]||
                 [type isEqualToString:@"I"]||
                 [type isEqualToString:@"l"]||
                 [type isEqualToString:@"L"]||
                 [type isEqualToString:@"Q"]
                 ){
            [obj setValue:[self numberValue:value] forKey:pn];
        }
        else if ([type isEqualToString:@"f"]||[type isEqualToString:@"d"]){
            [obj setValue:[self doubleNumberValue:value] forKey:pn];
        }
        else if ([type isEqualToString:@"B"]||
                 [type isEqualToString:@"c"]||
                 [type isEqualToString:@"C"]
                 ){
            [obj setValue:[self boolNumberValue:value] forKey:pn];
        }
        return YES;
    }
    return NO;
}

-(void)buildPropValueWithObject:(id)obj params:(NSMutableDictionary*)params{
    for (NSString* propName in self.propTypeEncodingDic) {
        id value = [params valueForKey:propName];
        if (value) {
            [self setPropValueWithObject:obj value:value propName:propName];
        }
    }
    if ([obj respondsToSelector:@selector(setHttpRequestParameters:)]) {
        [(id<ActionDelegate>)obj setHttpRequestParameters:params];
    }
}



-(NSNumber*)numberValue:(NSString *)value{
    @try {
        return [NSNumber numberWithLongLong:[value longLongValue]];
    }
    @catch (NSException *exception) {
        return 0;
    }
    @finally {
        
    }
}

-(NSNumber*)doubleNumberValue:(NSString *)value{
    @try {
        return [NSNumber numberWithLongLong:[value doubleValue]];
    }
    @catch (NSException *exception) {
        return 0;
    }
    @finally {
        
    }
}

-(NSNumber*)boolNumberValue:(NSString *)value{
    @try {
        return [NSNumber numberWithBool:[value boolValue]];
    }
    @catch (NSException *exception) {
        return [NSNumber numberWithBool:NO];
    }
    @finally {
    }
    
}

@end

#pragma mark - HKHTTPConnection
static NSMutableDictionary* mapping=nil;
static NSMutableDictionary* suffixDic=nil;
@implementation HKHTTPConnection{
    NSMutableDictionary* _paramsDic;
}

+(void)addSuffix:(NSString *)suffix{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        suffixDic = [[NSMutableDictionary alloc] init];
    });
    [suffixDic setValue:suffix forKey:suffix];
}

+(BOOL)hasSuffix:(NSString *)suffix{
    if ([suffixDic valueForKey:suffix]) {
        return YES;
    }
    return NO;
}

+(BOOL)isPathContainSuffix:(NSString *)path{
    __block BOOL has = NO;
    [suffixDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([path hasSuffix:obj]) {
            *stop = YES;
            has = YES;
        }
    }];
    return has;
}

+(void)addMappingWithURI:(NSString *)uri cls:(Class)cls method:(NSString *)method{
    @synchronized(self){
        if (!mapping) {
            mapping=[[NSMutableDictionary alloc] init];
        }
    }
    NSString* clsName=[NSString stringWithUTF8String:class_getName(cls)];
    NSString* value=[[NSString alloc] initWithFormat:@"%@:%@",clsName,method];
    [mapping setValue:value forKey:uri];
}

-(HKActionMapping *)getActionMappingWithURI:(NSString *)uri{
    NSString* value=[mapping valueForKey:uri];
    if (!value) {
        return nil;
    }
    NSArray* arr=[value componentsSeparatedByString:@":"];
    NSString* clsName=[arr objectAtIndex:0];
    NSString* method=[arr objectAtIndex:1];
    if ([arr count]!=2) {
        return nil;
    }
    id obj = [[NSClassFromString(clsName) alloc] init];
    HKActionMapping* mapping=[[HKActionMapping alloc] init];
    mapping.obj=obj;
    mapping.methodName=method;
    return mapping;
}

-(NSString*)invokeActionWithActionMapping:(HKActionMapping*)mapping{
    SEL sel=NSSelectorFromString(mapping.methodName);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [mapping.obj performSelector:sel];
#pragma clang diagnostic pop
    
}

-(NSMutableDictionary*)allParams{
    NSMutableDictionary* dic=[[NSMutableDictionary alloc] init];
    [dic addEntriesFromDictionary:[self parseGetParams]];
    if([self.requestMethod isEqualToString:@"POST"]){
        NSData* postData=[request body];
        if (postData) {
            NSString* postStr=[[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
            NSDictionary* dic_post=[self parseParams:postStr];
            if (dic_post) {
                [dic addEntriesFromDictionary:dic_post];
            }
        }
    }
    return dic;
}

-(HKHTTPSession*)createSession{
    NSString* sessionid = [_paramsDic valueForKey:ios_sessionid];
    sessionid = [sessionid stringByTrimmingCharactersInSet:
                 [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    __unsafe_unretained HKHTTPSessionMgr* smgr = [HKHTTPSessionMgr shareInstance];
    return [smgr httpSessionForSessionId:sessionid createIfNotExist:YES];
}

-(BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path{
    if ([method isEqualToString:@"POST"]) {
        return YES;
    }
    return [super supportsMethod:method atPath:path];
}
-(BOOL)expectsRequestBodyFromMethod:(NSString *)method atPath:(NSString *)path{
    self.requestMethod=method;
    if([method isEqualToString:@"POST"])
		return YES;
	return [super expectsRequestBodyFromMethod:method atPath:path];
}
-(NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path{
    @try {
#if HKHTTPConnectionDebug
        NSLog(@"request url : %@",path);
#endif
        NSString *filePath = [self filePathForURI:path];
        NSString *documentRoot = [config documentRoot];
        if (![filePath hasPrefix:documentRoot]){
            return nil;
        }
        NSString *relativePath = [filePath substringFromIndex:[documentRoot length]];
        BOOL enableMapping=NO;
        if ([HKHTTPConnection isPathContainSuffix:relativePath]) {
            enableMapping = YES;
        }
        if (enableMapping) {
            HKActionMapping* mapping = [self getActionMappingWithURI:relativePath];
            if (!mapping) {
                return nil;
            }
            _paramsDic = [self allParams];
            
            ActionClassInfo* aci = [ActionClassInfo actionClassInfoWithClass:[mapping.obj class]];
            [aci buildPropValueWithObject:mapping.obj params:_paramsDic];
            
            if ([mapping.obj respondsToSelector:@selector(setHttpRequestURI:)]) {
                [(id<ActionDelegate>)mapping.obj setHttpRequestURI:relativePath];
            }
            if ([mapping.obj respondsToSelector:@selector(setHttpSession:)]) {
                [(id<ActionDelegate>)mapping.obj setHttpSession:[self createSession]];
            }
            NSString* result = [self invokeActionWithActionMapping:mapping];
            if (!result) {
                return nil;
            }
            if ([result hasPrefix:@"f:"]) {
                NSString* fpath=[result substringFromIndex:2];
                filePath = [self filePathForURI:fpath allowDirectory:NO];
                BOOL isDir = NO;
                if (filePath && [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir] && !isDir){
                    NSMutableDictionary* valueDic=[[NSMutableDictionary alloc] init];
                    ActionClassInfo* aci = [ActionClassInfo actionClassInfoWithClass:[mapping.obj class]];
                    for (NSString* propName in aci.propTypeEncodingDic) {
                        id value = [mapping.obj valueForKey:propName];
                        [valueDic setValue:value forKey:propName];
                    }
                    HTTPDynamicFileResponse* resp=[[HTTPDynamicFileResponse alloc] initWithFilePath:filePath forConnection:self separator:@"%%" replacementDictionary:valueDic];
                    return resp;
                }
                return nil;
            }
            else{
                NSData* data=[result dataUsingEncoding:NSUTF8StringEncoding];
                HKHTTPDataResponse* resp=[[HKHTTPDataResponse alloc] initWithData:data];
                [resp addHeaderWithValue:@"text/html;charset=utf-8" forKey:@"Content-Type"];
                return resp;
            }
        }
        else{
            return [super httpResponseForMethod:method URI:path];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"HKHTTP exception %@",[exception description]);
        return nil;
    }
    @finally {
    }
    
}

-(void)processBodyData:(NSData *)postDataChunk{
    [request appendData:postDataChunk];
}

@end

@implementation HKStatusAction
-(NSString *)execute{
    return @"1";
}
@end

#pragma mark - HKHTTPServer

@implementation HKHTTPServer{
    HKTimerInvoker* _timerInvoker;
}
-(id)init{
    self = [super init];
    if (self) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [DDLog addLogger:[DDTTYLogger sharedInstance]];
            [HKHTTPConnection addSuffix:@".json"];
            [HKHTTPConnection addMappingWithURI:@"/status.json" cls:[HKStatusAction class] method:@"execute"];
        });
        self.type=@"_http._tcp.";
        NSString* webPath=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"web"];
        DDLogInfo(@"Setting document root: %@", webPath);
        self.documentRoot = webPath;
        self.connectionClass = [HKHTTPConnection class];
        _timerInvoker = [[HKTimerInvoker alloc] init];
        _timerInvoker.time = 30;
        __block __unsafe_unretained HKHTTPServer* me = self;
        _timerInvoker.jobBlock = ^{
            BOOL running = [me isRunning];
            if (running) {
                NSString* ip = [HKDeviceUtil localIp];
                HKHttpClient* client = [[HKHttpClient alloc] init];
                NSString* url = [[NSString alloc] initWithFormat:@"http://%@:%i/status.json",ip,me.port];
                client.url = url;
                client.timeOutSeconds = 5;
                [client doGet];
                if (client.request.error) {
                    running = NO;
                }
                if (client.request.responseStatusCode != 200) {
                    running = NO;
                }
            }
            if (!running) {
                NSLog(@"httpServer error , begin restart ...");
                [NSThread sleepForTimeInterval:1];
                [me stop];
                if ([me start]) {
                    NSLog(@"httpServer restart ok ...");
                }
            }
            return NO;
        };
    }
    return self;
}

-(BOOL)start{
    NSLog(@"HTTPserver starting ...");
    NSError *error;
    if([self start:&error]){
        DDLogInfo(@"Started HTTP Server on port %hu", [self listeningPort]);
        return YES;
    }
    else{
        DDLogError(@"Error starting HTTP Server: %@", error);
        return NO;
    }
}

-(void)stop{
    NSLog(@"HTTPserver stopping ...");
    [super stop];
    [NSThread sleepForTimeInterval:2];
    NSLog(@"HTTPserver stopped");
}

-(void)startCheckStatus{
    NSLog(@"HTTPserver start checking status ...");
    [_timerInvoker startWithDelay:10];
}

-(void)stopCheckStatus{
    NSLog(@"HTTPserver stop checking status ...");
    [_timerInvoker stop:YES];
}

-(void)dealloc{
    __unsafe_unretained HKHTTPSessionMgr* sessionMgr = [HKHTTPSessionMgr shareInstance];
    [sessionMgr removeAllHttpSessionListeners];
    [_timerInvoker stop:YES];
}
@end
