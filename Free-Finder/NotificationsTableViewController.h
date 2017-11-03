//
//  NotificationsTableViewController.h
//  Free-Finder
//
//  Created by Will Burford on 7/27/15.
//  Copyright (c) 2015 DDD Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationsTableViewCell.h"
#import "UmbrellaViewController.h"
#import "ResponseTableViewCell.h"

@interface NotificationsTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, NotificationsTableViewCellDelegate,ResponseTableVieCellDelegate>

-(void)removeHangout:(PFObject*)hangoutToDelete;

@end
