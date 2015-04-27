//
//  TaskEventCell.h
//  Tempus
//
//  Created by Ashish Sharma on 14/07/14.
//  Copyright (c) 2014 KT. All rights reserved.
//

#import <UIKit/UIKit.h>

//
#define HIDE_OPTIONS_VIEW_NOTIFICATION @"hide_options_view_notification"

/**
 *  Cell that shows Tasks Events
 *  A sub class of UITableViewCell
 *  Confirms to UIScrollViewDelegate Protocol
 */
@interface TaskEventCell : UITableViewCell <UIScrollViewDelegate>

/**
 *  label that shows task title
 */
@property (nonatomic, strong) IBOutlet UILabel *eventTitleLabel;

/**
 *  label that shows duration of event
 */
@property (nonatomic, strong) IBOutlet UILabel *eventDurationLabel;

/**
 *  label that shows priority of event
 */
@property (nonatomic, strong) IBOutlet UILabel *eventPriorityLabel;

/**
 *  label that shows end date of event
 */
@property (nonatomic, strong) IBOutlet UILabel *eventToDateLabel;

/**
 *  view that shows tightness of task as strip
 */
@property (nonatomic, strong) IBOutlet UIView *eventTightnessView;

/**
 *  image view to show status of event
 */
@property (nonatomic, strong) IBOutlet UIImageView *eventStatusImageView;

/**
 *  button that starts task
 */
@property (nonatomic, strong) IBOutlet UIButton *doNowButton;

/**
 *  button that re-schedule task
 */
@property (nonatomic, strong) IBOutlet UIButton *reSkedButton;

/**
 *  button that mark task as complete
 */
@property (nonatomic, strong) IBOutlet UIButton *markCompleteButton;

/**
 *  buttom that opens edit view from task
 */
@property (nonatomic, strong) IBOutlet UIButton *editButton;

/**
 *  Method that sets title of task and also reset frame of @taskTitleLabel according to required height
 *
 *  @param taskTitle title of task
 */
- (void) setTaskTitle:(NSString*) taskTitle;

@end
