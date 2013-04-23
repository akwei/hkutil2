//
//  TimeUtil.h
//  Tuxiazi
//
//  Created by  on 11-8-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeInfo : NSObject
@property(nonatomic,assign)NSInteger year;
@property(nonatomic,assign)NSInteger month;
@property(nonatomic,assign)NSInteger day;
@property(nonatomic,assign)NSInteger hour;
@property(nonatomic,assign)NSInteger minute;
@property(nonatomic,assign)NSInteger second;

@end

@interface TimeUtil : NSObject

+(NSString*)stringWithDate:(NSDate*)date format:(NSString*)format;

+(NSString*)stringWithDoubleDate:(double)doubleDate format:(NSString*)format;

+(TimeInfo*)timeInfoWithDoubleDate:(double)date;

+(TimeInfo*)timeInfoWithDate:(NSDate*)date;

+(TimeInfo*)timeInfoWithDoubleDate:(double)date toDoubleDate:(double)toDate;

+(double)nowDoubleDate;

+(double)currentDateTimeStamp;


@end
