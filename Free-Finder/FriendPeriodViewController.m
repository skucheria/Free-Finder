//
//  FriendPeriodViewController.m
//  Free-Finder
//
//  Created by Siddharth Kucheria on 4/22/15.
//  Copyright (c) 2015 DDD Development. All rights reserved.
//

#import "FriendPeriodViewController.h"


@interface FriendPeriodViewController ()

@property UITableView *tableView;

@property BOOL isFavorite;


@end


@implementation FriendPeriodViewController

- (id) init {
    if ((self = [super init])) {
        //_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height/2) style:UITableViewStylePlain];
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.allowsSelection = false;
        _tableView.backgroundColor = [UIColor colorWithRed:0.26 green:0.26 blue:0.26 alpha:1.0];
        [self.view addSubview:_tableView];
    }
    
    return self;
}

-(void) viewDidLoad{
//    self.view.backgroundColor = [UIColor redColor];//[UIColor colorWithRed:0.26 green:0.26 blue:0.26 alpha:1.0];
    
    UILabel *helloWorldLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 100)];
    NSString *friendFullName = self.activeFriend[@"fullname"];
    [helloWorldLabel setText:friendFullName];
    helloWorldLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:helloWorldLabel];
    
    self.tableView.alwaysBounceVertical = NO;
}

-(void) viewWillAppear:(BOOL)animated{
    NSMutableArray *favs = [[PFUser currentUser]objectForKey:@"favoriteFriends"];
    _isFavorite = [favs containsObject:[_activeFriend objectForKey:@"fullname"]];
   //NSLog(@"favs array = %@",favs);
   //NSLog(@"isFavorite = %@",[NSNumber numberWithBool:_isFavorite]);
    
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:true];
    
   //NSLog(@"dayOfCycle = %d",self.dayOfCycle);
   //NSLog(@"activeFriend = %@", self.activeFriend);
    
    
    FriendPeriodHeaderView *header = [[FriendPeriodHeaderView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 251)];
    [header setDayNumber:self.dayOfCycle];
    [header setActiveFriend: self.activeFriend];
    [_tableView setTableHeaderView:header];
    
    //_dayOfCycle = 0;
    
    if (self.dayOfCycle==0) {
        UIView* noClassView = [[UIView alloc]initWithFrame:CGRectMake(0, 250, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-250)];
        UILabel* noClassLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, noClassView.frame.size.height/3, noClassView.frame.size.width, 60)];
        noClassView.backgroundColor = [UIColor colorWithRed:0.26 green:0.26 blue:0.26 alpha:.9];
        noClassLabel.text = @"No Classes Today";
        noClassLabel.textAlignment = NSTextAlignmentCenter;
        noClassLabel.textColor = [UIColor whiteColor];
        noClassLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:30];
        
        [noClassView addSubview:noClassLabel];
        [_tableView addSubview:noClassView];
    }
    
    //BELOW IS STUFF FOR FAVORITES ICON/BUTTON
    
    
    if (_isFavorite) {
        UIImage *fullHeartImage = [UIImage imageNamed:@"Like-64.png"];//[UIColor colorWithRed:0.88 green:0.40 blue:0.40 alpha:1.0]
        UIButton *fullHeartButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [fullHeartButton setFrame:CGRectMake(0, 0, 40, 40)];
        [fullHeartButton setBackgroundImage:fullHeartImage forState:UIControlStateNormal];
        [fullHeartButton addTarget:self action:@selector(handleFavoritesHeart:) forControlEvents:UIControlEventTouchDown];
        UIBarButtonItem *fullHeart = [[UIBarButtonItem alloc]initWithCustomView:fullHeartButton];
        
        self.navigationItem.rightBarButtonItem = fullHeart;
    }
    else {
        UIImage *emptyHeartImage = [UIImage imageNamed:@"Like Outline-64.png"];//[UIColor colorWithRed:0.88 green:0.40 blue:0.40 alpha:1.0]
        UIButton *emptyHeartButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [emptyHeartButton setFrame:CGRectMake(0, 0, 40, 40)];
        [emptyHeartButton setBackgroundImage:emptyHeartImage forState:UIControlStateNormal];
        [emptyHeartButton addTarget:self action:@selector(handleFavoritesHeart:) forControlEvents:UIControlEventTouchDown];
        UIBarButtonItem *emptyHeart = [[UIBarButtonItem alloc]initWithCustomView:emptyHeartButton];
        
        self.navigationItem.rightBarButtonItem = emptyHeart;
    }
    
    
    
    
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([[_activeFriend objectForKey:@"campus"]isEqualToString:@"MS"]) {
        return 9;
    }
    else{
        return 8;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"period"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"period"];
    }
    cell.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:0.26 green:0.26 blue:0.26 alpha:1.0];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    int startPoint = 9 * (_dayOfCycle - 1);
    int endPoint = 8;
    if ([[_activeFriend objectForKey:@"campus"]isEqualToString:@"MS"]) {
        endPoint=9;
    }
    NSString *friendFreesForDay = [[_activeFriend objectForKey:@"frees"]substringWithRange:NSMakeRange(startPoint, endPoint)];
    NSString *currentUserFreesForDay = [[[PFUser currentUser]objectForKey:@"frees"]substringWithRange:NSMakeRange(startPoint, endPoint)];
    if ([friendFreesForDay characterAtIndex:indexPath.row]=='1') {
        cell.textLabel.textColor = [UIColor greenColor];
        if ([currentUserFreesForDay characterAtIndex:indexPath.row]=='1') {
            //cell.accessoryType = UITableViewCellAccessoryCheckmark;
            CGRect frame = cell.accessoryView.frame;
            frame.size.width = 30;
            frame.size.height = 30;
            UILabel* accessoryLabel = [[UILabel alloc]initWithFrame:frame];
            cell.accessoryView.frame = frame;
            accessoryLabel.text = @"👫";
            cell.accessoryView = accessoryLabel;
        }
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Period %ld", (long)indexPath.row+1];
    
    return cell;
}

