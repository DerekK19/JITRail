//
//  ViewController.m
//  JITRail
//
//  Created by Derek Knight on 30/10/14.
//  Copyright (c) 2014 Derek Knight. All rights reserved.
//

#import <SVProgressHUD.h>
#import <AFNetworking.h>

#import "ViewController.h"
#import "BoardTableViewCell.h"

@interface ViewController ()
{
    NSArray *_stations;
    NSArray *_movements;
    BOOL _reloading;
    NSInteger _currentStationId;
}

@property (weak, nonatomic) IBOutlet UITableView *displayBoard;
@property (weak, nonatomic) IBOutlet UIPickerView *stationPicker;
@property (nonatomic) EGORefreshTableHeaderView *refreshHeaderView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _stations = @[
                  @{ @"id" : @105, @"name" : @"Avondale", @"lat" : @-36.897141, @"long" : @174.69913 },
                  @{ @"id" : @119, @"name" : @"Baldwin Ave", @"lat" : @-36.877693, @"long" : @174.72046 },
                  @{ @"id" : @133, @"name" : @"Britomart", @"lat" : @-36.844263, @"long" : @174.76804 },
                  @{ @"id" : @112, @"name" : @"Ellerslie", @"lat" : @-36.898697, @"long" : @174.80836 },
                  @{ @"id" : @123, @"name" : @"Fruitvale Rd", @"lat" : @-36.910679, @"long" : @174.66706 },
                  @{ @"id" : @124, @"name" : @"Glen Eden", @"lat" : @-36.910274, @"long" : @174.65317 },
                  @{ @"id" : @103, @"name" : @"Glen Innes", @"lat" : @-36.878801, @"long" : @174.85412 },
                  @{ @"id" : @277, @"name" : @"Grafton", @"lat" : @-36.865612, @"long" : @174.76984 },
                  @{ @"id" : @113, @"name" : @"Greenlane", @"lat" : @-36.889642, @"long" : @174.79743 },
                  @{ @"id" : @125, @"name" : @"Henderson", @"lat" : @-36.880965, @"long" : @174.63091 },
                  @{ @"id" : @99, @"name" : @"Homai", @"lat" : @-37.013464, @"long" : @174.87467 },
                  @{ @"id" : @122, @"name" : @"Kingsland", @"lat" : @-36.872508, @"long" : @174.74453 },
                  @{ @"id" : @9218, @"name" : @"Manukau", @"lat" : @-36.993894, @"long" : @174.87738 },
                  @{ @"id" : @98, @"name" : @"Manurewa", @"lat" : @-37.023265, @"long" : @174.89618 },
                  @{ @"id" : @117, @"name" : @"Meadowbank", @"lat" : @-36.86632, @"long" : @174.82075 },
                  @{ @"id" : @109, @"name" : @"Middlemore", @"lat" : @-36.963, @"long" : @174.83904 },
                  @{ @"id" : @104, @"name" : @"Morningside", @"lat" : @-36.874985, @"long" : @174.73521 },
                  @{ @"id" : @120, @"name" : @"Mt Albert", @"lat" : @-36.884789, @"long" : @174.71411 },
                  @{ @"id" : @118, @"name" : @"Mt Eden", @"lat" : @-36.86799, @"long" : @174.75898 },
                  @{ @"id" : @129, @"name" : @"New Lynn", @"lat" : @-36.909403, @"long" : @174.68406 },
                  @{ @"id" : @115, @"name" : @"Newmarket", @"lat" : @-36.869111, @"long" : @174.77903 },
                  @{ @"id" : @605, @"name" : @"Onehunga", @"lat" : @-36.925942, @"long" : @174.78636 },
                  @{ @"id" : @116, @"name" : @"Orakei", @"lat" : @-36.862427, @"long" : @174.8095 },
                  @{ @"id" : @101, @"name" : @"Otahuhu", @"lat" : @-36.947225, @"long" : @174.83331 },
                  @{ @"id" : @130, @"name" : @"Panmure", @"lat" : @-36.898108, @"long" : @174.84934 },
                  @{ @"id" : @97, @"name" : @"Papakura", @"lat" : @-37.064254, @"long" : @174.94618 },
                  @{ @"id" : @100, @"name" : @"Papatoetoe", @"lat" : @-36.977596, @"long" : @174.84936 },
                  @{ @"id" : @102, @"name" : @"Penrose", @"lat" : @-36.910414, @"long" : @174.81586 },
                  @{ @"id" : @607, @"name" : @"Penrose Platform 3", @"lat" : @-36.911088, @"long" : @174.81546 },
                  @{ @"id" : @134, @"name" : @"Pukekohe", @"lat" : @-37.203266, @"long" : @174.91023 },
                  @{ @"id" : @108, @"name" : @"Puhinui", @"lat" : @-36.989756, @"long" : @174.85608 },
                  @{ @"id" : @128, @"name" : @"Ranui", @"lat" : @-36.867974, @"long" : @174.60333 },
                  @{ @"id" : @114, @"name" : @"Remuera", @"lat" : @-36.881751, @"long" : @174.78586 },
                  @{ @"id" : @126, @"name" : @"Sturges Rd", @"lat" : @-36.873513, @"long" : @174.6208 },
                  @{ @"id" : @121, @"name" : @"Sunnyvale", @"lat" : @-36.896867, @"long" : @174.6319 },
                  @{ @"id" : @127, @"name" : @"Swanson", @"lat" : @-36.866274, @"long" : @174.57664 },
                  @{ @"id" : @244, @"name" : @"Sylvia Park", @"lat" : @-36.914637, @"long" : @174.8426 },
                  @{ @"id" : @106, @"name" : @"Takanini", @"lat" : @-37.041125, @"long" : @174.91945 },
                  @{ @"id" : @107, @"name" : @"Te Mahia", @"lat" : @-37.031166, @"long" : @174.90611 },
                  @{ @"id" : @606, @"name" : @"Te Papapa", @"lat" : @-36.920166, @"long" : @174.80141 },
                  @{ @"id" : @577, @"name" : @"Waimauku", @"lat" : @-36.763719, @"long" : @174.49247 },
                  @{ @"id" : @132, @"name" : @"Waitakere", @"lat" : @-36.849166, @"long" : @174.54376 },
                  @{ @"id" : @111, @"name" : @"Westfield", @"lat" : @-36.936834, @"long" : @174.83164 },
                  ];
    
    _movements = @[];
    
    [_stationPicker selectRow:7
                  inComponent:0
                     animated:YES];
    [self pickerView:_stationPicker
        didSelectRow:7
         inComponent:0];
    
    if (_refreshHeaderView == nil) {
        
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - _displayBoard.bounds.size.height, _displayBoard.bounds.size.width, _displayBoard.bounds.size.height)];
        view.delegate = self;
        [_displayBoard addSubview:view];
        _refreshHeaderView = view;
    }
    
    //  update the last update date
    [_refreshHeaderView refreshLastUpdatedDate];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self reloadView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadView
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    [SVProgressHUD showWithStatus:@"Reloading"
                         maskType:SVProgressHUDMaskTypeGradient];
    
    NSString *url = [NSString stringWithFormat:@"http://api.maxx.co.nz/RealTime/v2/Departures/Stop/%d", _currentStationId];
    
    _reloading = YES;
    _movements = @[];
    [_displayBoard reloadData];
    [manager GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         NSDictionary *data = (NSDictionary *)responseObject;
         _movements = data[@"Movements"];
         if (_movements == (NSArray *)[NSNull null]) _movements = @[];
         [_displayBoard reloadData];
         [SVProgressHUD dismiss];
         _reloading = NO;
         NSLog(@"JSON: %@", _movements);
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@\n%@", error, operation);
         [SVProgressHUD dismiss];
         _reloading = NO;
     }];
    
}

