//
//  UmbrellaViewController.h
//  Free-Finder
//
//  Created by Will Burford on 7/22/15.
//  Copyright (c) 2015 DDD Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PeriodViewController.h"
#import "SideBarMenuViewController.h"
#import "SettingsViewController.h"
#import "NotificationsTableViewController.h"

@interface UmbrellaViewController : UIViewController

@property int transitionDistance;

-(void)showSideBarMenu;
-(void)hideSideBarMenu:(id)sender;
-(void)switchViewControllerToIndexPath:(NSIndexPath *)indexPath;

@end
