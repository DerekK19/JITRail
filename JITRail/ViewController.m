//
//  ViewController.m
//  JITRail
//
//  Created by Derek Knight on 30/10/14.
//  Copyright (c) 2014 Derek Knight. All rights reserved.
//

#import <AFNetworking.h>

#import "ViewController.h"
#import "BoardTableViewCell.h"

@interface ViewController ()
{
    NSArray *_movements;
}
@property (weak, nonatomic) IBOutlet UITextField *stopNumberText;
@property (weak, nonatomic) IBOutlet UITableView *displayBoard;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _movements = @[];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)willDoIt:(id)sender {

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    NSString *url = [NSString stringWithFormat:@"http://api.maxx.co.nz/RealTime/v2/Departures/Stop/%@", _stopNumberText.text];

    [manager GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         NSDictionary *data = (NSDictionary *)responseObject;
         _movements = [data objectForKey:@"Movements"];
         [_displayBoard reloadData];
         NSLog(@"JSON: %@", _movements);
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@\n%@", error, operation);
     }];

}

- (NSDate *)dateFromJSONDate:(NSString *)json {
    double milliseconds = [[[json stringByReplacingOccurrencesOfString:@"/Date("
                                                               withString:@""] stringByReplacingOccurrencesOfString:@")/"
                               withString:@""] doubleValue];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:milliseconds / 1000];

    return date;
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
    NSDate *stamp = [self dateFromJSONDate:[movement objectForKey:@"TimeStamp"]];
    [cell setDueTime:due
        expectedTime:[NSDate dateWithTimeIntervalSince1970:[expected timeIntervalSinceDate:stamp]]
         destination:[movement objectForKey:@"DestinationDisplay"]];

    return cell;
}

@end
