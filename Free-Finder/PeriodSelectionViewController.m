//
//  PeriodSelectionViewController.m
//  Free-Finder
//
//  Created by Will Burford on 3/25/15.
//  Copyright (c) 2015 DDD Development. All rights reserved.
//

#import "PeriodSelectionViewController.h"

@interface PeriodSelectionViewController ()

@property NSArray *periodsInDatabaseOnLoad;

@property BOOL didLoadPeriodsInDatabaseOnLoad;

@property UIActivityIndicatorView *loadingIndicator;

@property NSMutableArray *selectedFreesBools;

@end

@implementation PeriodSelectionViewController

- (id) init {
    if ((self = [super init])) {
        //do stuff on init
    }
    return self;
}

- (void)handleSaveButton:(id)sender{
   //NSLog(@"Save button pressed");
    //self.view.userInteractionEnabled = false;
    self.navigationController.view.userInteractionEnabled=false;
    UIActivityIndicatorView *loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    /*loadingIndicator.backgroundColor = [UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1.0];
    loadingIndicator.hidesWhenStopped = true;
    loadingIndicator.exclusiveTouch = true;
    [loadingIndicator setCenter:self.navigationController.view.center];
    [self.view addSubview:loadingIndicator];
    [loadingIndicator startAnimating];*/
    //UILabel *testLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 100)];
    //testLabel.backgroundColor = [UIColor colorWithRed:0.60 green:0.00 blue:1.00 alpha:1.0];
    //[self.view addSubview:testLabel];
    //add parse stuff here to save the selections
    //https://parse.com/docs/ios_guide#objects/iOS
    //[NSThread sleepForTimeInterval:5];
    
    PFUser *currentUser = [PFUser currentUser];
    
    
    /*PFObject *testFree = [PFObject objectWithClassName:@"Free"];
    testFree[@"user"] = currentUser;
    NSMutableArray *predicateParts = [NSMutableArray array];
    [predicateParts addObject:[NSPredicate predicateWithFormat:@"periodNumber = %ld",2]];
    [predicateParts addObject:[NSPredicate predicateWithFormat:@"day = %ld", 1]];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicateParts];
    PFQuery *testQuery = [PFQuery queryWithClassName:@"Period"predicate:predicate];
    [testQuery findObjectsInBackgroundWithBlock:^(NSArray *period, NSError *error){
        if(!error){
           //NSLog(@"No error in testQuery");
            testFree[@"period"] = period.firstObject;
            [testFree saveInBackgroundWithBlock:^(bool succeeded, NSError *error){
                if(succeeded){
                   //NSLog(@"No error in testFree save");
                }
                else{
                   //NSLog(@"Error in save: %@ %@", error, [error userInfo]);
                }
            }];
            //this query should be within the save's if(succeeded) to ensure the save finishes
            PFQuery *query = [PFQuery queryWithClassName:@"Free"];
            [query whereKey:@"user" equalTo:currentUser];
            [query findObjectsInBackgroundWithBlock:^(NSArray *prexistingFrees, NSError *error){
                if(!error){
                   //NSLog(@"Found saved free: %@", prexistingFrees.firstObject);
                }
                else{
                   //NSLog(@"Error in save: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else{
           //NSLog(@"Error in query: %@ %@", error, [error userInfo]);
        }
        [NSThread sleepForTimeInterval:1];
        //then return to the FriendsTable
       //NSLog(@"Will return to FriendsTable here");
    }];*/
    
    PFQuery *prexistingFreesQuery = [PFQuery queryWithClassName:@"Free"];
    [prexistingFreesQuery whereKey:@"user" equalTo:currentUser];
    __block NSArray *prexistingFreesArray = [NSArray array];

    prexistingFreesArray = [prexistingFreesQuery findObjects];
    
    NSMutableArray *selectedFreesArray = [NSMutableArray array];
    for (int counter = 0; counter<self.selectedFreesBools.count; counter++) {
        if ([[self.selectedFreesBools objectAtIndex:counter] boolValue]==true) {
            NSMutableArray *predicateParts = [NSMutableArray array];
            [predicateParts addObject:[NSPredicate predicateWithFormat:@"periodNumber = %ld",(counter%8)+1]];
            [predicateParts addObject:[NSPredicate predicateWithFormat:@"day = %ld", (counter/8)+1]];
            NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicateParts];
            PFQuery *query = [PFQuery queryWithClassName:@"Period"predicate:predicate];
            NSArray *period = [query findObjects];
            
            PFObject *selectedFree = [PFObject objectWithClassName:@"Free"];
            selectedFree[@"user"] = currentUser;
            selectedFree[@"period"] = period.firstObject;
            [selectedFreesArray addObject:selectedFree];
        }
    }
    
    NSMutableArray *freesToDelete = [NSMutableArray arrayWithArray:prexistingFreesArray];
    //selectedFreesArray = frees to save
    for (int counterDelete=0; counterDelete<freesToDelete.count; counterDelete++) {
        bool didDelete = false;
        for (int counterSave=0; counterSave<selectedFreesArray.count; counterSave++) {
            if(selectedFreesArray.count==0 || freesToDelete.count==0){
                break;
            }
            PFObject *freeInDelete = [freesToDelete objectAtIndex:counterDelete];
            PFObject *periodInDelete = [freeInDelete objectForKey:@"period"];
            PFObject *freeInSave = [selectedFreesArray objectAtIndex:counterSave];
            PFObject *periodInSave = [freeInSave objectForKey:@"period"];
            [periodInDelete fetchIfNeeded];
            [periodInSave fetchIfNeeded];
            if(([periodInDelete objectForKey:@"periodNumber"] == [periodInSave objectForKey:@"periodNumber"])&& ([periodInDelete objectForKey:@"day"] == [periodInSave objectForKey:@"day"])){
                [freesToDelete removeObjectAtIndex:counterDelete];
                [selectedFreesArray removeObjectAtIndex:counterSave];
                counterSave--;
                didDelete=true;
                break;
            }
        }
        if (didDelete) {
            counterDelete--;
        }
    }
    
    //NSLog(@"freesToDelete: %@",freesToDelete);
   //NSLog(@"freesToDelete.count = %ld", (long)freesToDelete.count);
    bool successfulDelete = [PFObject deleteAll:freesToDelete];
    if (!successfulDelete) {
       //NSLog(@"delete not successful");
    }
    
    //NSLog(@"selectedFreesArray: %@",selectedFreesArray);
    bool successfulSave = [PFObject saveAll:selectedFreesArray];
    if (!successfulSave) {
       //NSLog(@"save not successful");
    }
    
    [loadingIndicator stopAnimating];
    [loadingIndicator removeFromSuperview];
    
    self.navigationController.view.userInteractionEnabled = true;
    
    if ([_referer isEqualToString:@"login"]) {
        UITableViewController *tableViewController = [[FriendViewController alloc] initWithStyle:UITableViewStyleGrouped];
        UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:tableViewController];
        [self presentViewController:controller animated:NO completion:nil];
    }
    else if ([_referer isEqualToString:@"settings"]){
        [self.navigationController popViewControllerAnimated:TRUE];
    }
    
    return;
}
//end of save button method

