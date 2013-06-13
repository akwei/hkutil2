//
//  HKBaseCtrl.m
//  hkutil2
//
//  Created by akwei on 13-6-13.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import "HKBaseCtrl.h"


@implementation HKBaseCtrl

-(void)viewDidLoad{
    [super viewDidLoad];
    self.threadUtil = [HKThreadUtil shareInstance];
}

-(void)showLoadingHUD:(NSString *)msg{
    
    self.hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText=msg;
}
-(void)showMsgHUD:(NSString *)msg{
    self.hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode=MBProgressHUDModeText;
    self.hud.labelText=msg;
}
-(void)changeHUDMsg:(NSString *)msg{
    if (!self.hud) {
        return;
    }
    self.hud.labelText=msg;
}
-(void)changeHUDMsg:(NSString *)msg mode:(MBProgressHUDMode)mode{
    if (!self.hud) {
        [self showMsgHUD:msg];
        return;
    }
    self.hud.mode=mode;
    self.hud.labelText=msg;
}
-(void)changeHUDMsgForTextMode:(NSString *)msg{
    [self changeHUDMsg:msg mode:MBProgressHUDModeText];
}
-(void)changeHUDMsgForTextMode:(NSString *)msg hideDelay:(NSTimeInterval)delay{
    [self changeHUDMsgForTextMode:msg];
    [self hideHUDWithDelay:delay];
}
-(void)changeHUDMsgForTextMode:(NSString *)msg hideDelay:(NSTimeInterval)delay doBlockAftherHide:(void (^)(void))block{
    [self changeHUDMsgForTextMode:msg];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setValue:block forKey:@"block"];
    [self performSelector:@selector(doHUDAfter:) withObject:dic afterDelay:delay];
}
-(void)changeHUDMsgForLoadingMode:(NSString *)msg{
    [self changeHUDMsg:msg mode:MBProgressHUDModeIndeterminate];
}
-(void)doHUDAfter:(NSDictionary*)dic{
    self.hud.completionBlock = ^{
        void (^block)(void) = [dic valueForKey:@"block"];
        if (block) {
            block();
        }
    };
    [self hideHUD];
}
-(void)hideHUD{
    [self.hud hide:YES];
}
-(void)hideHUDWithDelay:(NSTimeInterval)delay{
    [self.hud hide:YES afterDelay:delay];
}

@end