- (NSDate *)dateFromJSONDate:(NSString *)json {
    if (!json || (NSNull *)json == [NSNull null]) return nil;
    NSString *strDate = [[json stringByReplacingOccurrencesOfString:@"/Date("
                                                         withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""];
    if (strDate.length == 0) return nil;
    double milliseconds = [strDate doubleValue];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:milliseconds / 1000];
    
    return date;
}

#pragma mark - EGO Table Pull Refresh delegate

- (void)reloadTableViewDataSource
{
    _reloading = YES;
    [self reloadView];
}

- (void)doneLoadingTableViewData
{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_displayBoard];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self reloadTableViewDataSource];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return [NSDate date]; // should return date data source was last changed
}

#pragma mark - TableViewDtaSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return _movements ? _movements.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BoardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"boardCell"
                                                               forIndexPath:indexPath];
    NSDictionary *movement = [_movements objectAtIndex:indexPath.row];
    NSDate *expected = [self dateFromJSONDate:movement[@"ExpectedArrivalTime"]];
    NSDate *due = [self dateFromJSONDate:movement[@"ActualArrivalTime"]];
    if (expected == nil && due == nil)
    {
        expected = [self dateFromJSONDate:movement[@"ExpectedDepartureTime"]];
        due = [self dateFromJSONDate:movement[@"ActualDepartureTime"]];
    }
    if (expected == nil) expected = due;
    NSDate *stamp = [self dateFromJSONDate:movement[@"TimeStamp"]];
    if (stamp == nil) stamp = [NSDate date];
    [cell setDueTime:due
        expectedTime:[NSDate dateWithTimeIntervalSince1970:[expected timeIntervalSinceDate:stamp]]
         destination:movement[@"DestinationDisplay"]];
    
    return cell;
}

#pragma mark - Picker view data source

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return _stations.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row
           forComponent:(NSInteger)component
{
    return _stations[row][@"name"];
}

// Capture the picker view selection
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    _currentStationId = [_stations[row][@"id"] integerValue];
    [self reloadView];
}
@end
