//
//  CampusSelectionViewController.m
//  Free-Finder
//
//  Created by Will Burford on 4/25/15.
//  Copyright (c) 2015 DDD Development. All rights reserved.
//

#import "CampusSelectionViewController.h"

@interface CampusSelectionViewController ()


@property(nonatomic, retain) UIColor *tintColor;

@property NSString* selectedCampus;

@end

@implementation CampusSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Select Campus";
  self.view.backgroundColor = [UIColor colorWithRed:0.26 green:0.26 blue:0.26 alpha:1.0];

    self.selectedCampus = [[PFUser currentUser] objectForKey:@"campus"];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(handleSaveButton:)];
    saveButton.tintColor = [UIColor colorWithRed:0.88 green:0.40 blue:0.40 alpha:1.0];

    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(handleCancelButton:)];
    cancelButton.tintColor = [UIColor colorWithRed:0.88 green:0.40 blue:0.40 alpha:1.0];

    self.navigationItem.rightBarButtonItem = saveButton;
    self.navigationItem.leftBarButtonItem = cancelButton;
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"campus"];
    
 cell.backgroundColor = [UIColor colorWithRed:0.26 green:0.26 blue:0.26 alpha:1.0];
    cell.textLabel.textColor = [UIColor whiteColor];
    if (indexPath.row==0){
        cell.textLabel.text = @"Middle School";
        if ([self.selectedCampus isEqual:@"MS"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    else if(indexPath.row==1){
        cell.textLabel.text = @"Upper School";
        if ([self.selectedCampus isEqual:@"US"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row==0) {
        self.selectedCampus = @"MS";
    }
    else if(indexPath.row==1){
        self.selectedCampus = @"US";
    }
    [self.tableView reloadData];
}

-(void) handleSaveButton:(id)sender{
    if ([self.selectedCampus isEqual:@"MS"]) {
        UIAlertController *campusAlert = [UIAlertController alertControllerWithTitle:@"Campus Selection" message:@"The Middle School campus is not currently supported. Please check back soon for an update." preferredStyle:UIAlertControllerStyleActionSheet];
        [campusAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:campusAlert animated:true completion:nil];
        return;
    }
    
    LoadingIndicatorView *loadingView = [[LoadingIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 75, 75)];
    [loadingView setCenter:self.navigationController.view.center];
    [loadingView.loadingIndicator startAnimating];
    [self.view addSubview:loadingView];
    
    PFUser *currentUser = [PFUser currentUser];
    currentUser[@"campus"] = self.selectedCampus;
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError* error){
        if(succeeded){
            [loadingView.loadingIndicator stopAnimating];
            [loadingView removeFromSuperview];
            [self.navigationController popViewControllerAnimated:TRUE];
        }
        else if (error) {
          //NSLog(@"Error in saving changing campus: %@ %@",error, error.userInfo);
        }
    }];
}

-(void) handleCancelButton:(id)sender{
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
