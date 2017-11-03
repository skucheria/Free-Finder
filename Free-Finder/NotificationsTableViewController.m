//
//  NotificationsTableViewController.m
//  Free-Finder
//
//  Created by Will Burford on 7/27/15.
//  Copyright (c) 2015 DDD Development. All rights reserved.
//

#import "NotificationsTableViewController.h"

@interface NotificationsTableViewController ()

@property (strong,nonatomic) NSMutableArray* hangoutsArray;
@property (strong,nonatomic) NSMutableArray* responsesArray;

@end

@implementation NotificationsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _hangoutsArray = [NSMutableArray array];
    _responsesArray = [NSMutableArray array];
    UIImage *menuImage = [UIImage imageNamed:@"Menu_button_64.png"];//[UIColor colorWithRed:0.88 green:0.40 blue:0.40 alpha:1.0]
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setFrame:CGRectMake(0, 0, 25, 25)];
    [menuButton setBackgroundImage:menuImage forState:UIControlStateNormal];
    [menuButton addTarget:(UmbrellaViewController *)self.navigationController.parentViewController action:@selector(showSideBarMenu) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc]initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem = menuBarButton;
    
    self.title = @"Notifications";
    //    [self.tableView setRowHeight:150];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:0.26 green:0.26 blue:0.26 alpha:1.0]];
    self.tableView.allowsSelection = false;
    
    PFQuery *hangoutsQuery = [PFQuery queryWithClassName:@"Hangouts"];
    [hangoutsQuery whereKey:@"recipientObjectId" equalTo:[PFUser currentUser].objectId];
    [hangoutsQuery orderByAscending:@"createdAt"];
    [hangoutsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects,NSError *error){
        if (!error) {
            _hangoutsArray = [NSMutableArray arrayWithArray:objects];
           //NSLog(@"hangoutsArray = %@",_hangoutsArray);
            [self.tableView reloadData];
        }
        else {
           //NSLog(@"Error in hangoutsQuery: %@ %@",error,error.userInfo);
        }
    }];
    PFQuery *responsesQuery = [PFQuery queryWithClassName:@"Responses"];
    [responsesQuery whereKey:@"recipientObjectId" equalTo:[PFUser currentUser].objectId];
    [responsesQuery orderByAscending:@"createdAt"];
    [responsesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects,NSError* error){
        if (!error) {
            _responsesArray = [NSMutableArray arrayWithArray:objects];
            [self.tableView reloadData];
        }
        else{
           //NSLog(@"Error in responsesQuery: %@ %@",error,error.userInfo);
        }
    }];
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    [[PFInstallation currentInstallation]setBadge:0];
    [[PFInstallation currentInstallation]saveInBackgroundWithBlock:^(BOOL succeeded, NSError* error){
        if (error) {
           //NSLog(@"error in installation save %@ %@",error,error.userInfo);
        }
    }];
    
    UIRefreshControl* refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(handleRefreshPull:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return _hangoutsArray.count;
    }
    else if (section==1){
        return _responsesArray.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1) {
        ResponseTableViewCell *cell = [[ResponseTableViewCell alloc]init];
        PFObject *response = [_responsesArray objectAtIndex:indexPath.row];
        [cell setResponse:response];
        
        NSDate* ts_utc = [response createdAt];
        NSDateFormatter* df_utc = [[NSDateFormatter alloc] init];
        [df_utc setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        [df_utc setDateFormat:@"h:mm a"];
        NSDateFormatter* df_local = [[NSDateFormatter alloc] init];
        [df_local setTimeZone:[NSTimeZone localTimeZone]];
        [df_local setDateFormat:@"h:mm a"];
        //NSString* ts_utc_string = [df_utc stringFromDate:ts_utc];
        NSString* ts_local_string = [df_local stringFromDate:ts_utc];
       //NSLog(@"utc_string = %@",ts_utc_string);
        [cell setLocalTimeString:ts_local_string];
        
        cell.buttonDelegate = self;
        return cell;
    }
    
    NotificationsTableViewCell *cell;// = [tableView dequeueReusableCellWithIdentifier:@"notification" forIndexPath:indexPath];
    if (!cell) {
        cell=[[NotificationsTableViewCell alloc]init];
    }
    PFObject *hangout = [_hangoutsArray objectAtIndex:indexPath.row];
    [cell setNotificationString:[[hangout objectForKey:@"senderFullName"]stringByAppendingFormat:@" %@",[hangout objectForKey:@"messageText"]]];
    [cell setHangout:hangout];
    
    NSDate* ts_utc = [hangout createdAt];
    NSDateFormatter* df_utc = [[NSDateFormatter alloc] init];
    [df_utc setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [df_utc setDateFormat:@"h:mm a"];
    NSDateFormatter* df_local = [[NSDateFormatter alloc] init];
    [df_local setTimeZone:[NSTimeZone localTimeZone]];
    [df_local setDateFormat:@"h:mm a"];
    //NSString* ts_utc_string = [df_utc stringFromDate:ts_utc];
    NSString* ts_local_string = [df_local stringFromDate:ts_utc];
   //NSLog(@"utc_string = %@",ts_utc_string);
    [cell setLocalTimeString:ts_local_string];
    
    cell.buttonDelegate = self;
    
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return @"Responses";
    }
    return @"Requests";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:true];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        PFObject *response = [_responsesArray objectAtIndex:indexPath.row];
        NSString* responseString = [NSString stringWithFormat:@"%@ %@",[response objectForKey:@"senderFullName"],[response objectForKey:@"messageText"]];
        NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
        CGSize labelSize = (CGSize){self.view.bounds.size.width-20, FLT_MAX};
        UIFont *font = [UIFont systemFontOfSize:17];
        CGRect rect = [responseString boundingRectWithSize:labelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:context];
        int height = rect.size.height + 30 + 45;
       //NSLog(@"height of response = %d",height);
        return  height;
    }
   //NSLog(@"finding height for indexPath %@",indexPath);
    PFObject *hangout = [_hangoutsArray objectAtIndex:indexPath.row];
   //NSLog(@"hangout = %@",hangout);
    NSString *notificationString = [[hangout objectForKey:@"senderFullName"]stringByAppendingFormat:@" %@",[hangout objectForKey:@"messageText"]];
   //NSLog(@"notificationString = %@",notificationString);
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize labelSize = (CGSize){self.view.bounds.size.width-20, FLT_MAX};
    UIFont *font = [UIFont systemFontOfSize:17];
    CGRect rect = [notificationString boundingRectWithSize:labelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:context];
    int height = rect.size.height + 30 + 30 + 20;
   //NSLog(@"height = %d",height);
    return height;
}

