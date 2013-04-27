//
//  HKHTTPServerCtrl.h
//  hkutil2
//
//  Created by akwei on 13-4-26.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKHTTPServer.h"

@interface HKSessionListener : NSObject<HKHTTPSessionListener>

@end

@interface HKTestAction : NSObject
@property(nonatomic,copy)NSString* name;
@property(nonatomic,assign)NSInteger uid;
@end

@interface HKHTTPServerCtrl : UIViewController
- (IBAction)startHttp:(id)sender;
- (IBAction)stopHttp:(id)sender;

@end
