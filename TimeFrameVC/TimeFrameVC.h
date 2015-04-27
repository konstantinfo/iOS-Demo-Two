//
//  TimeFrameVC.h
//  Tempus
//
//  Created by Ashish Sharma on 22/07/14.
//  Copyright (c) 2014 KT. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CKCalendarView.h"

/**
 *  Controller that shows calendar view to select time frame
 *  A sub class of UIViewController
 *  Confirms to CKCalendarDelegate Protocol
 */
@interface TimeFrameVC : UIViewController <CKCalendarDelegate>

/**
 *  from date of time frame
 */
@property (nonatomic, strong) NSDate *fromDate;

/**
 *  end date of time frame
 */
@property (nonatomic, strong) NSDate *toDate;

@end
