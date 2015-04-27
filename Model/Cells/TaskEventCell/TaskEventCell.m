//
//  TaskEventCell.m
//  Tempus
//
//  Created by Ashish Sharma on 14/07/14.
//  Copyright (c) 2014 KT. All rights reserved.
//

#import "TaskEventCell.h"

#define RIGHT_OPTIONS_VIEW_WIDTH 150.f
#define LEFT_OPTIONS_VIEW_WIDTH 150.f
#define TOP_VIEW_HEIGHT 80.f
#define MIN_LEFT_PANNING 60.f
#define MIN_RIGHT_PANNING 60.f

@interface TaskEventCell ()

/**
 *  view that contains all content of event (main view)
 */
@property (nonatomic, strong) IBOutlet UIView *topView;

/**
 *  view that contains left options (do now and re-sked button)
 */
@property (nonatomic, strong) IBOutlet UIView *leftOptionsView;

/**
 *  view that contains right options (complete and edit button)
 */
@property (nonatomic, strong) IBOutlet UIView *rightOptionsView;

/**
 *  scroll view - added here to implement custom panning view
 */
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

/**
 *  Method that scrollView content offset to zero to hide left/right options view
 */
- (void) hideOptionsView;

@end

@implementation TaskEventCell

@synthesize eventTitleLabel;
@synthesize eventDurationLabel;
@synthesize eventPriorityLabel;
@synthesize eventTightnessView;
@synthesize eventStatusImageView;
@synthesize doNowButton;
@synthesize reSkedButton;
@synthesize markCompleteButton;
@synthesize editButton;
@synthesize eventToDateLabel;

#pragma mark - Super Class Methods

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
    // reset all views
	self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + RIGHT_OPTIONS_VIEW_WIDTH, CGRectGetHeight(self.bounds));
	self.scrollView.frame = CGRectMake(0.f, 0.f, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
	self.rightOptionsView.frame = CGRectMake(CGRectGetWidth(self.bounds) - RIGHT_OPTIONS_VIEW_WIDTH, 0.f, RIGHT_OPTIONS_VIEW_WIDTH, TOP_VIEW_HEIGHT);
    self.leftOptionsView.frame = CGRectMake(0.f, 0.f, LEFT_OPTIONS_VIEW_WIDTH, TOP_VIEW_HEIGHT);
	self.topView.frame = CGRectMake(0.f, 0.f, CGRectGetWidth(self.bounds), TOP_VIEW_HEIGHT);
}

- (void)prepareForReuse
{
	[super prepareForReuse];
    
	[self.scrollView setContentOffset:CGPointZero animated:NO];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	[super setEditing:editing animated:animated];
    
	self.scrollView.scrollEnabled = !self.editing;
    
    // Corrects effect of showing the button labels while selected on editing mode (comment line, build, run, add new items to table, enter edit mode and select an entry)
    self.rightOptionsView.hidden = editing;
    self.leftOptionsView.hidden = editing;
}

#pragma mark - NIB Methods

- (void)awakeFromNib
{
    // Initialization code
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + RIGHT_OPTIONS_VIEW_WIDTH, CGRectGetHeight(self.bounds));
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideOptionsView) name:HIDE_OPTIONS_VIEW_NOTIFICATION object:nil];
}

#pragma mark - Instance Methods

- (void) hideOptionsView
{
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

- (void) setTaskTitle:(NSString*) taskTitle
{
    // find the text width; so that btn width can be calculate
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont fontWithName:@"Arial" size:14.f], NSFontAttributeName,
                                          nil];
    
    CGRect titleRect = [taskTitle boundingRectWithSize:CGSizeMake(222.f, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributesDictionary context:nil];
    
    float height = 16.f;
    
    if (titleRect.size.height > 17.f)
        height = 32.0f;
    
    CGRect rect = self.eventTitleLabel.frame;
    rect.size.height = height;
    self.eventTitleLabel.frame = rect;
    
    [self.eventTitleLabel setNumberOfLines:height/2];
    [self.eventTitleLabel setText:taskTitle];
}

#pragma mark - UIScrollView Delegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{

}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (self.scrollView.contentOffset.x > MIN_RIGHT_PANNING)
    {
		targetContentOffset->x = RIGHT_OPTIONS_VIEW_WIDTH;
	}
    else
    {
        if (scrollView.contentOffset.x < -MIN_LEFT_PANNING)
        {
            self.scrollView.contentInset = UIEdgeInsetsMake(0.f, LEFT_OPTIONS_VIEW_WIDTH, 0.f, 0.f);
            targetContentOffset->x = -LEFT_OPTIONS_VIEW_WIDTH;
        }
        else
        {
            *targetContentOffset = CGPointZero;
            
            // Need to call this subsequently to remove flickering. Strange.
            dispatch_async(dispatch_get_main_queue(), ^{
                [scrollView setContentOffset:CGPointZero animated:YES];
            });
        }
	}
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_OPTIONS_VIEW_NOTIFICATION object:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	self.rightOptionsView.frame = CGRectMake(scrollView.contentOffset.x + (CGRectGetWidth(self.bounds) - RIGHT_OPTIONS_VIEW_WIDTH), 0.0f, RIGHT_OPTIONS_VIEW_WIDTH, TOP_VIEW_HEIGHT);
    self.leftOptionsView.frame = CGRectMake(scrollView.contentOffset.x, 0.0f, LEFT_OPTIONS_VIEW_WIDTH, TOP_VIEW_HEIGHT);
}

@end