-(void)handleCancelButton:(id)sender{
    self.navigationController.view.userInteractionEnabled = true;
    
    if ([_referer isEqualToString:@"login"]) {
        UITableViewController *tableViewController = [[FriendViewController alloc] initWithStyle:UITableViewStyleGrouped];
        UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:tableViewController];
        [self presentViewController:controller animated:NO completion:nil];
    }
    else if ([_referer isEqualToString:@"settings"]){
        [self.navigationController popViewControllerAnimated:TRUE];
    }

    return;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;//5 days
}
//for some reason this breaks the save button
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Day %ld",(long)section+1];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *campus = [[PFUser currentUser] objectForKey:@"campus"];
    //campus = @"MS";
    if ([campus isEqualToString:@"US"]) {
       //NSLog(@"Upper School Brah");
        return 8;
    }
    else{
       //NSLog(@"No es el upper school");
        return 9;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.periodsInDatabaseOnLoad==nil){
       //NSLog(@"periodsInDatabaseOnLoad==nil when cellForRowAtIndexPath is called");
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"period"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"period"];
    }
    cell.backgroundColor = [UIColor colorWithRed:0.26 green:0.26 blue:0.26 alpha:1.0];

    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = [NSString stringWithFormat:@"Period %ld", (long)indexPath.row+1];
    cell.textLabel.textColor = [UIColor whiteColor];

    long index = indexPath.section*8 + indexPath.row;
    if ([[self.selectedFreesBools objectAtIndex:index] boolValue] == true){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
       //NSLog(@"Index %ld is true",index);
    }
    return cell;
    }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //switch b/w selected (w/ checkmark) or deseleted (w/o checkmark)
    UITableViewCell *touchedCell =[tableView cellForRowAtIndexPath:indexPath];
    if(touchedCell.accessoryType==UITableViewCellAccessoryNone){
        touchedCell.accessoryType = UITableViewCellAccessoryCheckmark;
        long index = indexPath.section*8 + indexPath.row;
        [self.selectedFreesBools replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:true]];
    }
    else{
        touchedCell.accessoryType=UITableViewCellAccessoryNone;
        long index = indexPath.section*8 + indexPath.row;
        [self.selectedFreesBools replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:false]];
    }
    
    //NSLog(@"Day%ldPeriod%ld was touched", indexPath.section+1, indexPath.row+1);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.26 green:0.26 blue:0.26 alpha:1.0];

    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.loadingIndicator.backgroundColor = [UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1.0];
    self.loadingIndicator.hidesWhenStopped = true;
    self.loadingIndicator.exclusiveTouch = true;
    [self.loadingIndicator setCenter:self.navigationController.view.center];
    [self.view addSubview:self.loadingIndicator];
    [self.loadingIndicator startAnimating];


    self.didLoadPeriodsInDatabaseOnLoad = false;
    PFQuery *prexistingFreesQuery = [PFQuery queryWithClassName:@"Free"];
    [prexistingFreesQuery whereKey:@"user" equalTo: [PFUser currentUser]];
    NSMutableArray *prexistingFreesArray = [NSMutableArray arrayWithArray:[prexistingFreesQuery findObjects]];
    NSMutableArray *prexistingPeriods = [NSMutableArray array];
    for(int counter=0;counter<prexistingFreesArray.count;counter++){
        [prexistingPeriods addObject:[[prexistingFreesArray objectAtIndex:counter]valueForKey:@"period"]];
        [[prexistingPeriods objectAtIndex:counter]fetchIfNeeded];
    }
    self.periodsInDatabaseOnLoad = prexistingPeriods;
    self.didLoadPeriodsInDatabaseOnLoad = true;
    
    self.selectedFreesBools = [NSMutableArray array];
    for (int x=0; x<(5*8); x++) {
        bool didAdd = false;
        for (int counter = 0; counter<self.periodsInDatabaseOnLoad.count; counter++) {
            if ([[[self.periodsInDatabaseOnLoad objectAtIndex:counter]valueForKey:@"day"]integerValue]-1==x/8 && [[[self.periodsInDatabaseOnLoad objectAtIndex:counter]valueForKey:@"periodNumber"]integerValue]-1==x%8){
                [self.selectedFreesBools addObject:[NSNumber numberWithBool:true]];
                didAdd =true;
            }
        }
        if (!didAdd) {
            [self.selectedFreesBools addObject:[NSNumber numberWithBool:false]];
        }
    }
    
    self.title = @"Select Frees";
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(handleSaveButton:)];
    saveButton.tintColor = [UIColor colorWithRed:0.88 green:0.40 blue:0.40 alpha:1.0];

    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(handleCancelButton:)];
    cancelButton.tintColor = [UIColor colorWithRed:0.88 green:0.40 blue:0.40 alpha:1.0];

    self.navigationItem.rightBarButtonItem = saveButton;
    if ([_referer isEqualToString:@"settings"]) {
        self.navigationItem.leftBarButtonItem = cancelButton;

    }
    [self.loadingIndicator stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
