//
//  Event.h
//  Tempus
//
//  Created by Ashish Sharma on 14/07/14.
//  Copyright (c) 2014 KT. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Model Class for Event
 *  A subclass of NSObject
 */
@interface Event : NSObject

/**
 *  task id of event - a task can have multiple event
 */
@property (nonatomic, strong) NSNumber *taskID;

/**
 *  id of event
 */
@property (nonatomic, strong) NSNumber *eventID;

/**
 *  current status of event (possible values - 0,1,2,3,4)
 */
@property (nonatomic, strong) NSNumber *status;

/**
 *  start time of event (in epoc seconds)
 */
@property (nonatomic, strong) NSNumber *startTime;

/**
 *  end time of event (in epoc seconds)
 */
@property (nonatomic, strong) NSNumber *endTime;

/**
 *  type of event (possible values - 0,3)
 */
@property (nonatomic, strong) NSNumber *type;

/**
 *  tightness of event
 */
@property (nonatomic, strong) NSNumber *tightness;

/**
 *  title of event
 */
@property (nonatomic, strong) NSString *eventTitle;

/**
 *  priority of event (possible values - A,B,C,D)
 */
@property (nonatomic, strong) NSString *priority;

@property (nonatomic, strong) NSNumber *taskDueDate;

@property (nonatomic, strong) NSNumber *showResked;


@end
