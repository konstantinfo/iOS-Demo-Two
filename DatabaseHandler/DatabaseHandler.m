//
//  DatabaseHandler.m
//  Tempus
//
//  Created by Ashish Sharma on 16/07/14.
//  Copyright (c) 2014 KT. All rights reserved.
//

#import "DatabaseHandler.h"
#import "Event.h"

@implementation DatabaseHandler

#pragma mark - Class Methods

+ (void) executeSQLStatement:(NSString*) sqlStatement
{
    AppDelegate *appDelegate = [AppDelegate sharedAppDelegate];
    
    BOOL isSuccess=  [appDelegate.database  executeUpdate:sqlStatement];
    if (!isSuccess)
    {
        NSLog(@"query Statement Not Compiled");
    }
}

+ (void) insertEventsInDatabase:(NSArray*) events
{
    if (events)
        [DatabaseHandler executeSQLStatement:@"DELETE FROM events"];
    
    for (NSDictionary *event in events)
    {
        for (NSString *key in [event allKeys])
        {
            
            NSLog(@"%@ - %@",key,[[event objectForKey:key] class]);
        }
        
        NSNumber *taskID = ([self isNotNull:[event objectForKey:@"taskId"]])?[event objectForKey:@"taskId"]:nil;
        
        NSNumber *eventID = ([self isNotNull:[event objectForKey:@"eventId"]])?[event objectForKey:@"eventId"]:nil;
        
        NSNumber *showResked = ([self isNotNull:[event objectForKey:@"showResked"]])?[event objectForKey:@"showResked"]:nil;
        
        NSNumber *status = ([self isNotNull:[event objectForKey:@"status"]])?[event objectForKey:@"status"]:nil;
        
        NSNumber *startTime = ([self isNotNull:[event objectForKey:@"start"]])?[event objectForKey:@"start"]:nil;
        
        NSNumber *startDate = nil;
        
        if (startTime != nil)
        {
            double systemTime = [CommonFunctions getTimeStampInSystemTimeZone:[startTime doubleValue]];
            
            startTime = [NSNumber numberWithDouble:systemTime];
            
            startDate = [NSNumber numberWithDouble:[CommonFunctions getStartDateForStartTime:[startTime doubleValue]]];
        }
        
        NSNumber *endTime = ([self isNotNull:[event objectForKey:@"end"]])?[event objectForKey:@"end"]:nil;
        
        if (endTime != nil)
        {
            double systemTime = [CommonFunctions getTimeStampInSystemTimeZone:[endTime doubleValue]];
            
            endTime = [NSNumber numberWithDouble:systemTime];
        }
        
        NSNumber *dueDate = ([self isNotNull:[event objectForKey:@"taskDueDate"]])?[event objectForKey:@"taskDueDate"]:nil;
        
        if (dueDate != nil)
        {
            double systemTime = [CommonFunctions getTimeStampInSystemTimeZone:[dueDate doubleValue]];
            
            dueDate = [NSNumber numberWithDouble:systemTime];
        }
        
        NSNumber *type = ([self isNotNull:[event objectForKey:@"type"]])?[event objectForKey:@"type"]:nil;
        
        NSNumber *tightness = ([self isNotNull:[event objectForKey:@"tightness"]])?[event objectForKey:@"tightness"]:nil;
        
        NSString *eventTitle = ([self isNotNull:[event objectForKey:@"title"]])?[event objectForKey:@"title"]:@"";
        
        NSString *priority = ([self isNotNull:[event objectForKey:@"priority"]])?[event objectForKey:@"priority"]:@"";
        
        NSString *sqlStatement = [NSString stringWithFormat:@"INSERT INTO events (taskID,eventID,status,startTime,endTime,type,tightness,eventTitle,priority,startDate,dueDate,showResked) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",taskID,eventID,status,startTime,endTime,type,tightness,eventTitle,priority,startDate,dueDate,showResked];
        
        [DatabaseHandler executeSQLStatement:sqlStatement];
    }
}

+ (double) eventsStartDate
{
    double startDate = 0.f;
    
    AppDelegate *appDelegate = [AppDelegate sharedAppDelegate];
    
    NSString *sqlStatement = @"SELECT MIN(startTime) FROM events";
    
    FMResultSet *results = [appDelegate.database executeQuery:sqlStatement];
    
    if ([results next])
    {
        startDate = [results doubleForColumnIndex:0];
    }
    
    return startDate;
}

