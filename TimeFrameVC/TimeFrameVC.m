//
//  TimeFrameVC.m
//  Tempus
//
//  Created by Ashish Sharma on 22/07/14.
//  Copyright (c) 2014 KT. All rights reserved.
//

#import "TimeFrameVC.h"
#import "CreateEditTaskVC.h"

@interface TimeFrameVC ()
{
    int selectedTab;
}

/**
 *  scroll view that holds all content, calendar and time picker
 */
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

/**
 *  button that enables from date selection
 */
@property (nonatomic, strong) IBOutlet UIButton *fromDateButton;

/**
 *  button that enables to date selection
 */
@property (nonatomic, strong) IBOutlet UIButton *toDateButton;

/**
 *  label that shows selected month
 */
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;

/**
 *  switch to choose b/w all day event or particular event
 */
@property (nonatomic, strong) IBOutlet UISwitch *allDayOnOffSwitch;

/**
 *  view that holds allDayOnOffSwitch and it's heading label
 */
@property (nonatomic, strong) IBOutlet UIView *allDayHeadingView;

/**
 *  view that holds timePicker
 */
@property (nonatomic, strong) IBOutlet UIView *pickerHolderView;

/**
 *  date picker to select time
 */
@property (nonatomic, strong) IBOutlet UIDatePicker *timePicker;

/**
 *  custom calendar view
 */
@property (nonatomic, strong) CKCalendarView *calendar;

/**
 *  IBAction to handle event of next month button tap
 *  Changes month of calendar to next
 *  @param sender ref of caller
 */
- (IBAction) nextMonthButtonTap:(id)sender;

/**
 *  IBAction to handle event of previous month button tap
 *  Changes month of calendar to previous
 *  @param sender ref of caller
 */
- (IBAction) previousMonthButtonTap:(id)sender;

/**
 *  IBAction to handle event of all day on/off switch value changed
 *  Show/Hides time picker
 *  @param sender ref of caller
 */
- (IBAction) allDayOnOffSwitchValueChanged:(id)sender;

/**
 *  IBAction to handle event of header tabs from/to
 *  Changes date picking type from or to
 *  @param sender ref of caller
 */
- (IBAction) headerTabsTap:(id)sender;

/**
 *  Method that customize navigation bar items
 */
- (void) setNavigationItemInNavigationBar;

/**
 *  Methods that handles event of back button in navigation bar
 *  Pops view
 *  @param sender ref of caller
 */
- (void) backBtnTap:(id) sender;

/**
 *  Methods that handles event of done button in navigation bar
 *  Saves selected time frame and pops view
 *  @param sender instance of caller
 */
- (void) doneBtnTap:(id) sender;

/**
 *  Method that initializes and setup calendar
 */
- (void) setupCalendar;

/**
 *  Method that creates a new date by adding selected date from calendar and selected time
 *
 *  @param calendarDate selected date in calendar
 *  @param pickerDate   selected date in timePicker
 *
 *  @return new date by adding selected date from calendar and selected time
 */
- (NSDate*) getDateByMergingCalendarDate:(NSDate*) calendarDate andTimePickerDate:(NSDate*) pickerDate;

@end

@implementation TimeFrameVC

#pragma mark - Super Class Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //customize navigation bar items
    [self setNavigationItemInNavigationBar];
    
    //initialize and setup calendar view
    [self setupCalendar];
    
    //set default selected tab to 0
    selectedTab = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction) nextMonthButtonTap:(id)sender
{
    [self.calendar _moveCalendarToNextMonth];
}

- (IBAction) previousMonthButtonTap:(id)sender
{
    [self.calendar _moveCalendarToPreviousMonth];
}

