//
//  PeriodSelectionViewController.h
//  Free-Finder
//
//  Created by Will Burford on 3/25/15.
//  Copyright (c) 2015 DDD Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "FriendViewController.h"
#import "SettingsViewController.h"

@interface PeriodSelectionViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSString *referer;

@end
