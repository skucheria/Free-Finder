//
//  FriendPeriodViewController.h
//  Free-Finder
//
//  Created by Siddharth Kucheria on 4/22/15.
//  Copyright (c) 2015 DDD Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "FriendPeriodHeaderView.h"
#import "PeriodViewController.h"
#import "LoadingIndicatorView.h"

@interface FriendPeriodViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property PFUser* activeFriend;

@property NSMutableArray* loggedInFreesArray;

@property int dayOfCycle;

-(void)handleSendMessageButton:(id)sender;

@end