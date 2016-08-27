//
//  NSDate+Calendar.m
//  QuizUp
//
//  Created by Normal on 16/5/9.
//  Copyright © 2016年 zhenailab. All rights reserved.
//

#import "NSDate+Calendar.h"
#import <YYCategories.h>

static NSCalendar *kCalendar;

NSCalendar *calendar(){
    if (!kCalendar) {
        kCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        kCalendar.timeZone = [NSTimeZone localTimeZone];
    }
    return kCalendar;
}

@implementation NSDate (Calendar)

+ (NSTimeInterval)secondOfWeek
{
    return 7 * [self secondOfDay];
}

+ (NSTimeInterval)secondOfDay
{
    return 24 * [self secondOfHour];
}

+ (NSTimeInterval)secondOfHour
{
    return 60 * [self secondOfMinute];
}

+ (NSTimeInterval)secondOfMinute
{
    return 60.f;
}

+ (NSString *)localStringOfWeekday:(NSUInteger)weekday
{
    static NSArray *weekdayLocal;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        weekdayLocal = @[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    });
    if (weekday > 7 || weekday == 0) {
        return nil;
    }
    return weekdayLocal[weekday-1];
}

// iOS8 ONLY
- (NSInteger)componentOfUnit:(NSCalendarUnit)unit
{
    return [calendar() component:unit fromDate:self];
}

- (NSInteger)year
{
    if (iOS8) {
        return [self componentOfUnit:NSCalendarUnitYear];
    }
    return [calendar() components:NSCalendarUnitYear fromDate:self].year;
}
- (NSUInteger)month
{
    if (iOS8) {
        return [self componentOfUnit:NSCalendarUnitMonth];
    }
    return [calendar() components:NSCalendarUnitMonth fromDate:self].month;
}
- (NSUInteger)day
{
    if (iOS8) {
        return [self componentOfUnit:NSCalendarUnitDay];
    }
    return [calendar() components:NSCalendarUnitDay fromDate:self].day;
}
- (NSUInteger)hour
{
    if (iOS8) {
        return [self componentOfUnit:NSCalendarUnitHour];
    }
    return [calendar() components:NSCalendarUnitHour fromDate:self].hour;
}
- (NSUInteger)minute
{
    if (iOS8) {
        return [self componentOfUnit:NSCalendarUnitMinute];
    }
    return [calendar() components:NSCalendarUnitMinute fromDate:self].minute;
}
- (NSUInteger)second
{
    if (iOS8) {
        return [self componentOfUnit:NSCalendarUnitSecond];
    }
    return [calendar() components:NSCalendarUnitSecond fromDate:self].second;
}
- (NSUInteger)weekday
{
    if (iOS8) {
        return [self componentOfUnit:NSCalendarUnitWeekday];
    }
    return [calendar() components:NSCalendarUnitWeekday fromDate:self].weekday;
}
- (NSUInteger)weekOfYear
{
    if (iOS8) {
        return [self componentOfUnit:NSCalendarUnitWeekOfYear];
    }
    return [calendar() components:NSCalendarUnitWeekOfYear fromDate:self].weekOfYear;
}
- (NSUInteger)weekOfMonth
{
    if (iOS8) {
        return [self componentOfUnit:NSCalendarUnitWeekOfMonth];
    }
    return [calendar() components:NSCalendarUnitWeekOfMonth fromDate:self].weekOfMonth;
}

- (NSDate *)zeroOclockDate
{
    NSInteger year;
    NSUInteger month,day;
    [self year:&year month:&month day:&day];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = year;
    components.month = month;
    components.day = day;
    components.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSDate *date = [calendar() dateFromComponents:components];
    return date;
}

- (NSDate *)zeroMinuteDate
{
    NSInteger year;
    NSUInteger month,day,hour;
    [self year:&year month:&month day:&day];
    [self hour:&hour minute:NULL second:NULL];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = year;
    components.month = month;
    components.day = day;
    components.hour = hour;
    components.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSDate *date = [calendar() dateFromComponents:components];
    return date;
}

- (void)year:(NSInteger *)year
       month:(NSUInteger *)month
         day:(NSUInteger *)day
{
    NSDateComponents *components = [calendar() components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    if (year != NULL) *year = components.year;
    if (month != NULL) *month = components.month;
    if (day != NULL) *day = components.day;
}

- (void)hour:(NSUInteger *)hour
      minute:(NSUInteger *)minute
      second:(NSUInteger *)second
{
    NSDateComponents *components = [calendar() components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
    if (hour != NULL) *hour = components.hour;
    if (minute != NULL) *minute = components.minute;
    if (second != NULL) *second = components.second;
}

@end

@implementation NSDate (Desc)

- (NSString *)customDescription
{
    NSString *desc;
    NSDate *currentDate = [NSDate date];
    
    NSTimeInterval interval = [currentDate timeIntervalSinceDate:self];
    if (interval < -60.f) {
        desc = @"来自未来";
    }else if ([self isToday]){
        //今天
        CGFloat hours = interval/60/60;
        if (hours < 1.f) {
            desc = @"刚刚";
        }else{
            desc = [NSString stringWithFormat:@"%d小时前",(int)hours];
        }
    }else if([self isYesterday]){
        //昨天
        desc = @"昨天";
    }else{
        desc = [NSString stringWithFormat:@"%ld-%ld",(long)self.month,(long)self.day];
    }
    return desc;
}

@end
