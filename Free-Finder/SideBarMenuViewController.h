//
//  SideBarMenuViewController.h
//  Free-Finder
//
//  Created by Will Burford on 7/22/15.
//  Copyright (c) 2015 DDD Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UmbrellaViewController.h"

@interface SideBarMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

-(void)reloadTable;

@end
