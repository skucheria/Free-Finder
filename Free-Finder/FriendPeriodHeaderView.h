//
//  FriendPeriodHeaderView.h
//  Free-Finder
//
//  Created by Will Burford on 5/5/15.
//  Copyright (c) 2015 DDD Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "SettingsViewController.h"
#import "FriendPeriodViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface FriendPeriodHeaderView : UIView

@property (nonatomic, strong) PFUser* activeFriend;
@property (nonatomic, assign) FBSDKProfilePictureView* pictureMode;
@property int dayNumber;


@end
