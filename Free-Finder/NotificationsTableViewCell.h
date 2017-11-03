//
//  NotificationsTableViewCell.h
//  Free-Finder
//
//  Created by Will Burford on 7/27/15.
//  Copyright (c) 2015 DDD Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class NotificationsTableViewCell;

@protocol NotificationsTableViewCellDelegate <NSObject>
- (void) removeHangout:(PFObject*)hangoutToDelete;
- (void) respondToHangout:(PFObject*)hangoutToAccept;
@end

@interface NotificationsTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString* notificationString;
@property (strong, nonatomic) NSString* localTimeString;
@property (strong, nonatomic) PFObject* hangout;
@property (weak, nonatomic) id<NotificationsTableViewCellDelegate> buttonDelegate;
@property BOOL processingButtonPress;

@end