+ (double) eventsEndDate
{
    double endDate = 0.f;
    
    AppDelegate *appDelegate = [AppDelegate sharedAppDelegate];
    
    NSString *sqlStatement = @"SELECT MAX(endTime) FROM events";
    
    FMResultSet *results = [appDelegate.database executeQuery:sqlStatement];
    
    if ([results next])
    {
        endDate = [results doubleForColumnIndex:0];
    }
    
    return endDate;
}

+ (double) taskEndDate:(int) taskID
{
    double endDate = 0.f;
    
    AppDelegate *appDelegate = [AppDelegate sharedAppDelegate];
    
    NSString *sqlStatement = [NSString stringWithFormat:@"SELECT MAX(endTime) FROM events WHERE taskID='%d'",taskID];
    
    FMResultSet *results = [appDelegate.database executeQuery:sqlStatement];
    
    if ([results next])
    {
        endDate = [results doubleForColumnIndex:0];
    }
    
    return endDate;
}

+ (NSMutableArray*) fetchEventsForDate:(NSDate*) date
{
    NSDate *fromDate  = date;
    
    NSDateComponents *components= [[NSDateComponents alloc] init];
    [components setDay:1];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *toDate= [calendar dateByAddingComponents:components toDate:fromDate options:0];
    
    NSLog(@"------------------------------------------------------------------------");
    NSLog(@"%@",fromDate);
    NSLog(@"%@",toDate);
    
    NSString *sqlStatement = [NSString stringWithFormat:@"SELECT * FROM events WHERE startTime>='%.0f' AND startTime<'%.0f' ORDER BY startTime",[fromDate timeIntervalSince1970],[toDate timeIntervalSince1970]];
    
    NSLog(@"%@",sqlStatement);
    
    NSMutableArray *eventsArray = [[NSMutableArray alloc] init];
    
    AppDelegate *appDelegate = [AppDelegate sharedAppDelegate];
    
    FMResultSet *results = [appDelegate.database executeQuery:sqlStatement];
    
    while ([results next])
    {
        int taskId = [results intForColumnIndex:0];
        int eventId = [results intForColumnIndex:1];
        int status = [results intForColumnIndex:2];
        double startTime = [results doubleForColumnIndex:3];
        double endTime = [results doubleForColumnIndex:4];
        int type = [results intForColumnIndex:5];
        float tightness = [results doubleForColumnIndex:6];
        NSString *eventTitle = [results stringForColumnIndex:7];
        NSString *priority = [results stringForColumnIndex:8];
        double dueDate = [results doubleForColumnIndex:10];
        int showResked = [results intForColumnIndex:11];
        
        Event *event = [Event new];
        event.taskID = [NSNumber numberWithInt:taskId];
        event.eventID = [NSNumber numberWithInt:eventId];
        event.status = [NSNumber numberWithInt:status];
        event.startTime = [NSNumber numberWithDouble:startTime];
        event.endTime = [NSNumber numberWithDouble:endTime];
        event.type = [NSNumber numberWithInt:type];
        event.tightness = [NSNumber numberWithFloat:tightness];
        event.eventTitle = eventTitle;
        event.priority = priority;
        event.taskDueDate = [NSNumber numberWithDouble:dueDate];
        event.showResked = [NSNumber numberWithInt:showResked];
        
        [eventsArray addObject:event];
    }
    
    return eventsArray;
}

