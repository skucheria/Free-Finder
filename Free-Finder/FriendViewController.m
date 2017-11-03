//
//  FriendViewController.m
//  Free-Finder
//
//  Created by Will Burford on 4/10/15.
//  Copyright (c) 2015 DDD Development. All rights reserved.
//

#import "FriendViewController.h"

@interface FriendViewController ()

@property NSArray *userFriends;

@property NSMutableArray* freesArray;

@property int dayOfCycleUS;

@property UISegmentedControl* friendType;

@property UIActivityIndicatorView* loadingIndicator;

@property UIView* loadingBorder;




@end

@implementation FriendViewController{
    NSArray *sectionTitles;
    NSMutableDictionary *filteredTableData;


}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.friendType = [[UISegmentedControl alloc]init];
    [self.friendType insertSegmentWithTitle:@"All" atIndex:0 animated:true];
    [self.friendType addTarget:self action:@selector(handleFriendType:) forControlEvents: UIControlEventValueChanged];
    [self.friendType insertSegmentWithTitle:@"Favorites" atIndex:1 animated:true];
    [self.friendType addTarget:self action:@selector(handleFriendType:) forControlEvents: UIControlEventValueChanged];
    self.friendType.selectedSegmentIndex = 0;
    
    [self.friendType setFrame:CGRectMake((self.view.frame.size.width/2)-85, 10, 150, 30)];
    UIView *outerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, self.navigationController.navigationBar.frame.size.height)];
    self.navigationItem.titleView = outerView;
    [outerView addSubview:self.friendType];
    self.navigationItem.titleView = outerView;
    
    self.view.backgroundColor = [UIColor colorWithRed:0.26 green:0.26 blue:0.26 alpha:1.0];
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(handleSettingButton:)];
    settingsButton.tintColor = [UIColor colorWithRed:0.88 green:0.40 blue:0.40 alpha:1.0];
    self.navigationItem.rightBarButtonItem = settingsButton;
    
    LoadingIndicatorView *loadingView = [[LoadingIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 75, 75)];
    [loadingView setCenter:self.navigationController.view.center];
    [loadingView.loadingIndicator startAnimating];
    [self.view addSubview:loadingView];
    
    /*[JFParseFBFriends findFriendsAndUpdate:YES completion:^(BOOL success, BOOL localStore, NSArray *pfusers, NSError *error) {
        
        NSString *last = @"lastname";
        NSString *first = @"firstname";
        NSSortDescriptor *lastDescriptor =
        [[NSSortDescriptor alloc] initWithKey:last
                                    ascending:YES
                                     selector:@selector(localizedCaseInsensitiveCompare:)];
        NSSortDescriptor *firstDescriptor =
        [[NSSortDescriptor alloc] initWithKey:first
                                    ascending:YES
                                     selector:@selector(localizedCaseInsensitiveCompare:)];
        NSArray *descriptors = [NSArray arrayWithObjects:firstDescriptor, lastDescriptor, nil];
        
        _userFriends = [pfusers sortedArrayUsingDescriptors:descriptors];
        
        sectionTitles = [NSArray arrayWithObjects: @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
        
       //NSLog(@"Names? %@", _userFriends);
        
        filteredTableData = [[NSMutableDictionary alloc] init];
        
        
        


        //_friends = [NSDictionary dictionaryWithObjects:_userFriends forKeys:_userFriends];
        
        
        if (!success) {
           //NSLog(@"!success");
        }
        if(self.userFriends==nil){
           //NSLog(@"self.userFriends==nil");
        }
        if (error) {
           //NSLog(@"Error: %@ %@",error,[error userInfo]);
        }
        [self.tableView reloadData];
        
        
        
    }];*/
    
    //NSDate *today = [NSDate dateWithTimeIntervalSinceNow:24*60*60];
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *todayComponents = [gregorian components:(NSCalendarUnitWeekday | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitDay | NSCalendarUnitWeekdayOrdinal) fromDate:today];
    
    
    NSMutableArray *todayKeys = [NSMutableArray array];
    [todayKeys addObject:@"weekday"];
    [todayKeys addObject:@"weekdayOrdial"];
    [todayKeys addObject:@"day"];
    [todayKeys addObject:@"month"];
    [todayKeys addObject:@"year"];
    
    NSMutableArray *todayObjects = [NSMutableArray array];
    [todayObjects addObject:[[NSNumber numberWithLong:[todayComponents weekday]]stringValue]];
    [todayObjects addObject:[[NSNumber numberWithLong:[todayComponents weekdayOrdinal]]stringValue]];
    [todayObjects addObject:[[NSNumber numberWithLong:[todayComponents day]]stringValue]];
    [todayObjects addObject:[[NSNumber numberWithLong:[todayComponents month]]stringValue]];
    [todayObjects addObject:[[NSNumber numberWithLong:[todayComponents year]]stringValue]];
    
    
    NSDictionary *todayComponentsDictionary = [NSDictionary dictionaryWithObjects:todayObjects forKeys:todayKeys];
    
    [PFCloud callFunctionInBackground:@"getDayOfCycleUS" withParameters:todayComponentsDictionary block:^(id object, NSError* error){
        if (!error) {
            NSNumber *day = object;
           //NSLog(@"day = %@",day);
            self.dayOfCycleUS = [day intValue];
        }
        else{
           //NSLog(@"Error in getDayOfCycleUS: %@ %@",error,error.userInfo);
        }
        //[[PFUser currentUser]fetch];
        [loadingView.loadingIndicator stopAnimating];
        [loadingView removeFromSuperview];
    }];
    
    
    
}

