//
//  ResponseTableViewCell.h
//  Free-Finder
//
//  Created by Will Burford on 8/6/15.
//  Copyright (c) 2015 DDD Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class ResponseTableViewCell;

@protocol ResponseTableVieCellDelegate <NSObject>
-(void)removeHangoutResponse:(PFObject*)responseToRemove;
@end

@interface ResponseTableViewCell : UITableViewCell

@property PFObject* response;
@property NSString* localTimeString;
@property (weak, nonatomic) id<ResponseTableVieCellDelegate> buttonDelegate;


@end
