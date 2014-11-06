//
//  ViewController.h
//  JITRail
//
//  Created by Derek Knight on 30/10/14.
//  Copyright (c) 2014 Derek Knight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EGOTableViewPullRefresh/EGORefreshTableHeaderView.h>

@interface ViewController : UIViewController <
UITableViewDataSource,
EGORefreshTableHeaderDelegate,
UITableViewDelegate,
UIPickerViewDataSource,
UIPickerViewDelegate>

@end