-(void)handleRefreshPull:(UIRefreshControl*)refreshControl{
    [refreshControl beginRefreshing];
    PFQuery *hangoutsQuery = [PFQuery queryWithClassName:@"Hangouts"];
    [hangoutsQuery whereKey:@"recipientObjectId" equalTo:[PFUser currentUser].objectId];
    [hangoutsQuery orderByAscending:@"createdAt"];
    [hangoutsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects,NSError *error){
        if (!error) {
            _hangoutsArray = [NSMutableArray arrayWithArray:objects];
            
            PFQuery *responsesQuery = [PFQuery queryWithClassName:@"Responses"];
            [responsesQuery whereKey:@"recipientObjectId" equalTo:[PFUser currentUser].objectId];
            [responsesQuery orderByAscending:@"createdAt"];
            [responsesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects,NSError* error){
                if (!error) {
                    _responsesArray = [NSMutableArray arrayWithArray:objects];
                    [self.tableView reloadData];
                    [refreshControl endRefreshing];
                }
                else{
                   //NSLog(@"Error in responsesQuery: %@ %@",error,error.userInfo);
                }
            }];
        }
        else {
           //NSLog(@"Error in hangoutsQuery: %@ %@",error,error.userInfo);
        }
    }];
}

-(void)removeHangout:(PFObject*)hangoutToDelete{
    [hangoutToDelete deleteInBackgroundWithBlock:^(BOOL succeeded, NSError* error){
        if (!error) {
            [_hangoutsArray removeObject:hangoutToDelete];
            [self.tableView reloadData];        }
        else {
           //NSLog(@"error in deleting hangout %@ %@",error,error.userInfo);
        }
    }];
}

