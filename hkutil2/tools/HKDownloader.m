//
//  HKDownloader.m
//  hkutil2
//
//  Created by akwei on 13-4-22.
//  Copyright (c) 2013年 huoku. All rights reserved.
//


#import "HKDownloader.h"

@implementation HKCallbackHandler
@end


//数据下载器
@implementation HKDownloader{
    NSURLConnection* _con;
    BOOL _downloadDone;
}

-(id)init{
    self=[super init];
    if (self) {
        self.data=[[NSMutableData alloc] initWithCapacity:3096];
        self.timeout = 10;
    }
    return self;
}

-(void)start{
    @autoreleasepool {
        _downloadDone = NO;
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:self.timeout];
        _con = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
        [_con scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [_con start];
        do {
            SInt32 result = CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, NO);
            if (result == kCFRunLoopRunStopped || result == kCFRunLoopRunFinished) {
                _downloadDone = YES;
            }
        } while (!_downloadDone);
    }
}

-(void)cancel{
    [_con cancel];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    self.httpResponse = (NSHTTPURLResponse*)response;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.data appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    dispatch_sync(dispatch_get_main_queue(), ^{
        if (self.onErrorBlock) {
            self.onErrorBlock(self,error);
        }
        _downloadDone = YES;
    });
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    dispatch_sync(dispatch_get_main_queue(), ^{
        if (self.onFinishBlock) {
            self.onFinishBlock(self);
        }
        _downloadDone = YES;
    });
}

@end

@implementation HKDownloaderMgr{
    NSMutableDictionary* _downloader_dic;//key:url value:HKDatadownloader
    NSMutableDictionary* _downloader_callbackHandlers_dic;//key:url value:array of callback
    dispatch_queue_t _syncQueue;
    dispatch_queue_t _asyncQueue;
}

-(id)init{
    if (self = [super init]) {
        _downloader_dic = [[NSMutableDictionary alloc] init];
        _downloader_callbackHandlers_dic = [[NSMutableDictionary alloc] init];
        _syncQueue = dispatch_queue_create("HKDataDownloaderMgr_syncQueue", DISPATCH_QUEUE_SERIAL);
        _asyncQueue = dispatch_queue_create("HKDataDownloaderMgr_asyncQueue", DISPATCH_QUEUE_CONCURRENT);
        return self;
    }
    return nil;
}

-(void)dealloc{
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_6_0
    dispatch_release(_syncQueue);
    dispatch_release(_asyncQueue);
#endif
}

-(void)downloadWithUrl:(NSString*)url callbackHandler:(HKCallbackHandler*)callbackHandler timeout:(NSTimeInterval)timeout{
    NSString* _url = [url copy];
    dispatch_sync(_syncQueue, ^{
        NSMutableArray* callbackHandlers = [_downloader_callbackHandlers_dic valueForKey:_url];
        if (!callbackHandlers) {
            callbackHandlers = [[NSMutableArray alloc] init];
            [_downloader_callbackHandlers_dic setValue:callbackHandlers forKey:_url];
        }
        [callbackHandlers addObject:callbackHandler];
        HKDownloader* _downloader = [_downloader_dic valueForKey:_url];
        if (!_downloader) {
            _downloader = [[HKDownloader alloc] init];
            _downloader.url = _url;
            _downloader.timeout = timeout;
            [_downloader setOnFinishBlock:^(HKDownloader *downloader) {
                NSMutableArray* callbackHandlers = [_downloader_callbackHandlers_dic valueForKey:_url];
                if (callbackHandlers) {
                    for (HKCallbackHandler* handler in callbackHandlers) {
                        handler.onFinishBlock(downloader.url,downloader.data,downloader.httpResponse);
                    }
                }
                [self clearWithUrl:downloader.url];
            }];
            [_downloader setOnErrorBlock:^(HKDownloader *downloader, NSError *error) {
                NSMutableArray* callbackHandlers = [_downloader_callbackHandlers_dic valueForKey:_url];
                if (callbackHandlers) {
                    for (HKCallbackHandler* handler in callbackHandlers) {
                        handler.onErrorBlock(downloader.url,error,downloader.httpResponse);
                    }
                }
                [self clearWithUrl:downloader.url];
            }];
            [_downloader_dic setValue:_downloader forKey:_url];
            dispatch_async(_asyncQueue, ^{
                [_downloader start];
            });
        }
    });
}

-(void)clearWithUrl:(NSString*)url{
    [_downloader_callbackHandlers_dic removeObjectForKey:url];
    [_downloader_dic removeObjectForKey:url];
}

@end



