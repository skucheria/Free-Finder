//
//  PeriodViewController.m
//  Free-Finder
//
//  Created by Will Burford on 7/18/15.
//  Copyright (c) 2015 DDD Development. All rights reserved.
//

#import "PeriodViewController.h"

@interface PeriodViewController ()

@property UISegmentedControl* friendType;

@property NSArray *userFriends;

@property NSMutableArray *allUserFriendsByPeriod;

@property NSMutableArray *favoriteUserFriendsByPeriod;

@property int dayOfCycleUS;

@property LoadingIndicatorView *loadingView;

@property int finishedLoadingCount;

@end

@implementation PeriodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*UIButton *tempButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [tempButton setFrame:CGRectMake(0, 0, 200, 100)];
    [tempButton setCenter:self.view.center];
    [tempButton setBackgroundColor:[UIColor redColor]];
    [tempButton setTitle:@"DO NOT PRESS" forState:UIControlStateNormal];
    [tempButton addTarget:self.navigationController.parentViewController action:@selector(showSideBarMenu) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:tempButton];*/
    
    [[UIApplication sharedApplication]beginIgnoringInteractionEvents];
    _finishedLoadingCount = 0;
    
    self.friendType = [[UISegmentedControl alloc]init];
    [self.friendType insertSegmentWithTitle:@"All" atIndex:0 animated:true];
    [self.friendType addTarget:self action:@selector(handleFriendType:) forControlEvents: UIControlEventValueChanged];
    [self.friendType insertSegmentWithTitle:@"Favorites" atIndex:1 animated:true];
    [self.friendType addTarget:self action:@selector(handleFriendType:) forControlEvents: UIControlEventValueChanged];
    self.friendType.selectedSegmentIndex = 0;
    
    UIView *outerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 275, self.navigationController.navigationBar.frame.size.height)];
    [self.friendType setFrame:CGRectMake(outerView.frame.size.width/2-75, 8, 150, 28)];
    self.navigationItem.titleView = outerView;
    [outerView addSubview:self.friendType];
    self.navigationItem.titleView = outerView;
    //[outerView setBackgroundColor:[UIColor greenColor]];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.26 green:0.26 blue:0.26 alpha:1.0];
    
    /*UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(handleSettingButton:)];
    settingsButton.tintColor = [UIColor colorWithRed:0.88 green:0.40 blue:0.40 alpha:1.0];
    self.navigationItem.rightBarButtonItem = settingsButton;*/
    
    UIImage *menuImage = [UIImage imageNamed:@"Menu_button_64.png"];//[UIColor colorWithRed:0.88 green:0.40 blue:0.40 alpha:1.0]
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setFrame:CGRectMake(0, 0, 25, 25)];
    [menuButton setBackgroundImage:menuImage forState:UIControlStateNormal];
    [menuButton addTarget:self.navigationController.parentViewController action:@selector(showSideBarMenu) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc]initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem = menuBarButton;
    
    _loadingView = [[LoadingIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 75, 75)];
    [_loadingView setCenter:self.navigationController.view.center];
    [_loadingView.loadingIndicator startAnimating];
    [self.view addSubview:_loadingView];
    
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
        [self finishedLoading];
        
        if (!success) {
           //NSLog(@"!success");
        }
        if(self.userFriends==nil){
           //NSLog(@"self.userFriends==nil");
        }
        if (error) {
           //NSLog(@"Error: %@ %@",error,[error userInfo]);
        }
        
    }];*/
    /*NSMutableArray *objectsArrayParams = [NSMutableArray array];
    NSMutableArray *keysArrayParams = [NSMutableArray array];
    [keysArrayParams addObject:@"owner"];
    [objectsArrayParams addObject:[[PFUser currentUser]objectForKey:@"fbId"]];*/
    //NSMutableDictionary *fields = [NSMutableDictionary dictionary];//[NSMutableDictionary dictionaryWithObjects:objectsArrayParams forKeys:keysArrayParams];
    //NSArray *fields = [NSArray arrayWithObjects:@"id",@"name", nil];
    //NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:fields,@"fields", nil];
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"me/friends"
                                  parameters:NULL
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        NSArray* friendsArray = [NSArray arrayWithArray:[result objectForKey:@"data"]];
        NSMutableArray *facebookIds = [NSMutableArray arrayWithCapacity:friendsArray.count];
        for (int count = 0; count<friendsArray.count; count++) {
            [facebookIds addObject:[friendsArray[count]objectForKey:@"id"]];
        }
        PFQuery* friendsQuery = [PFQuery queryWithClassName:@"_User"];
        [friendsQuery whereKey:@"fbId" containedIn:facebookIds];
        [friendsQuery setLimit:1000];
        [friendsQuery findObjectsInBackgroundWithBlock:^(NSArray* objects, NSError* error){
            if (!error) {
                _userFriends = objects;
                [self finishedLoading];
            }
            else {
               //NSLog(@"error in finding friends %@ %@",error,error.userInfo);
            }
        }];
    }];
    
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
            
            UIView* headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
            UILabel* headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 20)];
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"EEEE, MMMM d"];
            NSString *dayName = [dateFormatter stringFromDate:today];
            [headerLabel setTextAlignment:NSTextAlignmentCenter];
            if (self.dayOfCycleUS>0&&self.dayOfCycleUS<=5) {
                [headerLabel setText:[NSString stringWithFormat:@"%@, Day %d",dayName,self.dayOfCycleUS]];
            }
            else{
                [headerLabel setText:dayName];
            }
            [headerLabel setTextColor:[UIColor whiteColor]];
            [headerLabel setBackgroundColor:[UIColor clearColor]];
            [headerView addSubview:headerLabel];
            self.tableView.tableHeaderView =headerView;
            
            [self finishedLoading];
        }
        else{
           //NSLog(@"Error in getDayOfCycleUS: %@ %@",error,error.userInfo);
        }
    }];
}

