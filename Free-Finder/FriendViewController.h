//
//  FriendViewController.h
//  Free-Finder
//
//  Created by Will Burford on 4/10/15.
//  Copyright (c) 2015 DDD Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SettingsViewController.h"
#import "FriendPeriodViewController.h"
#import "FriendTableViewCell.h"
#import "LoadingIndicatorView.h"

@interface FriendViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, assign) FBSDKProfilePictureView* pictureMode;
@property (nonatomic, copy) NSString *profileID;
@property NSDictionary *activeUser;


@end