- (IBAction) allDayOnOffSwitchValueChanged:(id)sender
{
    if ([self.allDayOnOffSwitch isOn])
    {
        [self.pickerHolderView setHidden:YES];
        [self.scrollView setContentSize:CGSizeMake(320.f, 237.f+self.calendar.frame.size.height)];
    }
    else
    {
        [self.pickerHolderView setHidden:NO];
        [self.scrollView setContentSize:CGSizeMake(320.f, 399.f+self.calendar.frame.size.height)];
    }
}

- (IBAction) headerTabsTap:(id)sender
{
    UIButton *button = (UIButton*) sender;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if (![self.allDayOnOffSwitch isOn])
    {
        if (selectedTab == 0)
            self.fromDate = [self getDateByMergingCalendarDate:self.fromDate andTimePickerDate:self.timePicker.date];
        else
            self.toDate = [self getDateByMergingCalendarDate:self.toDate andTimePickerDate:self.timePicker.date];
    }
    
    switch (button.tag)
    {
        case 0:
        {
            selectedTab = 0;
            
            [self.calendar setDatePickerTpe:kDatePickerTypeStartDate];
            
            [self.toDateButton setTitleColor:UIColorFromRedGreenBlue(120.f, 120.f, 120.f) forState:UIControlStateNormal];
            [self.toDateButton setBackgroundImage:[UIImage imageNamed:@"time_frame_right_but"] forState:UIControlStateNormal];
            
            [button setBackgroundImage:[UIImage imageNamed:@"time_frame_left_but_active"] forState:UIControlStateNormal];
            
            //[self.calendar reloadData];
            
            if (self.fromDate != nil)
            {
                NSCalendar *calendar = [NSCalendar currentCalendar];
                [calendar setTimeZone:[NSTimeZone systemTimeZone]];
                NSDateComponents *dateComponents = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:self.fromDate];
                NSInteger theDay = [dateComponents day];
                NSInteger theMonth = [dateComponents month];
                NSInteger theYear = [dateComponents year];
                
                NSDateComponents *components = [[NSDateComponents alloc] init];
                [components setDay:theDay];
                [components setMonth:theMonth];
                [components setYear:theYear];
                
                [self.calendar selectDate:[calendar dateFromComponents:components] makeVisible:YES];
            
                dateComponents = [calendar components:(NSHourCalendarUnit) fromDate:self.fromDate];
                
                NSInteger theHour = [dateComponents hour];
                
                if (theHour != 0)
                {
                    [self.allDayOnOffSwitch setOn:NO];
                    
                    [self.timePicker setDate:self.fromDate];
                }
                else
                {
                    [self.allDayOnOffSwitch setOn:YES];
                }
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en-US"]];
                [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
                [dateFormatter setDateFormat:@"MMMM yyyy"];
                self.dateLabel.text = [dateFormatter stringFromDate:self.fromDate];
            }
            else
                [self.allDayOnOffSwitch setOn:YES];
            
            [self allDayOnOffSwitchValueChanged:self.allDayOnOffSwitch];
        }
            break;
        case 1:
        {
            selectedTab = 1;
            
            [self.calendar setDatePickerTpe:kDatePickerTypeEndDate];
            
            [self.fromDateButton setTitleColor:UIColorFromRedGreenBlue(120.f, 120.f, 120.f) forState:UIControlStateNormal];
            [self.fromDateButton setBackgroundImage:[UIImage imageNamed:@"time_frame_left_but"] forState:UIControlStateNormal];
            
            [button setBackgroundImage:[UIImage imageNamed:@"time_frame_right_but_active"] forState:UIControlStateNormal];
            
            //[self.calendar reloadData];
            
            if (self.toDate != nil)
            {
                NSCalendar *calendar = [NSCalendar currentCalendar];
                [calendar setTimeZone:[NSTimeZone systemTimeZone]];
                NSDateComponents *dateComponents = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:self.toDate];
                NSInteger theDay = [dateComponents day];
                NSInteger theMonth = [dateComponents month];
                NSInteger theYear = [dateComponents year];
                
                NSDateComponents *components = [[NSDateComponents alloc] init];
                [components setDay:theDay];
                [components setMonth:theMonth];
                [components setYear:theYear];
                
                [self.calendar selectDate:[calendar dateFromComponents:components] makeVisible:YES];
                
                dateComponents = [calendar components:(NSHourCalendarUnit) fromDate:self.toDate];
                
                NSInteger theHour = [dateComponents hour];
                
                if (theHour != 0)
                {
                    [self.allDayOnOffSwitch setOn:NO];
                    
                    [self.timePicker setDate:self.toDate];
                }
                else
                {
                    [self.allDayOnOffSwitch setOn:YES];
                }
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en-US"]];
                [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
                [dateFormatter setDateFormat:@"MMMM yyyy"];
                self.dateLabel.text = [dateFormatter stringFromDate:self.toDate];
            }
            else
                [self.allDayOnOffSwitch setOn:YES];
            
            [self allDayOnOffSwitchValueChanged:self.allDayOnOffSwitch];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Instance Method

- (void) setNavigationItemInNavigationBar
{
    [CommonFunctions setNavigationTitle:@"Time Frame" ForNavigationItem:self.navigationItem];
    
    UIButton *leftBtn = [[UIButton alloc]  initWithFrame:CGRectMake(0.f, 0.f, 53.f, 21.f)];
    [leftBtn setBackgroundColor:[UIColor clearColor]];
    [leftBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 40.f, 20.f)];
    [doneBtn setBackgroundColor:[UIColor clearColor]];
    [[doneBtn titleLabel] setFont:[UIFont fontWithName:@"Arial" size:15.f]];
    [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
    [doneBtn setTitleColor:UIColorFromRedGreenBlue(255.f, 255.f, 0.f) forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
    
    [self.navigationItem setRightBarButtonItem:rightItem];
}

- (void) backBtnTap:(id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) doneBtnTap:(id) sender
{
    if (![self.allDayOnOffSwitch isOn])
    {
        if (selectedTab == 0)
            self.fromDate = [self getDateByMergingCalendarDate:self.fromDate andTimePickerDate:self.timePicker.date];
        else
            self.toDate = [self getDateByMergingCalendarDate:self.toDate andTimePickerDate:self.timePicker.date];
    }
    
    if (self.fromDate != nil && self.toDate != nil)
    {
        NSArray *viewControllers = self.navigationController.viewControllers;
        
        if ([[viewControllers objectAtIndex:viewControllers.count-2] isKindOfClass:[CreateEditTaskVC class]])
        {
            CreateEditTaskVC *cetvc = (CreateEditTaskVC*) [viewControllers objectAtIndex:viewControllers.count-2];
            
            if (cetvc.fromDate != self.fromDate || cetvc.toDate != self.toDate)
            {
                [cetvc performSelector:@selector(enableDoneButton) withObject:nil afterDelay:0.3f];
            }
            
            cetvc.fromDate = self.fromDate;
            cetvc.toDate = self.toDate;
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) setupCalendar
{
    self.calendar = [[CKCalendarView alloc] initWithStartDay:startSunday];
    self.calendar.delegate = self;
    
    self.calendar.onlyShowCurrentMonth = NO;
    self.calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    
    if (self.fromDate != nil)
    {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        [calendar setTimeZone:[NSTimeZone systemTimeZone]];
        NSDateComponents *dateComponents = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:self.fromDate];
        NSInteger theDay = [dateComponents day];
        NSInteger theMonth = [dateComponents month];
        NSInteger theYear = [dateComponents year];
        
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setDay:theDay];
        [components setMonth:theMonth];
        [components setYear:theYear];
        self.calendar.startDate = [calendar dateFromComponents:components];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en-US"]];
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        [dateFormatter setDateFormat:@"MMMM yyyy"];
        self.dateLabel.text = [dateFormatter stringFromDate:self.fromDate];
    }
    else
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en-US"]];
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        [dateFormatter setDateFormat:@"MMMM yyyy"];
        self.dateLabel.text = [dateFormatter stringFromDate:[NSDate date]];
    }
    
    if (self.toDate != nil)
    {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        [calendar setTimeZone:[NSTimeZone systemTimeZone]];
        NSDateComponents *dateComponents = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:self.toDate];
        NSInteger theDay = [dateComponents day];
        NSInteger theMonth = [dateComponents month];
        NSInteger theYear = [dateComponents year];
        
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setDay:theDay];
        [components setMonth:theMonth];
        [components setYear:theYear];
        self.calendar.endDate = [calendar dateFromComponents:components];
    }
    
    self.calendar.frame = CGRectMake(17.f, 65.f, 287.f, 320.f);
    [self.scrollView addSubview:self.calendar];
    
    [self.calendar setDatePickerTpe:kDatePickerTypeStartDate];
        
    [self headerTabsTap:self.fromDateButton];
}

- (NSDate*) getDateByMergingCalendarDate:(NSDate*) calendarDate andTimePickerDate:(NSDate*) pickerDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents *dateComponents = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:calendarDate];
    NSInteger theDay = [dateComponents day];
    NSInteger theMonth = [dateComponents month];
    NSInteger theYear = [dateComponents year];
    
    NSLog(@"day = %ld",(long)theDay);
    NSLog(@"month = %ld",(long)theMonth);
    NSLog(@"year = %ld",(long)theYear);
    
    dateComponents = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:pickerDate];
    
    NSInteger theHour = [dateComponents hour];
    NSInteger theMinute = [dateComponents minute];
    
    NSLog(@"hour = %ld",(long)theHour);
    NSLog(@"min = %ld",(long)theMinute);
    
    dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:theDay];
    [dateComponents setMonth:theMonth];
    [dateComponents setYear:theYear];
    [dateComponents setHour:theHour];
    [dateComponents setMinute:theMinute];
    
    return [calendar dateFromComponents:dateComponents];
}