-(void) handleBackButton:(id)sender{
    [self.navigationController popViewControllerAnimated:TRUE];
    
    return;
}


-(void) handleFavoritesHeart:(id)sender{
    LoadingIndicatorView *loadingView = [[LoadingIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 75, 75)];
    [loadingView setCenter:self.navigationController.view.center];
    [loadingView.loadingIndicator startAnimating];
    [self.view addSubview:loadingView];
    
    PFUser *currentUser = [PFUser currentUser];
    NSMutableArray *favoritesArray = [currentUser objectForKey:@"favoriteFriends"];
    
    if(self.isFavorite==false){//set as favorite
        UIImage *fullHeartImage = [UIImage imageNamed:@"Like-64.png"];
        UIButton *fullHeartButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [fullHeartButton addTarget:self action:@selector(handleFavoritesHeart:) forControlEvents:UIControlEventTouchDown];
        [fullHeartButton setFrame:CGRectMake(0, 0, 40, 40)];
        [fullHeartButton setBackgroundImage:fullHeartImage forState:UIControlStateNormal];
        UIBarButtonItem *fullHeart = [[UIBarButtonItem alloc]initWithCustomView:fullHeartButton];
        
        self.navigationItem.rightBarButtonItem = fullHeart;
        self.isFavorite = true;
        [favoritesArray addObject:[_activeFriend objectForKey:@"fullname"]];
    }
    else{//remove as favorite
        UIImage *emptyHeartImage = [UIImage imageNamed:@"Like Outline-64.png"];//[UIColor colorWithRed:0.88 green:0.40 blue:0.40 alpha:1.0]
        UIButton *emptyHeartButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [emptyHeartButton setFrame:CGRectMake(0, 0, 40, 40)];
        [emptyHeartButton setBackgroundImage:emptyHeartImage forState:UIControlStateNormal];
        [emptyHeartButton addTarget:self action:@selector(handleFavoritesHeart:) forControlEvents:UIControlEventTouchDown];
        UIBarButtonItem *emptyHeart = [[UIBarButtonItem alloc]initWithCustomView:emptyHeartButton];
        
        self.navigationItem.rightBarButtonItem = emptyHeart;
        self.isFavorite = false;
        [favoritesArray removeObject:[_activeFriend objectForKey:@"fullname"]];
    }
    currentUser[@"favoriteFriends"] = favoritesArray;
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError* error){
        if (!error) {
            PeriodViewController *previousView = [[self.navigationController viewControllers]objectAtIndex:0];
            if (self.isFavorite) {
                [previousView addFavoriteFriend:self.activeFriend];
            }
            else{
                [previousView removeFavoriteFriend:self.activeFriend];
            }
            
            [loadingView.loadingIndicator stopAnimating];
            [loadingView removeFromSuperview];
        }
        
        else {
           //NSLog(@"Error saving favorite update: %@ %@",error,error.userInfo);
        }
    }];
    return;
}

/*-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
 }*/


