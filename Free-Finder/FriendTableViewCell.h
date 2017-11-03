//
//  FriendTableViewCell.h
//  Free-Finder
//
//  Created by Will Burford on 5/11/15.
//  Copyright (c) 2015 DDD Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString* name;
@property BOOL freeNow;
@property (nonatomic,strong) UIImage* profilePicture;

@end
