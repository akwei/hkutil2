//
//  DeviceUtil.h
//  myutil
//
//  Created by 伟 袁 on 12-7-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDeviceScreenHeight [UIScreen mainScreen].bounds.size.height
#define kDeviceScreenWidth [UIScreen mainScreen].bounds.size.width

@interface DeviceUtil : NSObject

+(NSString*)localIp;

+(CGSize)deviceSize;

@end
