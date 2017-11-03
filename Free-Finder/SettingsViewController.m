//
//  SettingsViewController.m
//  Free-Finder
//
//  Created by Siddharth Kucheria on 4/12/15.
//  Copyright (c) 2015 DDD Development. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Settings";
    self.view.backgroundColor = [UIColor colorWithRed:0.26 green:0.26 blue:0.26 alpha:1.0];

    self.tableView.alwaysBounceVertical = false;
    
    UIImage *menuImage = [UIImage imageNamed:@"Menu_button_64.png"];//[UIColor colorWithRed:0.88 green:0.40 blue:0.40 alpha:1.0]
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setFrame:CGRectMake(0, 0, 25, 25)];
    [menuButton setBackgroundImage:menuImage forState:UIControlStateNormal];
    [menuButton addTarget:self.navigationController.parentViewController action:@selector(showSideBarMenu) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc]initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem = menuBarButton;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.navigationController setToolbarHidden:true];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 4;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setting"];
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"setting"];
    }
    
    cell.backgroundColor = [UIColor colorWithRed:0.26 green:0.26 blue:0.26 alpha:1.0];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    if (indexPath.row==0){
        cell.textLabel.text = @"Select Frees";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if(indexPath.row==1){
        cell.textLabel.text = @"Select Campus";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.row==2){
        cell.textLabel.text = @"Acknowledgements";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if(indexPath.row==3){
        cell.textLabel.text = @"Logout";
        cell.textLabel.textColor = [UIColor colorWithRed:0.88 green:0.40 blue:0.40 alpha:1.0];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row==0) {
        //edit free periods
        FreeSelectionViewController *freeSelection = [[FreeSelectionViewController alloc]init];
        [freeSelection setReferer:@"settings"];
        [self.navigationController pushViewController:freeSelection animated:true];
        /*PeriodSelectionViewController *periodsController = [[PeriodSelectionViewController alloc] initWithStyle:UITableViewStylePlain];
        [periodsController setReferer:@"settings"];
        [self.navigationController pushViewController:periodsController animated:YES];*/
    }
    else if(indexPath.row==1){
        //change campus
        UITableViewController *campusController = [[CampusSelectionViewController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:campusController animated:true];
    }
    else if (indexPath.row==2){
        //Acknowledgements
        UIViewController *ackController = [[AcknowledgementsViewController alloc]init];
        [self.navigationController pushViewController:ackController animated:true];
    }
    else if(indexPath.row==3){
        //logout of facebook
        NSString *logoutString = [NSString stringWithFormat:@"You are logged in as %@.\nAre you sure you want to logout?",[PFUser currentUser][@"fullname"]];
        UIAlertController *logoutAlert = [UIAlertController alertControllerWithTitle:nil message:logoutString preferredStyle:UIAlertControllerStyleActionSheet];
        [logoutAlert addAction:[UIAlertAction actionWithTitle:@"Logout" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
            FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc]init];
            [loginManager logOut];
            [PFUser logOut];
            UIViewController *loginController = [[LoginViewController alloc] init];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginController];
            navController.navigationBarHidden = true;
            [self presentViewController:navController animated:false completion:nil];
           //NSLog(@"LOGGED OUT!");
        }]];
        [logoutAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
           //NSLog(@"Cancel action selected");
        }]];
        [self presentViewController:logoutAlert animated:true completion:nil];
        
        

        
    }
}


-(void) handleBackButton:(id)sender{
    [self.navigationController popViewControllerAnimated:TRUE];
    
    return;
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
