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
    NSArray *_movements;
    BOOL _reloading;
}
@property (weak, nonatomic) IBOutlet UITextField *stopNumberText;
@property (weak, nonatomic) IBOutlet UITableView *displayBoard;
@property (nonatomic) EGORefreshTableHeaderView *refreshHeaderView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _movements = @[];
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

    NSString *url = [NSString stringWithFormat:@"http://api.maxx.co.nz/RealTime/v2/Departures/Stop/%@", _stopNumberText.text];

    _reloading = YES;
    [manager GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         NSDictionary *data = (NSDictionary *)responseObject;
         _movements = [data objectForKey:@"Movements"];
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
    return _movements.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BoardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"boardCell"
                                                               forIndexPath:indexPath];
    NSDictionary *movement = [_movements objectAtIndex:indexPath.row];
    NSDate *expected = [self dateFromJSONDate:[movement objectForKey:@"ExpectedArrivalTime"]];
    NSDate *due = [self dateFromJSONDate:[movement objectForKey:@"ActualArrivalTime"]];
    if (expected == nil) expected = due;
    NSDate *stamp = [self dateFromJSONDate:[movement objectForKey:@"TimeStamp"]];
    if (stamp == nil) stamp = [NSDate date];
    [cell setDueTime:due
        expectedTime:[NSDate dateWithTimeIntervalSince1970:[expected timeIntervalSinceDate:stamp]]
         destination:[movement objectForKey:@"DestinationDisplay"]];

    return cell;
}

@end
