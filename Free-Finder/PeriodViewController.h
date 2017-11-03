//
//  PeriodViewController.h
//  Free-Finder
//
//  Created by Will Burford on 7/18/15.
//  Copyright (c) 2015 DDD Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SettingsViewController.h"
#import "FriendPeriodViewController.h"
#import "FriendTableViewCell.h"
#import "LoadingIndicatorView.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface PeriodViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) FBSDKProfilePictureView* pictureMode;
@property (nonatomic, copy) NSString *profileID;
@property NSDictionary *activeUser;

-(void)addFavoriteFriend:(PFUser *)friend;
-(void)removeFavoriteFriend:(PFUser *)friend;

@end
