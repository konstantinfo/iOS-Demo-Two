//
//  DatabaseHandler.h
//  Tempus
//
//  Created by Ashish Sharma on 16/07/14.
//  Copyright (c) 2014 KT. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  A wrapper class that handles all Database related operations
 *  A subclass of NSObject
 */
@interface DatabaseHandler : NSObject

/**
 *  Method to execute any SQL statement on Database
 *
 *  @param sqlStatement SQL to execute
 */
+ (void) executeSQLStatement:(NSString*) sqlStatement;

/**
 *  Insert all events (tasks) in Database
 *
 *  @param events an array of events
 */
+ (void) insertEventsInDatabase:(NSArray*) events;

/**
 *  Method that return srart date of events/agenda
 *
 *  @return start date of events/agenda
 */
+ (double) eventsStartDate;

/**
 *  Method that return end date of events/agenda
 *
 *  @return end date of events/agenda
 */
+ (double) eventsEndDate;

/**
 *  Method that fetch all events (tasks) for a particular date from Database
 *
 *  @param date date for which events need to be fetch
 *
 *  @return an array of events
 */
+ (NSMutableArray*) fetchEventsForDate:(NSDate*) date;

/**
 *  Method that search all events which match with passed keyword in Database
 *
 *  @param keyword search keyword
 *
 *  @return an array of events
 */
+ (NSMutableArray*) searchEventsForKeyword:(NSString*) keyword;

/**
 *  Method that fetch all events related to a particular task from Database
 *
 *  @param taskID id of task which events need to be fetch
 *
 *  @return an array of events
 */
+ (NSMutableArray*) fetchEventsForTask:(int) taskID;

/**
 *  Method that returns end date of task
 *
 *  @param taskID id of task
 *
 *  @return end date of task
 */
+ (double) taskEndDate:(int) taskID;

@end
