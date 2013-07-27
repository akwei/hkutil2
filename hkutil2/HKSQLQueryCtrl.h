//
//  HKSQLQueryCtrl.h
//  hkutil2
//
//  Created by akwei on 13-4-27.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKSQLQuery.h"

@interface Person : NSObject
@property(nonatomic,assign)NSUInteger pid;
@property(nonatomic,strong)NSData* data;
@property(nonatomic,copy)NSString* name;
@property(nonatomic,assign)double createtime;

@end

@interface HKSQLQueryCtrl : UIViewController

@end