-(void)finishedLoading{
    self.finishedLoadingCount++;
   //NSLog(@"loadingCount = %d",self.finishedLoadingCount);
    if (self.finishedLoadingCount==1) {
        return;
    }
    
    _allUserFriendsByPeriod = [NSMutableArray array];
    _favoriteUserFriendsByPeriod = [NSMutableArray array];
    for (int counter = 0; counter<8; counter++) {
        [_allUserFriendsByPeriod addObject:[NSMutableArray array]];
        [_favoriteUserFriendsByPeriod addObject:[NSMutableArray array]];
    }
    
    [_loadingView.loadingIndicator stopAnimating];
    [_loadingView removeFromSuperview];
    if ([[UIApplication sharedApplication]isIgnoringInteractionEvents]) {
        [[UIApplication sharedApplication]endIgnoringInteractionEvents];
    }
   //NSLog(@"stop indicator");
    
    if (self.dayOfCycleUS==0) {
        UIView* noClassView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [noClassView setBackgroundColor:[UIColor colorWithRed:.26 green:.26 blue:.26 alpha:.8]];
        UILabel* noClassLabel = [[UILabel alloc]initWithFrame:CGRectMake(noClassView.frame.size.width/2-100, noClassView.frame.size.height/2-25-22, 200, 50)];
        [noClassLabel setText:@"No Classes Today"];
        [noClassLabel setFont:[UIFont fontWithName:@"Helvetica Bold" size:20]];
        [noClassLabel setTextColor:[UIColor whiteColor]];
        [noClassLabel setTextAlignment:NSTextAlignmentCenter];
        [noClassView addSubview:noClassLabel];
        [self.view addSubview:noClassView];
        [self.tableView setScrollEnabled:false];
    }
    
    for (int counter=0; counter<_userFriends.count; counter++) {
        PFUser *friend = [_userFriends objectAtIndex:counter];
        if ([[friend objectForKey:@"campus"]isEqualToString:@"US"]) {
            int startPoint = 9 * (_dayOfCycleUS - 1);
            NSString *freesForDay = [[friend objectForKey:@"frees"]substringWithRange:NSMakeRange(startPoint, 8)];
            for (int period=0; period<8; period++) {
                if ([freesForDay characterAtIndex:period]=='1') {//free during that period
                    [[_allUserFriendsByPeriod objectAtIndex:period]addObject:friend];
                    if ([[[PFUser currentUser]objectForKey:@"favoriteFriends"]containsObject:[friend objectForKey:@"fullname"]]) {//favorite & free
                        [[_favoriteUserFriendsByPeriod objectAtIndex:period]addObject:friend];
                       //NSLog(@"Found favorite! %@ during period %d",[friend objectForKey:@"fullname"],period+1);
                    }
                }
            }
        }
    }
    
   //NSLog(@"_userFriends = %@",_userFriends);
    
    [self.tableView reloadData];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.88 green:0.40 blue:0.40 alpha:1.0];
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
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *array;
    if (self.friendType.selectedSegmentIndex==0) {
       array = [_allUserFriendsByPeriod objectAtIndex:section];
    }
    else{
       array = [_favoriteUserFriendsByPeriod objectAtIndex:section];
    }
    if (array.count==0) {
        return 1;
    }
    return array.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:true];
    PFUser *friend;
    NSMutableArray *array;
    if (self.friendType.selectedSegmentIndex==0) {
        array = [_allUserFriendsByPeriod objectAtIndex:indexPath.section];
    }
    else{
        array = [_favoriteUserFriendsByPeriod objectAtIndex:indexPath.section];
    }
    if (array.count==0) {
        return;
    }
    friend = [array objectAtIndex:indexPath.row];
    FriendPeriodViewController *periodsList = [[FriendPeriodViewController alloc] init];
    [periodsList setActiveFriend:friend];
    [periodsList setDayOfCycle:self.dayOfCycleUS];
    [self.navigationController pushViewController:periodsList animated:true];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*if ([[[self.tableView indexPathsForVisibleRows]lastObject] isEqual:indexPath]) {
       //NSLog(@"done loading");
    }*/
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"friend"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"friend"];
    }
    [cell setBackgroundColor:[UIColor colorWithRed:.26 green:.26 blue:.26 alpha:1.0]];
    
    NSString *name;
    NSMutableArray *array;
    NSString *noFriendsString;
    if (self.friendType.selectedSegmentIndex==0) {
        array=[_allUserFriendsByPeriod objectAtIndex:indexPath.section];
        noFriendsString = @"friends";
    }
    else{
        array=[_favoriteUserFriendsByPeriod objectAtIndex:indexPath.section];
        noFriendsString = @"favorites";
    }
    
    if (array.count==0) {
        NSString *emojiString = @"😭😢😧😒😕😟😲😵😿";
        int randomNumber = arc4random_uniform(9);
        NSString *singleEmoji = [emojiString substringWithRange:NSMakeRange(randomNumber*2, 2)];
        
        [cell.textLabel setText:[NSString stringWithFormat:@"None of your %@ are free %@",noFriendsString,singleEmoji]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.textLabel setTextColor:[UIColor colorWithRed:0.88 green:0.40 blue:0.40 alpha:1.0]];
        return cell;
    }
    
    name=[[array objectAtIndex:indexPath.row]objectForKey:@"fullname"];
    if ([[[PFUser currentUser]objectForKey:@"favoriteFriends"]containsObject:name]&&self.friendType.selectedSegmentIndex==0) {
        name = [name stringByAppendingString:@" ❤️"];
    }
    [cell.textLabel setText: name];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([[[PFUser currentUser] objectForKey:@"campus"]isEqualToString:@"MS"]) {
        return 9;
    }
    return 8;
}

