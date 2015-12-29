//
//  MyGoodViewController.m
//  jikoman
//
//  Created by HIroki Taniguti on 2015/11/20.
//  Copyright © 2015年 HIroki Taniguti. All rights reserved.
//

#import "MyGoodViewController.h"
#import <MBCalendarKit/NSCalendarCategories.h>
#import <MBCalendarKit/NSDate+Components.h>
#import <MBCalendarKit/CalendarKit.h>

@interface MyGoodViewController ()<CKCalendarViewDelegate, CKCalendarViewDataSource>

//なんでstrongなのか？
@property (strong, nonatomic) NSMutableDictionary*data;
@property (weak, nonatomic) IBOutlet UIView *myColendarView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedCtr;


@end

@implementation MyGoodViewController

- (IBAction)unwindtoSubmit:(UIStoryboardSegue*)segue
{
    NSLog(@"MyGoodView retun action");
}



- (void)viewDidLoad {
     [super viewDidLoad];
    
    //CKcalendar作成,表示
    CKCalendarView *calendar = [CKCalendarView new];
    [calendar setDelegate:self];
    [calendar setDataSource:self];
    [[self myColendarView] addSubview:calendar];
    
    
    self.data = [[NSMutableDictionary alloc]init];
    UIColor *red = [UIColor redColor];
    
    
    
    // 2. Create some events.
    
    //  An event for the new MBCalendarKit release.
    NSString *title = NSLocalizedString(@"Release MBCalendarKit 2.2.4", @"");
    NSDate *date = [NSDate dateWithDay:10 month:12 year:2015];
    CKCalendarEvent *releaseUpdatedCalendarKit = [CKCalendarEvent eventWithTitle:title
                                                                         andDate:date
                                                                         andInfo:nil];
    
    //  An event for the new Hunger Games movie.
    NSString *title2 = NSLocalizedString(@"The Hunger Games: Mockingjay, Part 1", @"");
    NSDate *date2 = [NSDate dateWithDay:11 month:12 year:2015];
    CKCalendarEvent *mockingJay = [CKCalendarEvent eventWithTitle:title2
                                                          andDate:date2
                                                          andInfo:nil];
    
    //  Integrate MBCalendarKit
    NSString *integrationTitle = NSLocalizedString(@"Integrate MBCalendarKit", @"");
    NSDate *integrationDate = date2;
    CKCalendarEvent *integrationEvent = [CKCalendarEvent eventWithTitle:integrationTitle
                                                                andDate:integrationDate
                                                                andInfo:nil];
    
    //  An event for the new MBCalendarKit release.
    NSString *title3 = NSLocalizedString(@"Fix bug where events don't show up immediately.", @"");
    NSDate *date3 = [NSDate dateWithDay:12 month:12 year:2015];
    CKCalendarEvent *fixBug = [CKCalendarEvent eventWithTitle:title3
                                                      andDate:date3
                                                      andInfo:nil];

    
    NSString *title4 = NSLocalizedString(@"おなかすいた", @"");
    NSDate *date4 = [NSDate dateWithDay:15 month:12 year:2015];
    CKCalendarEvent *hangry = [CKCalendarEvent eventWithTitle:title4
                                                      andDate:date4
                                                      andInfo:nil
                                                     andColor:red];
    
    /**
     *  Add the events to the data source.
     *
     *  The key is the date that the array of events appears on.
     */
    
    self.data[date] = @[releaseUpdatedCalendarKit];
    self.data[date2] = @[mockingJay, integrationEvent];
    self.data[date3] = @[fixBug];
    self.data[date4] = @[hangry];
    
   
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - CKCalendarViewDataSource

- (NSArray *)calendarView:(CKCalendarView *)calendarView eventsForDate:(NSDate *)date
{
    return [self data][date];
}

#pragma mark - CKCalendarViewDelegate
// Called before/after the selected date changes
- (void)calendarView:(CKCalendarView *)CalendarView willSelectDate:(NSDate *)date
{
    
}

- (void)calendarView:(CKCalendarView *)CalendarView didSelectDate:(NSDate *)date
{
    
}

//  A row is selected in the events table. (Use to push a detail view or whatever.)
- (void)calendarView:(CKCalendarView *)CalendarView didSelectEvent:(CKCalendarEvent *)event
{
    
}

@end