-(void)handleSendMessageButton:(id)sender{
    NSString *message = @"wants to hang out with you in";
    NSString *messageName = [NSString stringWithFormat:@"%@ %@",[PFUser currentUser][@"fullname"],message];
    NSString *messageNamePlus = [messageName stringByAppendingString:@" the"];
    
    UIAlertController *locationSelector = [UIAlertController alertControllerWithTitle:@"Your message:" message:messageNamePlus preferredStyle:UIAlertControllerStyleActionSheet];
    [locationSelector addAction:[UIAlertAction actionWithTitle:@"Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self requestSendMessageWithLocationString:@"the library" senderName: [PFUser currentUser][@"fullname"] bodyString:message];
    }]];
    [locationSelector addAction:[UIAlertAction actionWithTitle:@"Quad" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self requestSendMessageWithLocationString:@"the quad" senderName: [PFUser currentUser][@"fullname"] bodyString:message];
    }]];
    [locationSelector addAction:[UIAlertAction actionWithTitle:@"Lounge" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self requestSendMessageWithLocationString:@"the lounge" senderName: [PFUser currentUser][@"fullname"] bodyString:message];
    }]];
    [locationSelector addAction:[UIAlertAction actionWithTitle:@"Other..." style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        UIAlertController *otherSelector = [UIAlertController alertControllerWithTitle:@"Your message" message:message preferredStyle:UIAlertControllerStyleAlert];
        [otherSelector addTextFieldWithConfigurationHandler:^(UITextField *textField){
            textField.placeholder = @"Enter other location";
        }];
        [otherSelector addAction:[UIAlertAction actionWithTitle:@"Send" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
           //NSLog(@"textField.text = %@",((UITextField *)otherSelector.textFields.firstObject).text);
            [self requestSendMessageWithLocationString:((UITextField *)otherSelector.textFields.firstObject).text senderName: [PFUser currentUser][@"fullname"] bodyString:message];
        }]];
        [otherSelector addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            
        }]];
        [self.navigationController presentViewController:otherSelector animated:NO completion:nil];
    }]];
    /*[locationSelector addAction:[UIAlertAction actionWithTitle:@"Chalmers" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self requestSendMessageWithLocationString:@"Chalmers"];
    }]];
    [locationSelector addAction:[UIAlertAction actionWithTitle:@"Seaver" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self requestSendMessageWithLocationString:@"Seaver"];
    }]];
    [locationSelector addAction:[UIAlertAction actionWithTitle:@"Rugby" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self requestSendMessageWithLocationString:@"Rugby"];
    }]];
    [locationSelector addAction:[UIAlertAction actionWithTitle:@"Munger" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self requestSendMessageWithLocationString:@"Munger"];
    }]];
    [locationSelector addAction:[UIAlertAction actionWithTitle:@"Taper Gym" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self requestSendMessageWithLocationString:@"Taper Gym"];
    }]];
    [locationSelector addAction:[UIAlertAction actionWithTitle:@"Hamilton Gym" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self requestSendMessageWithLocationString:@"Hamilton Gym"];
    }]];
    [locationSelector addAction:[UIAlertAction actionWithTitle:@"Secret Place" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self requestSendMessageWithLocationString:@"the secret place 😎"];
    }]];*/
    [locationSelector addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:locationSelector animated:true completion:nil];
}

-(void)requestSendMessageWithLocationString:(NSString *)location senderName:(NSString *)name bodyString:(NSString *)body{
   //NSLog(@"body %@",location);
    NSString *messageText = [body stringByAppendingString:[NSString stringWithFormat:@" %@",location]];
    
    NSMutableArray *objectsArray = [NSMutableArray array];
    NSMutableArray *keysArray = [NSMutableArray array];
    [objectsArray addObject:self.activeFriend.objectId];
    [keysArray addObject:@"recipientObjectId"];
    [objectsArray addObject:[PFUser currentUser].objectId];
    [keysArray addObject:@"senderObjectId"];
    [objectsArray addObject:messageText];
    [keysArray addObject:@"messageText"];
    [objectsArray addObject:name];
    [keysArray addObject:@"senderFullName"];
    NSDictionary *messageDictionary = [NSDictionary dictionaryWithObjects:objectsArray forKeys:keysArray];
    [PFCloud callFunctionInBackground:@"requestHangoutNotification" withParameters:messageDictionary block:^(id object, NSError* error){
        if (!error) {
            
        }
        else if([error.userInfo[@"error"]intValue]==2){
            UIAlertController *profanityAlert = [UIAlertController alertControllerWithTitle:@"Message could not be sent" message:@"Please rephrase your location without using expletives" preferredStyle:UIAlertControllerStyleAlert];
            [profanityAlert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
            [self.navigationController presentViewController:profanityAlert animated:NO completion:nil];
        }
        else{
           //NSLog(@"Error in requestHangoutNotification: %@ %@",error,error.userInfo);
            UIAlertController *unknown = [UIAlertController alertControllerWithTitle:@"Message could not be sent" message:@"An unknown error has occured. Please try updating your version of Free Finder" preferredStyle:UIAlertControllerStyleAlert];
            [unknown addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
            [self.navigationController presentViewController:unknown animated:NO completion:nil];
        }
    }];
}
@end