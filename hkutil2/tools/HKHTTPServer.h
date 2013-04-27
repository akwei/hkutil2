//
//  HKHTTPServer.h
//  hkutil2
//
//  Created by akwei on 13-4-26.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPConnection.h"
#import "HTTPDataResponse.h"
#import "HTTPServer.h"

@class HKHTTPSession;
@class HKHTTPSessionMgr;

@protocol HKHTTPSessionListener <NSObject>
/*
 session创建时触发此消息
 */
-(void)httpSessionListenerOnSessionCreated:(HKHTTPSession*)session;
/*
 session无效，销毁时触发此消息
 */
-(void)httpSessionListenerOnSessionDestroyed:(HKHTTPSession*)session;
@end

@interface HKHTTPDataResponse : HTTPDataResponse
@property(nonatomic,strong)NSMutableDictionary* responseHeaders;
-(void)addHeaderWithValue:(NSString*)value forKey:(NSString*)key;
@end

/*
 仿照HTTPSession，实现主要功能，用来与客户端保持会话使用
 */
@interface HKHTTPSession : NSObject
/*
 标识唯一性的id
 */
@property(nonatomic,copy)NSString* sessionId;
/*
 存储数据的dic
 */
@property(nonatomic,strong)NSMutableDictionary* dic;
/*
 最后一次激活时间
 */
@property(nonatomic,assign)double lastAccessTime;
@property(nonatomic,assign)BOOL invalidFlg;
@property(nonatomic,unsafe_unretained)HKHTTPSessionMgr* sessionMgr;

-(id)initWithSessionId:(NSString*)sessionId;
/*
 存储数据
 */
-(void)setAttribute:(id)value forKey:(NSString*)key;
/*
 获得数据，根据key
 */
-(id)attributeForKey:(NSString*)key;
/*
 删除数据，根据key
 */
-(void)removeAttributeForKey:(NSString*)key;
/*
 清除所有数据
 */
-(void)clear;
/*
 设置为当前session无效,session不会立刻删除，会通过sessionMgr来定期删除
 */
-(void)invalid;
/*
 查看session是否过期
 param time session有效时间
 */
-(BOOL)isExpired:(NSTimeInterval)time;
@end


/*
 用来管理session
 */
@interface HKHTTPSessionMgr : NSObject
/*
 session有效时间
 */
@property(nonatomic,assign)NSTimeInterval sessionLiveTime;
/*
 检查session的间隔时间
 */
@property(nonatomic,assign)NSTimeInterval checkIntervalTime;
/*
 延迟启动检查session的时间
 */
@property(nonatomic,assign)NSTimeInterval checkDelayTime;
/*
 如果有重复的listener添加，将不会添加成功返回NO。添加成功返回YES
 */

+(id)shareInstance;
-(BOOL)addHTTPSessionListener:(id<HKHTTPSessionListener>)listener;
-(void)removeHTTPSessionListener:(id<HKHTTPSessionListener>)listener;
-(void)removeAllHttpSessionListeners;
/*
 启动session监测器，检测过期session，如果有(过期/状态为无效)session，就会删除此session
 */
-(void)startSessionChecker;
-(void)stopSessionChecker;
-(HKHTTPSession*)httpSessionForSessionId:(NSString*)sessionId createIfNotExist:(BOOL)flag;
@end

@protocol ActionDelegate <NSObject>
@optional
-(void)setHttpRequestParameters:(NSDictionary*)parameters;
-(void)setHttpRequestURI:(NSString*)uri;
-(void)setHttpSession:(HKHTTPSession*)httpSession;
@end

@interface HKActionMapping : NSObject
@property(nonatomic,strong)id obj;
@property(nonatomic,copy)NSString* methodName;
@end

@interface ActionClassInfo : NSObject
@property(nonatomic,assign) Class cls;
@property(nonatomic,strong) NSMutableDictionary* propTypeEncodingDic;
+(ActionClassInfo*)actionClassInfoWithClass:(Class)cls;
-(id)initWithClass:(Class)cls;
-(BOOL)setPropValueWithObject:(id)obj value:(NSString*)value propName:(NSString *)propName;
@end

@interface HKHTTPConnection : HTTPConnection
@property(nonatomic,copy)NSString* requestMethod;
+(void)addSuffix:(NSString*)suffix;
+(BOOL)hasSuffix:(NSString*)suffix;
+(BOOL)isPathContainSuffix:(NSString*)path;
/*
 uri为不带参数部分
 */
+(void)addMappingWithURI:(NSString*)uri cls:(Class)cls method:(NSString*)method;
@end

@interface HKStatusAction : NSObject
-(NSString*)execute;
@end

@interface HKHTTPServer : HTTPServer
-(BOOL)start;
//-(BOOL)hkStart;
-(void)startCheckStatus;
-(void)stopCheckStatus;
@end