/*-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat: @"Period %ld",(long)section+1];
}*/

-(void)addFavoriteFriend:(PFUser *)friend{
   //NSLog(@"called addFavoriteFriend");
    if (![[friend objectForKey:@"campus"]isEqualToString:[[PFUser currentUser]objectForKey:@"campus"]]) {
        return;
    }
    int startPoint = 6 * (_dayOfCycleUS - 1);
    int length = 8;
    if ([[friend objectForKey:@"campus"]isEqualToString:@"MS"]) {
        //set startpoint to whatever day of cycle it is at MS
        length = 9;
    }
    NSString *freesForDay = [[friend objectForKey:@"frees"]substringWithRange:NSMakeRange(startPoint, length)];
    for (int period = 0; period<length; period++) {
        if ([freesForDay characterAtIndex:period]=='1') {
            [[_favoriteUserFriendsByPeriod objectAtIndex:period]addObject:friend];
        }
    }
    [self.tableView reloadData];
}

-(void)removeFavoriteFriend:(PFUser *)friend{
   //NSLog(@"called removeFavoriteFriend");
    if (![[friend objectForKey:@"campus"]isEqualToString:[[PFUser currentUser]objectForKey:@"campus"]]) {
        return;
    }
    for(NSMutableArray *period in _favoriteUserFriendsByPeriod){
        [period removeObject:friend];
    }
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0,200,300,244)];
    tempView.backgroundColor=[UIColor clearColor];
    
    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,0,300,40)];
    tempLabel.backgroundColor=[UIColor clearColor];
    tempLabel.shadowColor = [UIColor blackColor];
    tempLabel.shadowOffset = CGSizeMake(0,2);
    tempLabel.textColor = [UIColor whiteColor]; //here you can change the text color of header.
    tempLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
    tempLabel.font = [UIFont boldSystemFontOfSize:20];
    tempLabel.text= [NSString stringWithFormat:@"Period %ld",(long)section+1];
    
    if ([[[PFUser currentUser]objectForKey:@"frees"]characterAtIndex:((_dayOfCycleUS-1)*9)+section]=='1') {
        tempLabel.textColor = [UIColor colorWithRed:0.09 green:0.76 blue:0.01 alpha:1.0];
    }
    else {
        //tempLabel.textColor = [UIColor colorWithRed:0.88 green:0.40 blue:0.40 alpha:1.0];
    }
    
    [tempView addSubview:tempLabel];
    
    return tempView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
