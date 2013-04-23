//
//  TimeUtil.m
//  Tuxiazi
//
//  Created by  on 11-8-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "TimeUtil.h"

@implementation TimeInfo

@end

@implementation TimeUtil

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+(NSString *)stringWithDate:(NSDate *)date format:(NSString *)format{
    NSDateFormatter *fmt=[[NSDateFormatter alloc] init];
	[fmt setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+8:00"]];
	[fmt setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
	[fmt setDateFormat:format];
    NSString* v=[fmt stringFromDate:date];
    return v;
}

+(NSString *)stringWithDoubleDate:(double)doubleDate format:(NSString *)format{
    NSDate* date=[[NSDate alloc] initWithTimeIntervalSince1970:doubleDate];
    NSString* value = [TimeUtil stringWithDate:date format:format];
    return value;
}

+(TimeInfo *)timeInfoWithDate:(NSDate *)date{
    NSCalendar* cal=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    NSDateComponents* cps=[cal components:unitFlags fromDate:date];
    if (!cps) {
        return nil;
    }
    TimeInfo* info=[[TimeInfo alloc] init];
    info.year=[cps year];
    info.month=[cps month];
    info.day=[cps day];
    info.hour=[cps hour];
    info.minute=[cps minute];
    info.second=[cps second];
    return info;
}

+(TimeInfo *)timeInfoWithDoubleDate:(double)date{
    NSDate* ndate=[NSDate dateWithTimeIntervalSince1970:date];
    return [self timeInfoWithDate:ndate];
}

+(TimeInfo *)timeInfoWithDoubleDate:(double)date toDoubleDate:(double)toDate{
    NSDate* ndate=[NSDate dateWithTimeIntervalSince1970:date];
    NSDate* nToDate=[NSDate dateWithTimeIntervalSince1970:toDate];
    NSCalendar* cal=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    NSDateComponents* cps=[cal components:unitFlags fromDate:ndate toDate:nToDate options:0];
    if (!cps) {
        return nil;
    }
    TimeInfo* info=[[TimeInfo alloc] init];
    info.year=[cps year];
    info.month=[cps month];
    info.day=[cps day];
    info.hour=[cps hour];
    info.minute=[cps minute];
    info.second=[cps second];
    return info;
}

+(double)nowDoubleDate{
    return [[NSDate date] timeIntervalSince1970];
}

+(double)currentDateTimeStamp{
    NSInteger nowTime = [[NSDate date] timeIntervalSince1970];
    return nowTime - nowTime % (3600 * 24);
}

//+(NSDate*)buildDateWithYear:(NSInteger)year
//                      month:(NSInteger)month
//                       day:(NSInteger)day
//                       hour:(NSInteger)hour
//                     minute:(NSInteger)minute
//                     second:(NSInteger)second{
//
//    NSDate* now = [NSDate date];
//
//
//
//    TimeInfo* info = [TimeUtil timeInfoWithDate:now];
//    NSDateComponents* cmp = [[NSDateComponents alloc] init];
//    if (year < 1) {
//        year = info.year;
//    }
//    if (month < 1) {
//        month = info.month;
//    }
//    if (day < 1) {
//        day = info.day;
//    }
//    if (hour < 0) {
//        hour = info.hour;
//    }
//    if (minute < 0) {
//        minute = info.minute;
//    }
//    if (second < 0) {
//        second = info.second;
//    }
//    cmp.year = year;
//    cmp.month = month;
//    cmp.day = day;
//    cmp.second = second;
//    cmp.hour = hour;
//    cmp.minute = minute;
//    cmp.second = second;
//    NSCalendar* cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    return [cal dateFromComponents:cmp];
//}


@end