+ (NSMutableArray*) searchEventsForKeyword:(NSString*) keyword
{
    NSString *sqlStatement = [NSString stringWithFormat:@"SELECT * FROM events WHERE eventTitle like '%%%@%%'  ORDER BY startDate ASC",keyword];
    
    NSLog(@"%@",sqlStatement);
    
    NSMutableArray *searchArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *eventsArray = [[NSMutableArray alloc] init];
    
    AppDelegate *appDelegate = [AppDelegate sharedAppDelegate];
    
    FMResultSet *results = [appDelegate.database executeQuery:sqlStatement];
    
    double date = 0.f;
    
    while ([results next])
    {
        int taskId = [results intForColumnIndex:0];
        int eventId = [results intForColumnIndex:1];
        int status = [results intForColumnIndex:2];
        double startTime = [results doubleForColumnIndex:3];
        double endTime = [results doubleForColumnIndex:4];
        int type = [results intForColumnIndex:5];
        float tightness = [results doubleForColumnIndex:6];
        NSString *eventTitle = [results stringForColumnIndex:7];
        NSString *priority = [results stringForColumnIndex:8];
        double startDate = [results doubleForColumnIndex:9];
        double dueDate = [results doubleForColumnIndex:10];
        int showResked = [results intForColumnIndex:11];
        
        
        Event *event = [Event new];
        event.taskID = [NSNumber numberWithInt:taskId];
        event.eventID = [NSNumber numberWithInt:eventId];
        event.status = [NSNumber numberWithInt:status];
        event.startTime = [NSNumber numberWithDouble:startTime];
        event.endTime = [NSNumber numberWithDouble:endTime];
        event.type = [NSNumber numberWithInt:type];
        event.tightness = [NSNumber numberWithFloat:tightness];
        event.eventTitle = eventTitle;
        event.priority = priority;
        event.taskDueDate = [NSNumber numberWithDouble:dueDate];
        event.showResked = [NSNumber numberWithInt:showResked];
        
        if (date != 0.f)
        {
            if (date != startDate)
            {
                NSMutableDictionary *searchResult = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:date],@"date",eventsArray,@"events",nil];
                
                date = startDate;

                [searchArray addObject:searchResult];
                
                eventsArray = [[NSMutableArray alloc] init];
            }
        }
        else
            date = startDate;
        
        [eventsArray addObject:event];
    }
    
    if ([eventsArray count] > 0)
    {
        NSMutableDictionary *searchResult = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:date],@"date",eventsArray,@"events",nil];
        
        [searchArray addObject:searchResult];
    }
    
    NSLog(@"%@",searchArray);
    
    return searchArray;
}

+ (NSMutableArray*) fetchEventsForTask:(int) taskID
{
    NSString *sqlStatement = [NSString stringWithFormat:@"SELECT * FROM events WHERE taskID ='%d'  ORDER BY startDate ASC",taskID];
    
    NSLog(@"%@",sqlStatement);
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *eventsArray = [[NSMutableArray alloc] init];
    
    AppDelegate *appDelegate = [AppDelegate sharedAppDelegate];
    
    FMResultSet *results = [appDelegate.database executeQuery:sqlStatement];
    
    double date = 0.f;
    
    while ([results next])
    {
        int taskId = [results intForColumnIndex:0];
        int eventId = [results intForColumnIndex:1];
        int status = [results intForColumnIndex:2];
        double startTime = [results doubleForColumnIndex:3];
        double endTime = [results doubleForColumnIndex:4];
        int type = [results intForColumnIndex:5];
        float tightness = [results doubleForColumnIndex:6];
        NSString *eventTitle = [results stringForColumnIndex:7];
        NSString *priority = [results stringForColumnIndex:8];
        double startDate = [results doubleForColumnIndex:9];
        double dueDate = [results doubleForColumnIndex:10];
        int showResked = [results intForColumnIndex:11];
        
        
        Event *event = [Event new];
        event.taskID = [NSNumber numberWithInt:taskId];
        event.eventID = [NSNumber numberWithInt:eventId];
        event.status = [NSNumber numberWithInt:status];
        event.startTime = [NSNumber numberWithDouble:startTime];
        event.endTime = [NSNumber numberWithDouble:endTime];
        event.type = [NSNumber numberWithInt:type];
        event.tightness = [NSNumber numberWithFloat:tightness];
        event.eventTitle = eventTitle;
        event.priority = priority;
        event.taskDueDate = [NSNumber numberWithDouble:dueDate];
        event.showResked = [NSNumber numberWithInt:showResked];
        
        if (date != 0.f)
        {
            if (date != startDate)
            {
                NSMutableDictionary *searchResult = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:date],@"date",eventsArray,@"events",nil];
                
                date = startDate;
                
                [resultsArray addObject:searchResult];
                
                eventsArray = [[NSMutableArray alloc] init];
            }
        }
        else
            date = startDate;
        
        [eventsArray addObject:event];
    }
    
    if ([eventsArray count] > 0)
    {
        NSMutableDictionary *searchResult = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:date],@"date",eventsArray,@"events",nil];
        
        [resultsArray addObject:searchResult];
    }
    
    NSLog(@"%@",resultsArray);
    
    return resultsArray;
}

@end