#pragma mark - CKCalendarDelegate

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
    // TODO: play with the coloring if we want to...
}

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    return YES;
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en-US"]];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"MMMM yyyy"];
    self.dateLabel.text = [dateFormatter stringFromDate:date];
    
    if ([self.allDayOnOffSwitch isOn])
    {
        if (selectedTab == 0)
            self.fromDate = date;
        else
            self.toDate = date;
    }
    else
    {
        if (selectedTab == 0)
            self.fromDate = [self getDateByMergingCalendarDate:date andTimePickerDate:self.timePicker.date];
        else
            self.toDate = [self getDateByMergingCalendarDate:date andTimePickerDate:self.timePicker.date];
    }
    
    if (selectedTab == 0)
    {
        [self headerTabsTap:self.toDateButton];
    }
    else
    {
        [self headerTabsTap:self.fromDateButton];
    }
}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en-US"]];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"MMMM yyyy"];
    self.dateLabel.text = [dateFormatter stringFromDate:date];
    
    return YES;
}

- (void)calendar:(CKCalendarView *)calendar didLayoutInRect:(CGRect)frame
{
    NSLog(@"calendar layout: %@", NSStringFromCGRect(frame));
    
    CGRect rect = self.allDayHeadingView.frame;
    
    rect.origin.y = frame.origin.y+frame.size.height+20.f;
    
    self.allDayHeadingView.frame = rect;
    
    rect = self.pickerHolderView.frame;
    
    rect.origin.y = self.allDayHeadingView.frame.origin.y+self.allDayHeadingView.frame.size.height+7.f;
    
    self.pickerHolderView.frame = rect;
    
    if ([self.allDayOnOffSwitch isOn])
    {
        [self.scrollView setContentSize:CGSizeMake(320.f, 237.f+frame.size.height)];
    }
    else
    {
        [self.scrollView setContentSize:CGSizeMake(320.f, 399.f+frame.size.height)];
    }
}

@end