-(void)removeHangoutResponse:(PFObject*)responseToRemove{
    [responseToRemove deleteInBackgroundWithBlock:^(BOOL succeeded,NSError* error){
        if (!error) {
            [_responsesArray removeObject:responseToRemove];
            [self.tableView reloadData];
        }
        else {
           //NSLog(@"error in deleting response %@ %@",error,error.userInfo);
        }
    }];
}

-(void)respondToHangout:(PFObject *)hangoutToAccept{
    NSString* title = [NSString stringWithFormat:@"Respond to %@",[hangoutToAccept objectForKey:@"senderFullName"]];
    UIAlertController* responseSelector = [UIAlertController alertControllerWithTitle:title message:NULL preferredStyle:UIAlertControllerStyleActionSheet];
    [responseSelector addAction:[UIAlertAction actionWithTitle:@"On my way" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self requestResponseToHangoutWithMessage:@"On my way" hangout:hangoutToAccept];
    }]];
    [responseSelector addAction:[UIAlertAction actionWithTitle:@"Coming soon" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self requestResponseToHangoutWithMessage:@"Coming soon" hangout:hangoutToAccept];
    }]];
    [responseSelector addAction:[UIAlertAction actionWithTitle:@"Can't come right now" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self requestResponseToHangoutWithMessage:@"Can't come right now" hangout:hangoutToAccept];
    }]];
    [responseSelector addAction:[UIAlertAction actionWithTitle:@"Custom..." style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        UIAlertController *customSelector = [UIAlertController alertControllerWithTitle:NULL message:@"Custom response" preferredStyle:UIAlertControllerStyleAlert];
        [customSelector addTextFieldWithConfigurationHandler:^(UITextField *textField){
            textField.placeholder = @"Enter your response";
        }];
        [customSelector addAction:[UIAlertAction actionWithTitle:@"Send" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
           //NSLog(@"textField.text = %@",((UITextField *)customSelector.textFields.firstObject).text);
            [self requestResponseToHangoutWithMessage:((UITextField *)customSelector.textFields.firstObject).text hangout:hangoutToAccept];
        }]];
        [customSelector addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            
        }]];
        [self.navigationController presentViewController:customSelector animated:NO completion:nil];
    }]];
    [responseSelector addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:responseSelector animated:YES completion:nil];
}

-(void)requestResponseToHangoutWithMessage:(NSString*)messageText hangout:(PFObject*)hangoutToAccept{
    NSMutableArray *objectsArray = [NSMutableArray array];
    NSMutableArray *keysArray = [NSMutableArray array];
    [objectsArray addObject:[hangoutToAccept objectForKey:@"senderObjectId"]];
    [keysArray addObject:@"recipientObjectId"];
    [objectsArray addObject:[PFUser currentUser].objectId];
    [keysArray addObject:@"senderObjectId"];
    [objectsArray addObject:messageText];
    [keysArray addObject:@"messageText"];
    [objectsArray addObject:[[PFUser currentUser]objectForKey:@"fullname"]];
    [keysArray addObject:@"senderFullName"];
    [objectsArray addObject:hangoutToAccept.objectId];
    [keysArray addObject:@"hangoutObjectId"];
    NSDictionary *messageDictionary = [NSDictionary dictionaryWithObjects:objectsArray forKeys:keysArray];
    [PFCloud callFunctionInBackground:@"requestHangoutResponse" withParameters:messageDictionary block:^(id object, NSError* error){
        if (!error) {
            [hangoutToAccept setObject:[NSNumber numberWithBool:true] forKey:@"responded"];
            [self.tableView reloadData];
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

/*
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
