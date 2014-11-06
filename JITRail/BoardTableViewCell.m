//
//  ViewCellTableViewCell.m
//  JITRail
//
//  Created by Derek Knight on 30/10/14.
//  Copyright (c) 2014 Derek Knight. All rights reserved.
//

#import "BoardTableViewCell.h"

@implementation BoardTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setDueTime:(NSDate *)due
      expectedTime:(NSDate *)expected
    destination:(NSString*)destination {
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"HH:mm";
    _dueTimeLabel.text = [format stringFromDate:due];
    format.dateFormat = @"m";
    _expectedTimeLabel.text = [format stringFromDate:expected];
    if ([_expectedTimeLabel.text isEqualToString:@"0"]) _expectedTimeLabel.text = @"*";
    if ([destination hasSuffix:@"/N"]) destination = [destination stringByReplacingOccurrencesOfString:@"/N" withString:@" v Newmkt"];
    if ([destination hasSuffix:@"/GI"]) destination = [destination stringByReplacingOccurrencesOfString:@"/GI" withString:@" v G.Innes"];
    _destinationLabel.text = destination;
}

- (void)setSelected:(BOOL)selected
           animated:(BOOL)animated {
    [super setSelected:selected
              animated:animated];

    // Configure the view for the selected state
}

@end
