//
//  HKBaseCtrl.h
//  hkutil2
//
//  Created by akwei on 13-6-13.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKThreadUtil.h"
#import "MBProgressHUD.h"

@interface HKBaseCtrl : UIViewController

@property(nonatomic,unsafe_unretained)MBProgressHUD* hud;
@property(nonatomic,unsafe_unretained)HKThreadUtil* threadUtil;


-(void)showLoadingHUD:(NSString*)msg;
-(void)changeHUDMsg:(NSString*)msg;
-(void)changeHUDMsg:(NSString*)msg mode:(MBProgressHUDMode)mode;
-(void)changeHUDMsgForTextMode:(NSString *)msg;
-(void)changeHUDMsgForTextMode:(NSString *)msg hideDelay:(NSTimeInterval)delay;
-(void)changeHUDMsgForTextMode:(NSString *)msg hideDelay:(NSTimeInterval)delay doBlockAftherHide:(void (^)(void))block;
-(void)changeHUDMsgForLoadingMode:(NSString *)msg;
-(void)showMsgHUD:(NSString*)msg;
-(void)hideHUD;
-(void)hideHUDWithDelay:(NSTimeInterval)delay;


@end
