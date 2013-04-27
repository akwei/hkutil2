//
//  HKHTTPServerCtrl.m
//  hkutil2
//
//  Created by akwei on 13-4-26.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import "HKHTTPServerCtrl.h"
#import "HKDeviceUtil.h"

@implementation HKSessionListener

-(void)httpSessionListenerOnSessionCreated:(HKHTTPSession *)session{
    NSLog(@"session : %@ created",session.sessionId);
}

-(void)httpSessionListenerOnSessionDestroyed:(HKHTTPSession *)session{
    NSLog(@"session : %@ destroyed",session.sessionId);
}

@end

@implementation HKTestAction

-(NSString*)execute{
    return [[NSString alloc] initWithFormat:@"Hello uid=%lu,name=%@",(long)self.uid,self.name];
}

@end

@interface HKHTTPServerCtrl ()

@end

@implementation HKHTTPServerCtrl{
    HKHTTPServer* _httpServer;
    __unsafe_unretained HKHTTPSessionMgr* _sessionMgr;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _sessionMgr = [HKHTTPSessionMgr shareInstance];
    _sessionMgr.sessionLiveTime = 20;
    _sessionMgr.checkDelayTime = 5;
    _sessionMgr.checkIntervalTime = 10;
    [HKHTTPConnection addSuffix:@".json"];
    [HKHTTPConnection addMappingWithURI:@"/test.json" cls:[HKTestAction class] method:@"execute"];
    HKSessionListener* listener = [[HKSessionListener alloc] init];
    [_sessionMgr addHTTPSessionListener:listener];
    NSLog(@"local ip : %@",[HKDeviceUtil localIp]);
    _httpServer = [[HKHTTPServer alloc] init];
    _httpServer.port = 8080;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startHttp:(id)sender {
    [_httpServer start];
    [_httpServer startCheckStatus];
}

- (IBAction)stopHttp:(id)sender {
    [_httpServer stopCheckStatus];
    [_httpServer stop];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(_httpServer.isRunning){
        [self stopHttp:nil];
    }
}
-(void)dealloc{
    NSLog(@"HKHTTPServerCtrl dealloc");
}
@end
