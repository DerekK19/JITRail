//
//  ViewCellTableViewCell.h
//  JITRail
//
//  Created by Derek Knight on 30/10/14.
//  Copyright (c) 2014 Derek Knight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoardTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dueTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *expectedTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;

- (void)setDueTime:(NSDate *)due
      expectedTime:(NSDate *)expected
       destination:(NSString*)destination;

@end