- (void) viewWillAppear:(BOOL)animated {
    [self.tableView setRowHeight:80];
    
    [self.navigationController setToolbarHidden:true];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.88 green:0.40 blue:0.40 alpha:1.0];

   //NSLog(@"filteredTableData=%@", filteredTableData);
    
//    UIImageView *bannerLogo = [[UIImageView alloc]initWithFrame:CGRectMake(self.navigationController.navigationBar.frame.size.width/3-25, 5, self.navigationController.navigationBar.frame.size.width/3+40, self.navigationController.navigationBar.frame.size.height-10)];
//    bannerLogo.image = [UIImage imageNamed:@"freefinder final one line.png"];
//    [outerView addSubview:bannerLogo];

    
//    self.navigationItem.titleView = outerView;
    
    
    /*UIView* testView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    testView.backgroundColor = [UIColor orangeColor];
    self.navigationItem.titleView = testView;*/
    
   //NSLog(@"titleView frame = %@",NSStringFromCGRect(self.navigationItem.titleView.frame));
    
    //this was stuff for all and favorites
    /*
    UIBarButtonItem *all = [[UIBarButtonItem alloc] initWithTitle:@"All" style:(UIBarButtonItemStylePlain) target:self action:@selector(handleAllFriendsButton:)];
    NSMutableArray *barButtons = [[NSMutableArray alloc]init];
    UIBarButtonItem *favorites = [[UIBarButtonItem alloc] initWithTitle:@"Favorites" style:(UIBarButtonItemStylePlain) target:self action:@selector(handleAllFriendsButton:)];
    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                               target:nil
                                               action:nil];
    [barButtons addObject:all];
    [barButtons addObject:flexibleSpaceBarButton];

    [barButtons addObject:favorites];
    [self setToolbarItems:barButtons animated:YES];
     */
    
    
   
    //UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    //[self.view addSubview:searchBar];
    /*
    UITabBarController *tabBarContoller = [[UITabBarController alloc] init];
    
    FavoritesViewController *vc1 = [[FavoritesViewController alloc] initWithStyle:UITableViewStylePlain];
    AllFriendsViewController *vc2 = [[AllFriendsViewController alloc] initWithStyle:UITableViewStylePlain];
    
    NSArray *viewsForTabBar = [NSArray arrayWithObjects:vc1, vc2, nil];
    tabBarContoller.viewControllers = viewsForTabBar;
    
    UIImage *anImage = [UIImage imageNamed:@"FFlogo-small.png"];
    
    UITabBarItem *barr = [[UITabBarItem alloc] initWithTitle:@"TAB" image:anImage tag:0];
    
    tabBarContoller.delegate = self;
    
    //OTHER POSSIBLE ALL&FAVORITES SELECTORS:
    
    self.friendType = [[UISegmentedControl alloc]init];
    [self.friendType insertSegmentWithTitle:@"All" atIndex:0 animated:true];
    [self.friendType insertSegmentWithTitle:@"Favorites" atIndex:1 animated:true];
    [self.friendType setFrame:CGRectMake((self.view.frame.size.width/2)-50, 0, 100, 30)];
    [self.view addSubview:self.friendType];
     */
    
}


- (void) handleSettingButton: (id)sender{
    UITableViewController *settingsController = [[SettingsViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:settingsController animated:YES];
     
}


- (void) handleFriendType: (id)sender{
    
    if(self.friendType.selectedSegmentIndex==0){//all
       //NSLog(@"all selected");
    }
    else if(self.friendType.selectedSegmentIndex==1){//favorites
        //PFUser *currentUser = [PFUser currentUser];
       //NSLog(@"currentUser keys: %@",[currentUser allKeys]);
       //NSLog(@"favoriteFriends = %@",[currentUser objectForKey:@"favoriteFriends"]);
       //NSLog(@"favorites selected");
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSString* letter = [sectionTitles objectAtIndex:section];
//    NSArray* arrayForLetter = (NSArray*)[filteredTableData objectForKey:letter];
//    return [arrayForLetter count];
    return [_userFriends count];
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PFUser *friend = [self.userFriends objectAtIndex:indexPath.row];
    FriendPeriodViewController *periodsList = [[FriendPeriodViewController alloc] init];
    [periodsList setActiveFriend:friend];
    [periodsList setDayOfCycle:self.dayOfCycleUS];
   //NSLog(@"in didSelect dayOfCycleUS = %d",self.dayOfCycleUS);
    [self.navigationController pushViewController:periodsList animated:(YES)];

    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"facebookFriend"];
    if (cell == nil) {
        cell = [[FriendTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"facebookFriend"];
    }
    // Configure the cell to display the FB friend
    NSDictionary *friend = [self.userFriends objectAtIndex:indexPath.row];
    
    NSString* letter = [sectionTitles objectAtIndex:indexPath.section];
    NSArray* arrayForLetter = (NSArray*)[filteredTableData objectForKey:letter];
    NSString *item = [arrayForLetter objectAtIndex:indexPath.row];

    cell.textLabel.text = item;

    [cell setName:friend[@"fullname"]];
    
    
    
    //NSLog(@"friend keys: %@",[friend allKeys]);
    NSString *profile_pic = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=100&height=100", friend[@"fbId"]];
    //NSLog(@"url: %@", profile_pic);
    UIImage *picture = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:profile_pic]]];
    [cell setProfilePicture:picture];
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [sectionTitles count];
}



- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    return sectionTitles;
}



- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index {
    return [sectionTitles indexOfObject:title];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [sectionTitles objectAtIndex:section];
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

@end




